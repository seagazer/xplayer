import { SettingsVM } from './home/tabs/settings/vm/SettingsVM';
import { AppStorageV2 } from '@kit.ArkUI';
import { RouterConstants, RouterMapper } from './base/Router';

@Entry
@ComponentV2
struct Index {
    private navPathStack = new NavPathStack()
    private settings: SettingsVM = AppStorageV2.connect<SettingsVM>(SettingsVM, () => new SettingsVM())!

    aboutToAppear(): void {
        this.navPathStack.replacePath({ name: RouterConstants.SPLASH }, false)
    }

    build() {
        Stack() {
            // app root view
            Navigation(this.navPathStack)
            .width('100%')
            .height('100%')
                .navDestination(RouterMapper)
            .mode(NavigationMode.Stack)
            .hideTitleBar(true)

            if (!this.settings.appActive) {
                // active MASK
                Text("Listen By \n Seagazer")
                    .fontColor("#1affffff")
                    .fontSize(240)
                    .position({ x: 0, y: 0 })
                    .hitTestBehavior(HitTestMode.None)
            }
        }
        .width('100%')
        .height('100%')
    }
}