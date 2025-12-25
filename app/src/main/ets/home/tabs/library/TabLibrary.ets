import { MediaLibraryVM } from './vm/MediaLibraryVM'
import { AppStorageV2 } from '@kit.ArkUI'
import { duration2Text } from '../../../base/extensions/Extensions'
import { PlayerVM } from '../../../player/vm/PlayerVM'
import { ThemeVM } from '../settings/vm/ThemeVM'
import { Palette } from '../../../base/view/Palette'
import { tabTitleStyle } from '../Style'

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
    private playlist: MediaLibraryVM = AppStorageV2.connect<MediaLibraryVM>(MediaLibraryVM, () => new MediaLibraryVM())!
    private player: PlayerVM = AppStorageV2.connect<PlayerVM>(PlayerVM, () => new PlayerVM())!
    private theme: ThemeVM = AppStorageV2.connect<ThemeVM>(ThemeVM, () => new ThemeVM())!
    private palette = new Palette()

    build() {
        Column() {
            Text("音乐库")
                .attributeModifier(tabTitleStyle)

            Row() {
                Text("共" + this.playlist.playlist.length + "首音乐")
                    .fontSize(24)
            }
            .margin({ top: 24 })

            Column() {
                List({ space: 12 }) {
                    Repeat(this.playlist.playlist)
                        .each((repeatItem) => {
                            ListItem() {
                                Row() {
                                    Image(repeatItem.item.cover)
                                        .width(40)
                                        .height(40)
                                        .objectFit(ImageFit.Cover)
                                        .border({ radius: 2 })
                                    Column() {
                                        Text(repeatItem.item.title)
                                            .fontSize(18)
                                        Text(repeatItem.item.artist)
                                            .fontSize(14)
                                            .margin({ top: 4 })
                                    }
                                    .height("100%")
                                    .margin({ left: 16 })
                                    .alignItems(HorizontalAlign.Start)

                                    Blank()
                                    Text(duration2Text(repeatItem.item.duration))
                                        .fontSize(18)
                                }
                                .width("100%")
                                .height("100%")
                                .padding({ top: 2, bottom: 2 })
                            }
                            .width("100%")
                            .height(56)
                            .clickEffect({ level: ClickEffectLevel.LIGHT, scale: 0.95 })
                            .onClick(() => {
                                this.player.setSource(repeatItem.item)
                                this.getUIContext().animateTo({
                                    duration: 1000
                                }, () => {
                                    this.playlist.playingItem = repeatItem.item
                                    this.playlist.playingIndex = repeatItem.index
                                })
                                // update theme
                                let pixelmap = repeatItem.item.cover
                                if (pixelmap !== undefined) {
                                    this.player.coverImage = pixelmap
                                    this.palette.setImage(pixelmap).then(() => {
                                        const color = this.palette.getThemeColor()
                                        this.theme?.update(color[0], color[1])
                                    })
                                } else {
                                    this.player.coverImage = $r("app.media.cover")
                                    this.theme?.reset()
                                }
                            })
                        }).virtualScroll({ totalCount: this.playlist.playlist.length })
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
