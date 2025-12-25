import { ThemeVM } from './tabs/settings/vm/ThemeVM'
import { AppStorageV2 } from '@kit.ArkUI'
import { FloatControllerView } from './view/FloatControllerView'
import { PlayerVM } from '../player/vm/PlayerVM'
import { common } from '@kit.AbilityKit'
import { TabItemView } from './view/TabItemView'
import { MediaLibraryVM } from './tabs/library/vm/MediaLibraryVM'
import { RouterConstants } from '../base/Router'
import { TabConfig, TabItem } from './TabConfig'

/**
 *
 * Author: Seagazer
 * Date: 2025/12/16
 */
@ComponentV2
export struct HomePage {
    private theme: ThemeVM = AppStorageV2.connect<ThemeVM>(ThemeVM, () => new ThemeVM())!
    private player: PlayerVM = AppStorageV2.connect<PlayerVM>(PlayerVM, () => new PlayerVM())!
    private playlist: MediaLibraryVM = AppStorageV2.connect<MediaLibraryVM>(MediaLibraryVM, () => new MediaLibraryVM())!
    private navigation = new NavPathStack()
    @Local gradientRadius: number = 0
    @Local selectedTabIndex: number = 0
    private tabsController = new TabsController()

    build() {
        NavDestination() {
            Stack() {
                // todo tab container
                Row() {
                    Column() {
                        ForEach(TabConfig, (item: TabItem) => {
                            TabItemView({
                                index: item.index,
                                icon: item.icon,
                                title: item.title,
                                isSelected: this.selectedTabIndex === item.index
                            }).onClick(() => {
                                this.selectedTabIndex = item.index
                                this.tabsController.changeIndex(item.index)
                            })
                        })
                    }
                    .width(200)
                    .height("100%")
                    .backgroundColor("#1affffff")
                    .justifyContent(FlexAlign.Start)
                    .alignItems(HorizontalAlign.Start)
                    .padding({ top: this.theme.rootPaddingTop, bottom: this.theme.rootPaddingBottom })

                    Tabs({ controller: this.tabsController }) {
                        ForEach(TabConfig, (item: TabItem) => {
                            item.tabView.builder()
                        })
                    }
                    .barWidth(0)
                    .barHeight(0)
                    .layoutWeight(1)
                    .height("100%")
                    .animationDuration(0)
                    .scrollable(false)
                }
                .width("100%")
                .height("100%")

                if (this.playlist.playingItem !== undefined) {
                    FloatControllerView({
                        primaryColor: this.theme.primaryColor,
                        primaryColorDark: this.theme.primaryColorDark,
                        title: this.player.mediaTitle,
                        artist: this.player.mediaArtist,
                        isPlaying: this.player.isPlaying,
                        progress: this.player.userProgress,
                        duration: this.player.duration,
                        cover: this.player.coverImage,
                        onPlayButtonClick: () => {
                            if (this.player.isPlaying) {
                                this.player.pause()
                            } else {
                                this.player.start()
                            }
                        },
                        onContainerClick: () => {
                            this.getUIContext().animateTo({ duration: 300 }, () => {
                                this.navigation.pushPath({ name: "detail" }, false)
                            })
                        }
                    }).width("80%")
                        .height(80)
                        .geometryTransition("controller", { follow: true })
                        .margin({ bottom: 24 })
                }

            }.align(Alignment.Bottom)
        }
        .height('100%')
        .width('100%')
        .radialGradient({
            center: ["50%", "50%"],
            radius: this.gradientRadius === 0 ? "100%" : this.gradientRadius,
            colors: [[this.theme!.primaryColor, 0], ["#bf000000", 1]]
        })
        .animation({ duration: 1000 })
        .onSizeChange((_, size) => {
            let w = size.width as number
            let h = size.height as number
            this.gradientRadius = Math.min(w, h)
        })
        .title(RouterConstants.HOME)
        .hideTitleBar(true)
        .transition(TransitionEffect.OPACITY)
        .onReady((context) => {
            this.navigation = context.pathStack
        })
        .onBackPressed(() => {
            const context = this.getUIContext().getHostContext() as common.UIAbilityContext
            context.terminateSelf().catch(() => {
            })
            return true
        })
    }
}