import { PlayerVM } from '../player/vm/PlayerVM'
import { MediaLibraryVM } from '../home/tabs/library/vm/MediaLibraryVM'
import { SettingsVM } from '../home/tabs/settings/vm/SettingsVM'
import { ThemeVM } from '../home/tabs/settings/vm/ThemeVM'
import { AppStorageV2, window } from '@kit.ArkUI'
import { XLogger } from '../base/extensions/XLogger'
import { common } from '@kit.AbilityKit'
import { RouterConstants } from '../base/Router'
import { DbHelper } from '../base/db/DbHelper'
import { Md5 } from '../base/extensions/Extensions'

const TAG = "[Splash]"

/**
 *
 * Author: Seagazer
 * Date: 2025/12/16
 */
@ComponentV2
export struct SplashPage {
    private navPathStack = new NavPathStack()
    private appName: string[] = ["L", "i", "s", "t", "e", "n"]
    @Local alpha: number[] = [0, 0, 0, 0, 0, 0]
    private theme: ThemeVM = AppStorageV2.connect<ThemeVM>(ThemeVM, () => new ThemeVM())!
    private player: PlayerVM = AppStorageV2.connect<PlayerVM>(PlayerVM, () => new PlayerVM())!
    private settings: SettingsVM = AppStorageV2.connect<SettingsVM>(SettingsVM, () => new SettingsVM())!
    private playlist: MediaLibraryVM = AppStorageV2.connect<MediaLibraryVM>(MediaLibraryVM, () => new MediaLibraryVM())!

    build() {
        NavDestination() {
            Row() {
                ForEach(this.appName, (char: string, index: number) => {
                    Text(char)
                        .fontSize(40)
                        .fontWeight(FontWeight.Bold)
                        .opacity(this.alpha[index])
                        .onAppear(() => {
                            // this.getUIContext().animateTo({
                            //     duration: 1000, delay: index * 200, onFinish: () => {
                            //         if (index === this.appName.length - 1) {
                            //         }
                            //     }
                            // }, () => {
                            //     this.alpha[index] = 1
                            // })
                        })
                })
            }
            .justifyContent(FlexAlign.Center)
            .alignItems(VerticalAlign.Center)
            .width("100%")
            .height("100%")
            .onAppear(() => {
                this.initApp()
            })
        }
        .width("100%")
        .height("100%")
        .hideTitleBar(true)
        .title(RouterConstants.SPLASH)
        .onReady((context) => {
            this.navPathStack = context.pathStack
        })
    }

    private async initApp() {
        try {
            const context = this.getUIContext().getHostContext() as common.UIAbilityContext
            await DbHelper.getInstance().createDb(context, "listen")
            const win = context.windowStage.getMainWindowSync()
            const area = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
            const statusHeight = area.topRect.height
            const navigationHeight = area.bottomRect.height
            this.theme.rootPaddingTop = this.getUIContext().px2vp(statusHeight) + 16
            this.theme.rootPaddingBottom = this.getUIContext().px2vp(navigationHeight) + 16
            await this.theme.onCreate(this.getUIContext())
            await this.player.onCreate(this.getUIContext())
            await this.settings.onCreate(this.getUIContext())
            await this.playlist.onCreate(this.getUIContext())
            this.onAppReady()
        } catch (e) {
            XLogger.e(TAG, "init app error= " + JSON.stringify(e))
        }
    }

    private onAppReady() {
        this.getUIContext().animateTo({ duration: 500 }, () => {
            this.navPathStack.replacePath({ name: RouterConstants.HOME }, true)
        })
    }
}