import { AppStorageV2 } from '@kit.ArkUI'
import { UIConstants } from '../../../base/UIConstants'
import { ImageView } from '../../../base/view/ImageView'
import { ThemeVM } from '../settings/vm/ThemeVM'
import { tabTitleStyle } from '../Style'
import { AlbumVM } from './AlbumVM'

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
    private themeVM: ThemeVM = AppStorageV2.connect<ThemeVM>(ThemeVM, () => new ThemeVM())!
    private albumVM: AlbumVM = AppStorageV2.connect<AlbumVM>(AlbumVM, () => new AlbumVM())!

    build() {
        Column() {
            Text("专辑")
                .attributeModifier(tabTitleStyle)

            Row() {
                Text("共" + this.albumVM.albumList.length + "个专辑")
                    .fontSize(20)
                    .fontColor("#ccffffff")
            }
            .margin({ top: 24, bottom: 16 })

            Column() {
                Grid() {
                    Repeat(this.albumVM.albumList)
                        .each((repeatItem) => {
                            GridItem() {
                                Stack() {
                                    ImageView({
                                        url: repeatItem.item.cover,
                                    }).width("100%")
                                        .height("100%")

                                    Column() {
                                        Text("共" + repeatItem.item.mediaList.length + "首歌曲")
                                            .fontSize(16)
                                            .fontColor("#ccffffff")
                                            .padding(8)
                                            .backgroundColor("#80000000")
                                            .border({ radius: { topRight: 8, bottomLeft: 8 } })

                                        Text(repeatItem.item.title)
                                            .width("100%")
                                            .maxLines(1)
                                            .textOverflow({ overflow: TextOverflow.Ellipsis })
                                            .fontSize(18)
                                            .fontColor("#ccffffff")
                                            .padding({ left: 12, right: 12 })
                                            .width("100%")
                                            .height(50)
                                            .backgroundColor(UIConstants.DEFAULT_PRIMARY_COLOR_DARK)
                                    }
                                    .width("100%")
                                    .height("100%")
                                    .justifyContent(FlexAlign.SpaceBetween)
                                    .alignItems(HorizontalAlign.End)
                                }
                                .width("100%")
                                .height("100%")
                                .border({ radius: 8 })
                                .clip(true)
                            }
                            .width("100%")
                            .height(300)
                            .clickEffect({ level: ClickEffectLevel.LIGHT, scale: 0.95 })
                        }).virtualScroll({ totalCount: this.albumVM.albumList.length })
                        .key((item) => {
                            return item.title
                        })

                }
                .width("100%")
                .height("100%")
                .columnsTemplate("1fr 1fr 1fr 1fr")
                .rowsGap(24)
                .columnsGap(24)
                .padding({ left: 16, right: 16, bottom: 160 })
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
