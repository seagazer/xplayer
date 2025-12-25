import { AppStorageV2 } from '@kit.ArkUI'
import { ThemeVM } from '../settings/vm/ThemeVM'
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
    private theme: ThemeVM = AppStorageV2.connect<ThemeVM>(ThemeVM, () => new ThemeVM())!

    build() {
        Column() {
            Text("收藏")
                .attributeModifier(tabTitleStyle)

        }
        .width("100%")
        .justifyContent(FlexAlign.Start)
        .alignItems(HorizontalAlign.Start)
        .padding({
            top: this.theme.rootPaddingTop,
            bottom: this.theme.rootPaddingBottom,
            left: this.theme.rootPaddingLeft,
            right: this.theme.rootPaddingRight
        })
    }
}

