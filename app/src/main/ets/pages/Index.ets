import { SettingsVM } from '../vm/SettingsVM';
import { Home } from './Home';
import { PlayDetail } from './PlayDetail';
import { Splash } from './Splash';
import { AppStorageV2 } from '@kit.ArkUI';

@Entry
@ComponentV2
struct Index {
    private path = new NavPathStack()
    private settings: SettingsVM = AppStorageV2.connect<SettingsVM>(SettingsVM, () => new SettingsVM())!

    @Builder
    navMap(title: string) {
        if (title === "detail") {
            PlayDetail()
        } else {
            Home()
        }
    }

    build() {
        Stack() {
            Navigation(this.path) {
                Splash({
                    onReady: () => {
                        this.path.replacePath({ name: "home" }, true)
                    }
                })
            }
            .width('100%')
            .height('100%')
            .navDestination(this.navMap)
            .mode(NavigationMode.Stack)
            .hideTitleBar(true)

            if (!this.settings.appActive) {
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