import { PlayerVM } from '../../../player/vm/PlayerVM'
import { tabTitleStyle } from '../Style'
import { ListItemView } from './ListItemView'
import { ThemeVM } from '../vm/ThemeVM'
import { UIConstants } from '../../../base/UIConstants'
import { MediaLibraryVM } from '../vm/MediaLibraryVM'
import { clickStyle } from '../../../base/Styles'
import { VMProvider } from '../../../VMProvider'

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
    private mediaLibraryVM: MediaLibraryVM = VMProvider.get().getVM("MediaLibraryVM") as MediaLibraryVM
    private playerVM: PlayerVM = VMProvider.get().getVM("PlayerVM") as PlayerVM
    private themeVM: ThemeVM = VMProvider.get().getVM("ThemeVM") as ThemeVM

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
                                ListItemView({
                                    index: repeatItem.index,
                                    item: repeatItem.item,
                                    isHighlight: this.playerVM.currentItem === repeatItem.item,
                                    onItemMenuClick: () => {
                                        const result = repeatItem.item.collection === 0 ? 1 : 0
                                        this.mediaLibraryVM.updateFavourite(repeatItem.item, result)
                                    }
                                })
                            }
                            .width("100%")
                            .height(56)
                            .clickEffect(clickStyle)
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
