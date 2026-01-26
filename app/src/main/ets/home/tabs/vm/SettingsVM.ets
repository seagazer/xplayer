import { IVM } from '../../../base/IVM'
import { UIConstants } from '../../../base/UIConstants'
import { bundleManager } from '@kit.AbilityKit'
import { VMProvider } from '../../../VMProvider'
import { LyricVM } from '../../../player/vm/LyricVM'
import { AlignMode } from '@seagazer/cclyric'

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
    @Trace appActive: boolean = false

    async onCreate(context: UIContext) {
        this.appVersion = bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION).versionName
    }

    onDestroy(): void {

    }

    @Monitor("lyricAlignLeft")
    onLyricChanged() {
        const lyricVm = VMProvider.get().getVM("LyricVM") as LyricVM
        lyricVm.controller.setAlignMode(this.lyricAlignLeft ? AlignMode.START : AlignMode.CENTER)
    }
}