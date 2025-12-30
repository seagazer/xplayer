import { MediaLibraryVM } from './vm/MediaLibraryVM'
import { AppStorageV2 } from '@kit.ArkUI'
import { duration2Text } from '../../../base/extensions/Extensions'
import { PlayerVM } from '../../../player/vm/PlayerVM'
import { ThemeVM } from '../settings/vm/ThemeVM'
import { Palette } from '../../../base/view/Palette'
import { tabTitleStyle } from '../Style'
import { ImageView } from '../../../base/view/ImageView'
import { ImageLoader } from '../../../base/http/ImageLoader'
import { SpinKit } from '@pura/spinkit'

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
    private palette = new Palette()

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
                                    Stack() {
                                        if (repeatItem.item.uri === this.player.currentItem?.uri) {
                                            SpinKit({
                                                spinType: 2,
                                                spinColor: this.theme.primaryColor,
                                                spinSize: 24
                                            })
                                        } else {
                                            Text((repeatItem.index + 1).toString())
                                                .fontSize(24)
                                                .fontColor("#ccffffff")
                                        }
                                    }
                                    .width(56)
                                    .height(56)
                                    .align(Alignment.Center)

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
                                .padding({ left: 8, right: 16 })
                            }
                            .width("100%")
                            .height(56)
                            .clickEffect({ level: ClickEffectLevel.LIGHT, scale: 0.95 })
                            .onClick(async () => {
                                this.player.setSource(repeatItem.item)
                                // update theme
                                let pixelmap = await ImageLoader.get(this.getUIContext().getHostContext()!).loadImage(repeatItem.item.coverUrl)
                                if (pixelmap !== undefined) {
                                    this.palette.setImage(pixelmap).then(() => {
                                        const color = this.palette.getThemeColor()
                                        this.theme?.update(color[0], color[1])
                                    })
                                } else {
                                    this.theme?.reset()
                                }
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
