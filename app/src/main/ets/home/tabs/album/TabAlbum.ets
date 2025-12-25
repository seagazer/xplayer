import { AppStorageV2 } from '@kit.ArkUI'
import { ThemeVM } from '../settings/vm/ThemeVM'
import { tabTitleStyle } from '../Style'

/**
 *
 * Author: Seagazer
 * Date: 2025/12/24
 */
@Builder
export function TabAlbumView() {
    TabAlbum()
}

@ComponentV2
struct TabAlbum {
    private theme: ThemeVM = AppStorageV2.connect<ThemeVM>(ThemeVM, () => new ThemeVM())!

    build() {
        Column() {
            Text("专辑")
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
