import { XLogger } from '../base/extensions/XLogger'
import { common } from '@kit.AbilityKit'
import { RouterConstants } from '../base/Router'
import { DbHelper } from '../base/db/DbHelper'
import { UIConstants } from '../base/UIConstants'
import { VMProvider } from '../VMProvider'

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
            VMProvider.get().onCreate(this.getUIContext())
            this.onAppReady()
        } catch (e) {
            XLogger.e(TAG, "init app error= " + JSON.stringify(e))
        }
    }

    private onAppReady() {
        this.getUIContext().animateTo({ duration: UIConstants.PAGE_TRANSITION_DURATION }, () => {
            this.navPathStack.replacePath({ name: RouterConstants.HOME }, true)
        })
    }
}