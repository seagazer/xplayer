import { MediaFile } from '../../../../base/file/MediaFile'
import { IVM } from '../../../../base/IVM'

/**
 *
 * Author: Seagazer
 * Date: 2025/12/16
 */
@ObservedV2
export class MediaLibraryVM implements IVM {
    @Trace isEmpty: boolean = true
    @Trace playlist: MediaFile[] = []
    @Trace playingIndex: number = 0
    @Trace playingItem?: MediaFile = undefined

    async onCreate(context: UIContext) {
    }

    onDestroy(): void {

    }
}