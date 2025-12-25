import { ThemeVM } from '../vm/ThemeVM'
import { AppStorageV2, CommonModifier } from '@kit.ArkUI'
import { FloatControllerView } from '../view/FloatControllerView'
import { PlayerVM } from '../vm/PlayerVM'
import { common } from '@kit.AbilityKit'
import { TabSettings } from './TabSettings'
import { TabItem } from '../view/TabItem'
import { TabLibrary } from './TabLibrary'
import { PlaylistVM } from '../vm/PlaylistVM'

/**
 *
 * Author: Seagazer
 * Date: 2025/12/16
 */
@ComponentV2
export struct Home {
    private theme: ThemeVM = AppStorageV2.connect<ThemeVM>(ThemeVM, () => new ThemeVM())!
    private player: PlayerVM = AppStorageV2.connect<PlayerVM>(PlayerVM, () => new PlayerVM())!
    private playlist: PlaylistVM = AppStorageV2.connect<PlaylistVM>(PlaylistVM, () => new PlaylistVM())!
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
                        TabItem({
                            index: 0,
                            icon: $r("sys.symbol.music"),
                            title: "音乐",
                            isSelected: this.selectedTabIndex === 0
                        }).onClick(() => {
                            this.selectedTabIndex = 0
                            this.tabsController.changeIndex(0)
                        })
                        TabItem({
                            index: 1,
                            icon: $r("sys.symbol.record_circle"),
                            title: "专辑",
                            isSelected: this.selectedTabIndex === 1
                        }).onClick(() => {
                        })
                        TabItem({
                            index: 2,
                            icon: $r("sys.symbol.heart"),
                            title: "收藏",
                            isSelected: this.selectedTabIndex === 2
                        }).onClick(() => {
                        })
                        TabItem({
                            index: 3,
                            icon: $r("sys.symbol.music_note_list"),
                            title: "播放列表",
                            isSelected: this.selectedTabIndex === 3
                        }).onClick(() => {
                        })
                        TabItem({
                            index: 4,
                            icon: $r("sys.symbol.gearshape"),
                            title: "设置",
                            isSelected: this.selectedTabIndex === 4
                        }).onClick(() => {
                            this.selectedTabIndex = 4
                            this.tabsController.changeIndex(1)
                        })
                    }
                    .width(200)
                    .height("100%")
                    .backgroundColor("#1affffff")
                    .justifyContent(FlexAlign.Start)
                    .alignItems(HorizontalAlign.Start)
                    .padding({ top: this.theme.statusBarHeight, bottom: this.theme.navigationBarHeight })

                    Tabs({ controller: this.tabsController, barModifier: new CommonModifier().align(Alignment.Top) }) {
                        TabContent() {
                            TabLibrary()
                        }

                        TabContent() {
                            TabSettings()
                        }
                    }
                    .vertical(true)
                    .barMode(BarMode.Scrollable)
                    .barWidth(0)
                    .layoutWeight(1)
                    .height("100%")
                    .animationMode(AnimationMode.NO_ANIMATION)
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
                    })
                        .width("80%")
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
        .title("home")
        .hideTitleBar(true)
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