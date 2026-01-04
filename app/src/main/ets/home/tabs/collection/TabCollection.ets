import { AppStorageV2 } from '@kit.ArkUI'
import { ThemeVM } from '../vm/ThemeVM'
import { tabTitleStyle } from '../Style'

/**
 *
 * Author: Seagazer
 * Date: 2025/12/24
 */
@Builder
export function TabCollectionView() {
    TabCollection()
}

@ComponentV2
struct TabCollection {
    private themeVM: ThemeVM = AppStorageV2.connect<ThemeVM>(ThemeVM, () => new ThemeVM())!

    build() {
        Column() {
            Text("收藏")
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

