import { ColumnValueType, DbHelper, Table } from '../../../../base/db/DbHelper'
import { XLogger } from '../../../../base/extensions/XLogger'
import { MediaFile } from '../../../../base/file/MediaFile'
import { IVM } from '../../../../base/IVM'

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
    @Trace playingIndex: number = 0
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
        if (cache != undefined) {
            this.mediaList = cache
            this.isEmpty = cache.length > 0
        }
    }

    onDestroy(): void {

    }

    async add(list: MediaFile[]) {
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