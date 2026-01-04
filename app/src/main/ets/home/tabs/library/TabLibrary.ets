import { MediaLibraryVM } from '../vm/MediaLibraryVM'
import { AppStorageV2 } from '@kit.ArkUI'
import { duration2Text } from '../../../base/extensions/Extensions'
import { PlayerVM } from '../../../player/vm/PlayerVM'
import { ThemeVM } from '../vm/ThemeVM'
import { tabTitleStyle } from '../Style'
import { ImageView } from '../../../base/view/ImageView'
import { UIConstants } from '../../../base/UIConstants'

/**
 *
 * Author: Seagazer
 * Date: 2025/12/24
 */
@Builder
export function TabLibraryView() {
    TabLibrary()
}

@ComponentV2
struct TabLibrary {
    private mediaLibraryVM: MediaLibraryVM = AppStorageV2.connect<MediaLibraryVM>(MediaLibraryVM, () => new MediaLibraryVM())!
    private playerVM: PlayerVM = AppStorageV2.connect<PlayerVM>(PlayerVM, () => new PlayerVM())!
    private themeVM: ThemeVM = AppStorageV2.connect<ThemeVM>(ThemeVM, () => new ThemeVM())!

    build() {
        Column() {
            Text("音乐库")
                .attributeModifier(tabTitleStyle)

            Row() {
                Text("共" + this.mediaLibraryVM.mediaList.length + "首音乐")
                    .fontSize(20)
                    .fontColor(UIConstants.DEFAULT_TEXT_COLOR)
            }
            .margin({ top: 24, bottom: 16 })

            Column() {
                List({ space: 12 }) {
                    Repeat(this.mediaLibraryVM.mediaList)
                        .each((repeatItem) => {
                            ListItem() {
                                Row() {
                                    Text((repeatItem.index + 1).toString())
                                        .fontSize(24)
                                        .fontColor(repeatItem.item.uri === this.playerVM.currentItem?.uri ? this.themeVM.primaryColor :
                                            UIConstants.DEFAULT_TEXT_COLOR)
                                        .fontWeight(FontWeight.Bold)
                                        .padding({ left: 8, right: 16 })

                                    ImageView({ url: repeatItem.item.coverUrl, corner: 4 })
                                        .width(40)
                                        .height(40)
                                    Column() {
                                        Text(repeatItem.item.title)
                                            .fontSize(18)
                                            .fontColor(repeatItem.item.uri === this.playerVM.currentItem?.uri ? this.themeVM.primaryColor :
                                                UIConstants.DEFAULT_TEXT_COLOR)
                                        Text(repeatItem.item.artist)
                                            .fontSize(14)
                                            .margin({ top: 4 })
                                            .fontColor(repeatItem.item.uri === this.playerVM.currentItem?.uri ? this.themeVM.primaryColor :
                                                "#99ffffff")
                                    }
                                    .height("100%")
                                    .margin({ left: 16 })
                                    .alignItems(HorizontalAlign.Start)
                                    .justifyContent(FlexAlign.Center)

                                    Blank()

                                    Text(duration2Text(repeatItem.item.duration))
                                        .fontSize(18)
                                        .fontColor(repeatItem.item.uri === this.playerVM.currentItem?.uri ? this.themeVM.primaryColor :
                                            UIConstants.DEFAULT_TEXT_COLOR)
                                }
                                .width("100%")
                                .height("100%")
                            }
                            .padding({ left: 8, right: 16 })
                            .width("100%")
                            .height(56)
                            .clickEffect({ level: ClickEffectLevel.LIGHT, scale: 0.95 })
                            .border({ radius: 4 })
                            .backgroundColor(repeatItem.item.uri === this.playerVM.currentItem?.uri ? "#33ffffff" : Color.Transparent)
                            .onClick(async () => {
                                this.playerVM.setSource(repeatItem.item)
                            })
                        }).virtualScroll({ totalCount: this.mediaLibraryVM.mediaList.length })
                        .key((item) => {
                            return item.uri
                        })
                    ListItem().height(120)
                }
                .width("100%")
                .height("100%")
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
