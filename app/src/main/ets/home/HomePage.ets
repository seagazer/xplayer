import { ThemeVM } from './tabs/vm/ThemeVM'
import { FloatControllerView } from './view/FloatControllerView'
import { PlayerVM } from '../player/vm/PlayerVM'
import { TabItemView } from './view/TabItemView'
import { RouterConstants } from '../base/Router'
import { TabConfig, TabItem } from './TabConfig'
import { UIConstants } from '../base/UIConstants'
import { PlayingAnimation } from '../base/view/PlayingAnimation'
import { VMProvider } from '../VMProvider'

/**
 *
 * Author: Seagazer
 * Date: 2025/12/16
 */
@ComponentV2({ freezeWhenInactive: true })
export struct HomePage {
    @Local themeVM: ThemeVM = VMProvider.get().getVM("ThemeVM") as ThemeVM
    private playerVM: PlayerVM = VMProvider.get().getVM("PlayerVM") as PlayerVM
    private navigation = new NavPathStack()
    @Local gradientRadius: number = 0
    @Local selectedTabIndex: number = 0
    private tabsController = new TabsController()

    build() {
        NavDestination() {
            Stack() {
                Row() {
                    Column({ space: 8 }) {
                        Row() {
                            Text("Listen")
                                .fontSize(36)
                                .fontWeight(FontWeight.Bold)
                                .fontColor(UIConstants.DEFAULT_PRIMARY_COLOR)
                            Stack() {
                                if (this.playerVM.isPlaying) {
                                    PlayingAnimation({
                                        themeColor: this.themeVM.primaryColor,
                                        viewSize: 24
                                    }).transition(TransitionEffect.OPACITY)
                                }
                            }
                            .width(24)
                            .height(24)
                            .margin({ left: 16 })
                        }
                        .width("100%")
                        .margin({ bottom: 16 })
                        .alignItems(VerticalAlign.Center)
                        .justifyContent(FlexAlign.Start)

                        ForEach(TabConfig, (item: TabItem) => {
                            TabItemView({
                                index: item.index,
                                icon: item.icon,
                                title: item.title,
                                isSelected: this.selectedTabIndex === item.index,
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
                    .padding({
                        top: this.themeVM.rootPaddingTop,
                        bottom: this.themeVM.rootPaddingBottom,
                        left: 16,
                        right: 16
                    })

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

                FloatControllerView({
                    primaryColor: this.themeVM.primaryColor,
                    primaryColorDark: this.themeVM.primaryColorDark,
                    title: this.playerVM.mediaTitle,
                    artist: this.playerVM.mediaArtist,
                    isPlaying: this.playerVM.isPlaying,
                    progress: this.playerVM.userProgress,
                    duration: this.playerVM.duration,
                    cover: this.playerVM.coverUrl,
                    onPlayButtonClick: () => {
                        if (this.playerVM.isPlaying) {
                            this.playerVM.pause()
                        } else {
                            this.playerVM.start()
                        }
                    },
                    onContainerClick: () => {
                        this.getUIContext().animateTo({ duration: UIConstants.PAGE_TRANSITION_DURATION }, () => {
                            this.navigation.pushPath({ name: RouterConstants.PLAYER }, false)
                        })
                    }
                })
                    .width("80%")
                    .height(80)
                    .geometryTransition("controller", { follow: true })
                    .margin({ bottom: 24 })
                    .translate({ y: this.playerVM.currentItem !== undefined ? 0 : 160 })
                    .animation({ duration: UIConstants.VIEW_TRANSITION_DURATION, curve: Curve.Smooth })

            }.align(Alignment.Bottom)
        }
        .height('100%')
        .width('100%')
        .backgroundColor("#ff1f201e")
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

        // .onBackPressed(() => {
        //     const context = this.getUIContext().getHostContext() as common.UIAbilityContext
        //     context.terminateSelf().catch(() => {
        //     })
        //     return true
        // })
    }
}