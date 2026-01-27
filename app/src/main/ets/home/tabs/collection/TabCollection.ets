import { clickStyle } from '../../../base/Styles'
import { PlayerVM } from '../../../player/vm/PlayerVM'
import { VMProvider } from '../../../VMProvider'
import { tabTitleStyle } from '../Style'
import { MediaLibraryVM } from '../vm/MediaLibraryVM'
import { ThemeVM } from '../vm/ThemeVM'
import { CollectionItemView } from './CollectionItemView'

/**
 *
 * Author: Seagazer
 * Date: 2025/12/24
 */
@Builder
export function TabCollectionView() {
    TabCollection()
}

@ComponentV2
struct TabCollection {
    private mediaLibraryVM: MediaLibraryVM = VMProvider.get().getVM("MediaLibraryVM") as MediaLibraryVM
    private playerVM: PlayerVM = VMProvider.get().getVM("PlayerVM") as PlayerVM
    private themeVM: ThemeVM = VMProvider.get().getVM("ThemeVM") as ThemeVM

    build() {
        Column() {
            Text("收藏")
                .attributeModifier(tabTitleStyle)

            Row() {
                Text("共" + this.mediaLibraryVM.favouriteList.length + "首收藏")
                    .fontSize(20)
                    .fontColor("#ccffffff")
            }
            .margin({ top: 24, bottom: 16 })

            Column() {
                List({ space: 12 }) {
                    Repeat(this.mediaLibraryVM.favouriteList)
                        .each((repeatItem) => {
                            ListItem() {
                                CollectionItemView({
                                    index: repeatItem.index,
                                    item: repeatItem.item,
                                    primaryColor: this.themeVM.primaryColor,
                                    isHighlight: this.playerVM.currentItem === repeatItem.item,
                                    unCollection: () => {
                                        this.mediaLibraryVM.updateFavourite(repeatItem.item, 0)
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

