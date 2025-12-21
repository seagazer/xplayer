import { Home } from './Home';
import { PlayDetail } from './PlayDetail';
import { Splash } from './Splash';

@Entry
@ComponentV2
struct Index {
    private path = new NavPathStack()

    @Builder
    navMap(title: string) {
        if (title === "detail") {
            PlayDetail()
        } else {
            Home()
        }
    }

    build() {
        Navigation(this.path) {
            Splash({
                onReady: () => {
                    this.path.replacePath({ name: "home" }, false)
                }
            })
        }
        .height('100%')
        .width('100%')
        .navDestination(this.navMap)
        .mode(NavigationMode.Stack)
        .hideTitleBar(true)
    }
}