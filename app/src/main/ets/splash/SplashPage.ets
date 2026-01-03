import { PlayerVM } from '../player/vm/PlayerVM'
import { MediaLibraryVM } from '../home/tabs/library/vm/MediaLibraryVM'
import { SettingsVM } from '../home/tabs/settings/vm/SettingsVM'
import { ThemeVM } from '../home/tabs/settings/vm/ThemeVM'
import { AppStorageV2, window } from '@kit.ArkUI'
import { XLogger } from '../base/extensions/XLogger'
import { common } from '@kit.AbilityKit'
import { RouterConstants } from '../base/Router'
import { DbHelper } from '../base/db/DbHelper'
import { UIConstants } from '../base/UIConstants'
import { AlbumVM } from '../home/tabs/album/AlbumVM'

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
    private themeVM: ThemeVM = AppStorageV2.connect<ThemeVM>(ThemeVM, () => new ThemeVM())!
    private playerVM: PlayerVM = AppStorageV2.connect<PlayerVM>(PlayerVM, () => new PlayerVM())!
    private settingsVM: SettingsVM = AppStorageV2.connect<SettingsVM>(SettingsVM, () => new SettingsVM())!
    private mediaLibraryVM: MediaLibraryVM = AppStorageV2.connect<MediaLibraryVM>(MediaLibraryVM, () => new MediaLibraryVM())!
    private albumVM: AlbumVM = AppStorageV2.connect<AlbumVM>(AlbumVM, () => new AlbumVM())!

    build() {
        NavDestination() {
            Row() {
                ForEach(this.appName, (char: string, index: number) => {
                    Text(char)
                        .fontSize(40)
                        .fontColor(UIConstants.DEFAULT_PRIMARY_COLOR)
                        .fontWeight(FontWeight.Bold)
                        .opacity(this.alpha[index])
                        .onAppear(() => {
                            this.getUIContext().animateTo({
                                duration: 1000, delay: index * 200, onFinish: () => {
                                    if (index === this.appName.length - 1) {
                                    }
                                }
                            }, () => {
                                this.alpha[index] = 1
                            })
                        })
                })
            }
            .justifyContent(FlexAlign.Center)
            .alignItems(VerticalAlign.Center)
            .width("100%")
            .height("100%")
            .onAppear(() => {
                setTimeout(() => {
                    this.initApp()
                }, 2000)
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
            this.themeVM.rootPaddingTop = this.getUIContext().px2vp(statusHeight) + 16
            this.themeVM.rootPaddingBottom = this.getUIContext().px2vp(navigationHeight) + 16
            await this.themeVM.onCreate(this.getUIContext())
            await this.playerVM.onCreate(this.getUIContext())
            await this.mediaLibraryVM.onCreate(this.getUIContext())
            await this.albumVM.onCreate(this.getUIContext())
            await this.settingsVM.onCreate(this.getUIContext())
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