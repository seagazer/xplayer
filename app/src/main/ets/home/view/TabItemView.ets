import { ThemeVM } from "../tabs/settings/vm/ThemeVM"

/**
 *
 * Author: Seagazer
 * Date: 2025/12/17
 */
@ComponentV2
export struct TabItemView {
    @Require @Param index: number
    @Require @Param icon: Resource
    @Require @Param title: ResourceStr
    @Param isSelected: boolean = false
    @Require @Param theme: ThemeVM

    build() {
        Row() {
            SymbolGlyph(this.icon)
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor([Color.White])
            Text(this.title)
                .fontSize(20)
                .margin({ left: 16 })
                .fontColor(Color.White)
        }
        .width("100%")
        .height(48)
        .padding({ left: 16, right: 16 })
        .border({ radius: 8 })
        .backgroundColor(this.isSelected ? this.theme.primaryColorDark : Color.Transparent)
        .hoverEffect(HoverEffect.Highlight)
        .clickEffect({ level: ClickEffectLevel.MIDDLE })
    }
}


class TabItemStyle implements AttributeModifier<RowAttribute> {
    applyFocusedAttribute(instance: RowAttribute): void {

    }
}