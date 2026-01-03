import { XLogger } from '../../../base/extensions/XLogger'
import { MediaFile } from '../../../base/file/MediaFile'
import { IVM } from '../../../base/IVM'
import { MediaLibraryVM } from '../library/vm/MediaLibraryVM'
import { AppStorageV2 } from '@kit.ArkUI'

const TAG = "[AlbumVM]"


export interface Album {
    title: string
    cover: string | undefined
    mediaList: MediaFile[]
}

/**
 *
 * Author: Seagazer
 * Date: 2025/12/16
 */
@ObservedV2
export class AlbumVM implements IVM {
    private mediaLibraryVM: MediaLibraryVM = AppStorageV2.connect<MediaLibraryVM>(MediaLibraryVM, () => new MediaLibraryVM())!
    @Trace isEmpty: boolean = true
    @Trace albumList: Album[] = []

    async onCreate(context: UIContext) {
        XLogger.d(TAG, "onCreate")
        for (let i = 0; i < this.mediaLibraryVM.mediaList.length; i++) {
            const mediaItem = this.mediaLibraryVM.mediaList[i]
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

    onDestroy(): void {

    }
}