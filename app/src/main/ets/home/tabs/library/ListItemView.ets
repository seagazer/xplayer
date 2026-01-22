import { duration2Text } from '../../../base/extensions/Extensions'
import { MediaFile } from '../../../base/model/MediaFile'
import { UIConstants } from '../../../base/UIConstants'
import { ImageView } from '../../../base/view/ImageView'

@ComponentV2
export struct ListItemView {
    @Require @Param index: number
    @Require @Param item: MediaFile
    @Require @Param isHighlight: boolean
    @Local isHover: boolean = false
    @Event onItemMenuClick: () => void

    build() {
        Row() {
            Text((this.index + 1).toString())
                .fontSize(24)
                .width(60)
                .textAlign(TextAlign.Center)
                .fontColor(this.isHighlight ? UIConstants.DEFAULT_PRIMARY_COLOR : "#ccffffff")
                .fontWeight(FontWeight.Bold)

            ImageView({ url: this.item.coverUrl, corner: 4 })
                .width(40)
                .height(40)
            Column() {
                Text(this.item.title)
                    .fontSize(18)
                    .fontColor(this.isHighlight ? UIConstants.DEFAULT_PRIMARY_COLOR : "#ccffffff")
                Text(this.item.artist)
                    .fontSize(14)
                    .margin({ top: 4 })
                    .fontColor(this.isHighlight ? UIConstants.DEFAULT_PRIMARY_COLOR : "#99ffffff")
            }
            .height("100%")
            .margin({ left: 16 })
            .alignItems(HorizontalAlign.Start)
            .justifyContent(FlexAlign.Center)

            Blank()

            Text(duration2Text(this.item.duration))
                .fontSize(18)
                .fontColor(this.isHighlight ? UIConstants.DEFAULT_PRIMARY_COLOR : "#ccffffff")

            SymbolGlyph($r("sys.symbol.dot_grid_1x2"))
                .fontSize(32)
                .fontColor([this.isHighlight ? UIConstants.DEFAULT_PRIMARY_COLOR : "#ccffffff"])
                .hitTestBehavior(HitTestMode.Block)
                .bindContextMenu(this.menu(this.item), ResponseType.LongPress, {
                    borderRadius: 2,
                    offset: { y: 12 },

                })
        }
        .width("100%")
        .height("100%")
        .padding({ left: 16, right: 16 })
        .border({ radius: 8, width: this.isHover ? 1 : 0, color: UIConstants.DEFAULT_PRIMARY_COLOR })
        .onHover((hover) => {
            this.isHover = hover
        })
    }

    @Builder
    menu(item: MediaFile) {
        Text(item.collection ? "取消收藏" : "添加收藏")
            .fontSize(16)
            .padding(8)
            .backgroundColor(Color.White)
            .onClick(() => {
                this.onItemMenuClick?.()
            })
    }
}