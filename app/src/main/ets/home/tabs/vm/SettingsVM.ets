import { IVM } from '../../../base/IVM'
import { UIConstants } from '../../../base/UIConstants'
import { bundleManager } from '@kit.AbilityKit'

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
    @Trace appVersion: string = "0.0.0"
    @Trace appActive: boolean = true

    async onCreate(context: UIContext) {
        this.appVersion = bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION).versionName
    }

    onDestroy(): void {

    }
}