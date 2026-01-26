import { clickStyle } from '../../../base/Styles'
import { VMProvider } from '../../../VMProvider'
import { tabTitleStyle } from '../Style'
import { MediaLibraryVM } from '../vm/MediaLibraryVM'
import { ThemeVM } from '../vm/ThemeVM'
import { AlbumItemView } from './AlbumItemView'

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
    private themeVM: ThemeVM = VMProvider.get().getVM("ThemeVM") as ThemeVM
    private mediaLibraryVM: MediaLibraryVM = VMProvider.get().getVM("MediaLibraryVM") as MediaLibraryVM

    build() {
        Column() {
            Text("专辑")
                .attributeModifier(tabTitleStyle)

            Row() {
                Text("共" + this.mediaLibraryVM.albumList.length + "个专辑")
                    .fontSize(20)
                    .fontColor("#ccffffff")
            }
            .margin({ top: 24, bottom: 16 })

            Column() {
                Grid() {
                    Repeat(this.mediaLibraryVM.albumList)
                        .each((repeatItem) => {
                            GridItem() {
                                AlbumItemView({ item: repeatItem.item })
                            }
                            .width("100%")
                            .height(300)
                            .clickEffect(clickStyle)
                        })
                        .virtualScroll({ totalCount: this.mediaLibraryVM.albumList.length })
                        .key((item) => {
                            return item.title
                        })
                    GridItem()
                        .columnStart(0)
                        .columnEnd(3)
                        .height(120)
                }
                .width("100%")
                .height("100%")
                .columnsTemplate("1fr 1fr 1fr 1fr")
                .rowsGap(24)
                .columnsGap(24)
                .padding({ left: 16, right: 16 })
            }
            .width("100%")
            .layoutWeight(1)
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
