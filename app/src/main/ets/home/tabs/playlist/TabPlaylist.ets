import { ThemeVM } from '../vm/ThemeVM'
import { tabTitleStyle } from '../Style'
import { VMProvider } from '../../../VMProvider'

/**
 *
 * Author: Seagazer
 * Date: 2025/12/24
 */
@Builder
export function TabPlaylistView() {
    TabPlaylist()
}

@ComponentV2
struct TabPlaylist {
    private themeVM: ThemeVM = VMProvider.get().getVM("ThemeVM") as ThemeVM

    build() {
        Column() {
            Text("播放列表")
                .attributeModifier(tabTitleStyle)

        }
        .width("100%")
        .justifyContent(FlexAlign.Start)
        .alignItems(HorizontalAlign.Start)
        .padding({
            top: this.themeVM.rootPaddingTop,
            bottom: this.themeVM.rootPaddingBottom,
            left: this.themeVM.rootPaddingLeft,
            right: this.themeVM.rootPaddingRight
        })
    }
}

