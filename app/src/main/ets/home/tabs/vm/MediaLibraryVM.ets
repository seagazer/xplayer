import { ColumnValueType, DbHelper, Table } from '../../../base/db/DbHelper'
import { XLogger } from '../../../base/extensions/XLogger'
import { MediaFile } from '../../../base/model/MediaFile'
import { IVM } from '../../../base/IVM'
import { Album } from '../../../base/model/Album'

const TAG = "[MediaLibraryVM]"

/**
 *
 * Author: Seagazer
 * Date: 2025/12/16
 */
@ObservedV2
export class MediaLibraryVM implements IVM {
    @Trace isEmpty: boolean = true
    @Trace mediaList: MediaFile[] = []
    @Trace albumList: Album[] = []
    private table?: Table<MediaFile> = undefined

    async onCreate(context: UIContext) {
        XLogger.d(TAG, "onCreate")
        this.table = new Table("media_library")
        this.table.addColumn("title", ColumnValueType.STRING)
        this.table.addColumn("artist", ColumnValueType.STRING)
        this.table.addColumn("album", ColumnValueType.STRING)
        this.table.addColumn("uri", ColumnValueType.STRING)
        this.table.addColumn("duration", ColumnValueType.NUMBER)
        this.table.addColumn("coverUrl", ColumnValueType.STRING)
        await DbHelper.getInstance().createTable(this.table)
        const cache = await this.get()
        if (cache != undefined && cache.length > 0) {
            this.mediaList = cache
            this.isEmpty = cache.length > 0
            this.generateAlbum(cache)
        }
    }

    onDestroy(): void {

    }

    private generateAlbum(list: MediaFile[]) {
        for (let i = 0; i < list.length; i++) {
            const mediaItem = list[i]
            let albumName = mediaItem.album
            if (albumName.trim() === "") {
                albumName = "未知"
            }
            let isAlbumExist = false
            for (let j = 0; j < this.albumList.length; j++) {
                const item = this.albumList[j]
                if (item.title === albumName) {
                    isAlbumExist = true
                    const list = item.mediaList
                    list.push(mediaItem)
                    break
                }
            }
            if (!isAlbumExist) {
                const list: MediaFile[] = []
                list.push(mediaItem)
                const album: Album = {
                    title: albumName,
                    cover: mediaItem.coverUrl,
                    mediaList: list
                }
                this.albumList.push(album)
            }
        }
        this.albumList.forEach(album => {
            XLogger.w(TAG, JSON.stringify(album))
        })
    }

    async add(list: MediaFile[]) {
        this.mediaList.push(...list)
        this.isEmpty = this.mediaList.length > 0
        if (this.table === undefined) {
            XLogger.e(TAG, "the table is not created")
            return
        }
        await this.table.insertArray(list)
    }

    async get() {
        return await this.table?.queryAll()
    }
}