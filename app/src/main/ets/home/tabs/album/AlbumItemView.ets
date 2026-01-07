import { Album } from "../../../base/model/Album"
import { UIConstants } from "../../../base/UIConstants"
import { ImageView } from "../../../base/view/ImageView"

@ComponentV2
export struct AlbumItemView {
    @Require @Param item: Album
    @Local isHover: boolean = false

    build() {
        Stack() {
            ImageView({
                url: this.item.cover,
            }).width("100%")
                .height("100%")

            Column() {
                Text("共" + this.item.mediaList.length + "首歌曲")
                    .fontSize(16)
                    .fontColor("#ccffffff")
                    .padding(8)
                    .backgroundColor("#80000000")
                    .border({ radius: { topRight: 8, bottomLeft: 8 } })

                Text(this.item.title)
                    .width("100%")
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .fontSize(18)
                    .fontColor("#ccffffff")
                    .padding({ left: 12, right: 12 })
                    .width("100%")
                    .height("20%")
                    .backgroundColor(UIConstants.DEFAULT_PRIMARY_COLOR_DARK)
            }
            .width("100%")
            .height("100%")
            .justifyContent(FlexAlign.SpaceBetween)
            .alignItems(HorizontalAlign.End)
        }
        .width("100%")
        .height("100%")
        .border({ radius: 8, width: this.isHover ? 1 : 0, color: UIConstants.DEFAULT_PRIMARY_COLOR })
        .clip(true)
        .onHover((hover) => {
            this.isHover = hover
        })
    }
}