/**
 *
 * Author: Seagazer
 * Date: 2025/12/17
 */
@ComponentV2
export struct TabItem {
    @Require @Param index: number
    @Require @Param icon: Resource
    @Require @Param title: ResourceStr
    @Param isSelected: boolean = false

    build() {
        Row({ space: 8 }) {
            Row() {
                SymbolGlyph(this.icon)
                    .fontSize(20)
                    .fontWeight(FontWeight.Bold)
                Text(this.title)
                    .fontSize(20)
                    .margin({ left: 16 })
            }
            .layoutWeight(1)
            .height("100%")
            .padding({ left: 8, right: 8 })
            .border({ radius: 8 })
            .backgroundColor(this.isSelected ? "#80ffffff" : Color.Transparent)

            // Line()
            //     .width(4)
            //     .borderRadius(2)
            //     .height("100%")
            //     .backgroundColor(Color.White)
            //     .visibility(this.isSelected ? Visibility.Visible : Visibility.Hidden)

        }
        .width("100%")
        .height(56)
        .padding({
            left: 16,
            right: 16,
            top: 8,
            bottom: 8
        })
        .justifyContent(FlexAlign.Start)
        .alignItems(VerticalAlign.Center)
        .clickEffect({ level: ClickEffectLevel.MIDDLE, scale: 0.8 })
    }
}