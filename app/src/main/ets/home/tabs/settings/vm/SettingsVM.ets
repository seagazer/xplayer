import { IVM } from '../../../../base/IVM'
import { UIConstants } from '../../../../base/UIConstants'

/**
 *
 * Author: Seagazer
 * Date: 2025/12/23
 */
@ObservedV2
export class SettingsVM implements IVM {
    // theme
    @Trace autoMainTheme: boolean = false
    @Trace mainThemeColor: ResourceColor = UIConstants.DEFAULT_PRIMARY_COLOR
    // lyric
    @Trace autoLyricTheme: boolean = false
    @Trace autoDownloadLyric: boolean = false
    @Trace lyricAlignLeft: boolean = false
    @Trace lyricTextSize: number = 24
    // version
    @Trace appVersion: string = "1.0.0"
    @Trace appActive: boolean = false

    async onCreate(context: UIContext) {
    }

    onDestroy(): void {

    }
}