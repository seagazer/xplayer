import { PlayerVM } from '../vm/PlayerVM'
import { PlaylistVM } from '../vm/PlaylistVM'
import { SettingsVM } from '../vm/SettingsVM'
import { ThemeVM } from '../vm/ThemeVM'
import { AppStorageV2, window } from '@kit.ArkUI'
import { XLogger } from '../extensions/XLogger'
import { common } from '@kit.AbilityKit'

const TAG = "[Splash]"

/**
 *
 * Author: Seagazer
 * Date: 2025/12/16
 */
@ComponentV2
export struct Splash {
    private theme: ThemeVM = AppStorageV2.connect<ThemeVM>(ThemeVM, () => new ThemeVM())!
    private player: PlayerVM = AppStorageV2.connect<PlayerVM>(PlayerVM, () => new PlayerVM())!
    private settings: SettingsVM = AppStorageV2.connect<SettingsVM>(SettingsVM, () => new SettingsVM())!
    private playlist: PlaylistVM = AppStorageV2.connect<PlaylistVM>(PlaylistVM, () => new PlaylistVM())!
    @Event onReady: () => void

    build() {
        Column() {
            Text("XPlayer")
                .fontSize(24)
                .onAppear(() => {
                    this.initApp()
                })
        }
        .width("100%")
        .height("100%")
        .justifyContent(FlexAlign.Center)
    }

    private async initApp() {
        try {
            const ctx = this.getUIContext().getHostContext() as common.UIAbilityContext
            const win = ctx.windowStage.getMainWindowSync()
            const area = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
            const statusHeight = area.topRect.height
            const navigationHeight = area.bottomRect.height
            this.theme.statusBarHeight = this.getUIContext().px2vp(statusHeight)
            this.theme.navigationBarHeight = this.getUIContext().px2vp(navigationHeight)
            XLogger.w(TAG, "----" + statusHeight + ", " + navigationHeight)
            await this.theme.onCreate(this.getUIContext())
            await this.player.onCreate(this.getUIContext())
            await this.settings.onCreate(this.getUIContext())
            await this.playlist.onCreate(this.getUIContext())
            this.onReady()
        } catch (e) {
            XLogger.e(TAG, "init app error= " + JSON.stringify(e))
        }
    }
}