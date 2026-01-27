import { CcLyricController, Lrc } from '@seagazer/cclyric';
import { IVM } from '../../base/IVM';
import { getLyric } from '../../base/LyricParser';
import { MediaFile } from '../../base/model/MediaFile';

const TAG = "[LyricVM]"

/**
 *
 * Author: Seagazer
 * Date: 2026/1/22
 */
@ObservedV2
export class LyricVM implements IVM {
    @Trace lyric?: Lrc = undefined
    controller: CcLyricController = new CcLyricController()

    async onCreate(context: UIContext) {

    }

    onDestroy(): void {
    }

    setLyric(item: MediaFile) {
        const lyric = getLyric(item)
        this.controller.setLyric(lyric)
    }
}


