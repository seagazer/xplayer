import { MediaLibraryVM } from './vm/MediaLibraryVM'
import { AppStorageV2 } from '@kit.ArkUI'
import { duration2Text } from '../../../base/extensions/Extensions'
import { PlayerVM } from '../../../player/vm/PlayerVM'
import { ThemeVM } from '../settings/vm/ThemeVM'
import { tabTitleStyle } from '../Style'
import { ImageView } from '../../../base/view/ImageView'

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
    private mediaLibrary: MediaLibraryVM = AppStorageV2.connect<MediaLibraryVM>(MediaLibraryVM, () => new MediaLibraryVM())!
    private player: PlayerVM = AppStorageV2.connect<PlayerVM>(PlayerVM, () => new PlayerVM())!
    private theme: ThemeVM = AppStorageV2.connect<ThemeVM>(ThemeVM, () => new ThemeVM())!

    build() {
        Column() {
            Text("音乐库")
                .attributeModifier(tabTitleStyle)

            Row() {
                Text("共" + this.mediaLibrary.mediaList.length + "首音乐")
                    .fontSize(20)
                    .fontColor("#ccffffff")
            }
            .margin({ top: 24, bottom: 16 })

            Column() {
                List({ space: 12 }) {
                    Repeat(this.mediaLibrary.mediaList)
                        .each((repeatItem) => {
                            ListItem() {
                                Row() {
                                    Text((repeatItem.index + 1).toString())
                                        .fontSize(24)
                                        .fontColor("#ccffffff")
                                        .fontWeight(FontWeight.Bold)
                                        .margin({ right: 16 })

                                    ImageView({ url: repeatItem.item.coverUrl, corner: 4 })
                                        .width(40)
                                        .height(40)
                                    Column() {
                                        Text(repeatItem.item.title)
                                            .fontSize(18)
                                            .fontColor("#ccffffff")
                                        Text(repeatItem.item.artist)
                                            .fontSize(14)
                                            .margin({ top: 4 })
                                            .fontColor("#99ffffff")
                                    }
                                    .height("100%")
                                    .margin({ left: 16 })
                                    .alignItems(HorizontalAlign.Start)
                                    .justifyContent(FlexAlign.Center)

                                    Blank()

                                    Text(duration2Text(repeatItem.item.duration))
                                        .fontSize(18)
                                        .fontColor("#ccffffff")
                                }
                                .width("100%")
                                .height("100%")
                            }
                            .width("100%")
                            .height(56)
                            .padding({ left: 8, right: 16 })
                            .clickEffect({ level: ClickEffectLevel.LIGHT, scale: 0.95 })
                            .border({ radius: 4 })
                            .backgroundColor(repeatItem.item.uri === this.player.currentItem?.uri ? "#33ffffff" : Color.Transparent)
                            .onClick(async () => {
                                this.player.setSource(repeatItem.item)
                            })
                        }).virtualScroll({ totalCount: this.mediaLibrary.mediaList.length })
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
            top: this.theme.rootPaddingTop,
            bottom: this.theme.rootPaddingBottom,
            left: this.theme.rootPaddingLeft,
            right: this.theme.rootPaddingRight
        })
    }
}
