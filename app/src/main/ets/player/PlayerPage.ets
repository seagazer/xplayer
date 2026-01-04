import { ThemeVM } from '../home/tabs/vm/ThemeVM'
import { AppStorageV2 } from '@kit.ArkUI'
import { duration2Text, stringToHex } from '../base/extensions/Extensions'
import { CcLyricController, CcLyricView } from '@seagazer/cclyric'
import { MockData, StringParser } from '../mock/MockData'
import { XLogger } from '../base/extensions/XLogger'
import { PlayerVM } from './vm/PlayerVM'
import { MediaLibraryVM } from '../home/tabs/vm/MediaLibraryVM'
import { ImageView } from '../base/view/ImageView'

const TAG = "[PlayerPage]"

/**
 *
 * Author: Seagazer
 * Date: 2025/12/16
 */
@ComponentV2({ freezeWhenInactive: true })
export struct PlayerPage {
    private themeVM: ThemeVM = AppStorageV2.connect<ThemeVM>(ThemeVM, () => new ThemeVM())!
    @Local playerVM: PlayerVM = AppStorageV2.connect<PlayerVM>(PlayerVM, () => new PlayerVM())!
    private mediaLibraryVM: MediaLibraryVM = AppStorageV2.connect<MediaLibraryVM>(MediaLibraryVM, () => new MediaLibraryVM())!
    @Local gradientRadius: number = 0
    private lrcController = new CcLyricController()
    private navPath = new NavPathStack()

    @Monitor("playerVM.playerProgress")
    onProgressChanged() {
        this.lrcController.updatePosition(this.playerVM.playerProgress)
    }

    aboutToAppear(): void {
        this.lrcController
            .setLineSpace(12)
            .setTextSize(22)
            .setHighlightScale(1.1)
            .setTextColor(stringToHex(this.themeVM!.primaryColor))
            .setTextHighlightColor(stringToHex(this.themeVM!.primaryColorDark))
            .setFadeColor(Color.Transparent)
            .setEmptyHint("未找到歌词")
            .setLrcAnimDuration(200)
        // todo test lyric data
        const lyric = new StringParser().parse(MockData.krc7)
        XLogger.w(TAG, JSON.stringify(lyric))
        this.lrcController.setLyric(lyric)
    }

    build() {
        NavDestination() {
            Column() {
                Stack() {
                    SymbolGlyph($r("sys.symbol.chevron_left"))
                        .fontColor([this.themeVM?.primaryColor])
                        .fontSize(32)
                }
                .clickEffect({ level: ClickEffectLevel.HEAVY, scale: 0.8 })
                .hoverEffect(HoverEffect.Highlight)
                .width(40)
                .height(40)
                .border({ radius: 20 })
                .backgroundColor("#33ffffff")
                .margin({ left: 16 })
                .onClick(() => {
                    this.back()
                })


                Row() {
                    Column() {
                        ImageView({ url: this.playerVM.coverUrl, corner: 16 })
                            .width(240)
                            .height(240)
                        Text(this.playerVM.mediaTitle)
                            .fontColor(this.themeVM?.primaryColor)
                            .fontSize(24)
                            .fontWeight(FontWeight.Bold)
                            .maxLines(1)
                            .textOverflow({ overflow: TextOverflow.MARQUEE })
                            .textShadow({
                                radius: 8,
                                color: "#ff000000",
                                type: ShadowType.BLUR,
                                offsetX: 4,
                                offsetY: 4
                            })
                            .clip(false)
                            .margin({ top: 24 })
                        Text(this.playerVM.mediaArtist)
                            .fontColor(this.themeVM?.primaryColor)
                            .fontSize(18)
                            .maxLines(1)
                            .textOverflow({ overflow: TextOverflow.MARQUEE })
                            .textShadow({
                                radius: 8,
                                color: "#ff000000",
                                type: ShadowType.BLUR,
                                offsetX: 4,
                                offsetY: 4
                            })
                            .clip(false)
                            .margin({ top: 16 })
                    }
                    .layoutWeight(1)
                    .height("100%")
                    .justifyContent(FlexAlign.Center)

                    if (this.playerVM.showLyric) {
                        Column() {
                            CcLyricView({
                                controller: this.lrcController,
                                supportSeek: false,
                                onDataSourceReady: () => {
                                    XLogger.w(TAG, "init scroll to " + this.playerVM.userProgress)
                                    this.lrcController.updatePosition(this.playerVM.playerProgress)
                                }
                            })
                        }
                        .layoutWeight(1)
                        .height("80%")
                        .justifyContent(FlexAlign.Center)
                        .transition(TransitionEffect.OPACITY.combine(TransitionEffect.translate({ y: 40 })))
                    }
                }
                .width("100%")
                .layoutWeight(1)
                .justifyContent(FlexAlign.Center)
                .transition(TransitionEffect.OPACITY.combine(TransitionEffect.translate({ y: 40 })).animation({ delay: 100 }))

                Column() {
                    // TODO seek bar
                    Slider({
                        style: SliderStyle.OutSet,
                        max: this.playerVM.duration,
                        value: this.playerVM.userProgress
                    })
                        .width("100%")
                        .trackColor(this.themeVM?.primaryColorDark)
                        .selectedColor(this.themeVM?.primaryColor)
                        .onChange((value, mode) => {
                            this.playerVM.onSeekChanged(value, mode)
                        })

                    // controller bar
                    Row() {
                        Text() {
                            Span(duration2Text(this.playerVM.playerProgress))
                                .fontSize(24)
                            Span(" / " + duration2Text(this.playerVM.duration))
                                .fontSize(18)
                        }
                        .fontColor(this.themeVM?.primaryColor)
                        .animation({ duration: 1000 })
                        .textAlign(TextAlign.End)

                        Blank()

                        if (!this.mediaLibraryVM.isEmpty) {
                            SymbolGlyph($r("sys.symbol.backward_end_fill"))
                                .fontColor([this.themeVM?.primaryColor])
                                .fontSize(32)
                                .clickEffect({ level: ClickEffectLevel.HEAVY, scale: 0.8 })
                                .hoverEffect(HoverEffect.Highlight)
                                .margin({ left: 16 })
                                .transition(TransitionEffect.OPACITY)
                                .onClick(() => {
                                })

                            SymbolGlyph($r("sys.symbol.forward_end_fill"))
                                .fontColor([this.themeVM?.primaryColor])
                                .fontSize(32)
                                .clickEffect({ level: ClickEffectLevel.HEAVY, scale: 0.8 })
                                .hoverEffect(HoverEffect.Highlight)
                                .margin({ left: 16 })
                                .transition(TransitionEffect.OPACITY)
                                .onClick(() => {
                                })
                        }

                        SymbolGlyph(this.playerVM.isPlaying ? $r("sys.symbol.pause_fill") : $r("sys.symbol.play_fill"))
                            .fontColor([this.themeVM?.primaryColor])
                            .fontSize(32)
                            .clickEffect({ level: ClickEffectLevel.HEAVY, scale: 0.8 })
                            .hoverEffect(HoverEffect.Highlight)
                            .margin({ left: 16 })
                            .onClick(() => {
                                if (this.playerVM.isPlaying) {
                                    this.playerVM.pause()
                                } else {
                                    this.playerVM.start()
                                }
                            })

                        if (!this.mediaLibraryVM.isEmpty) {
                            SymbolGlyph($r("sys.symbol.list_square"))
                                .fontColor([this.themeVM?.primaryColor])
                                .fontSize(32)
                                .clickEffect({ level: ClickEffectLevel.HEAVY, scale: 0.8 })
                                .hoverEffect(HoverEffect.Highlight)
                                .margin({ left: 16 })
                                .transition(TransitionEffect.OPACITY)
                                .onClick(() => {
                                })
                        }

                        SymbolGlyph($r("sys.symbol.lyrics_square"))
                            .fontColor([this.themeVM?.primaryColor])
                            .fontSize(32)
                            .clickEffect({ level: ClickEffectLevel.HEAVY, scale: 0.8 })
                            .hoverEffect(HoverEffect.Highlight)
                            .margin({ left: 16 })
                            .onClick(() => {
                                this.getUIContext().animateTo({ duration: 500 }, () => {
                                    this.playerVM.showLyric = !this.playerVM.showLyric
                                })
                            })
                    }
                    .width("100%")
                    .padding({ bottom: 16, left: 16, right: 16 })
                }
                .width("100%")
                .geometryTransition("controller")

                // .transition(TransitionEffect.OPACITY)
            }
            .height('100%')
            .width('100%')
            .padding({
                top: this.themeVM.rootPaddingTop,
                bottom: this.themeVM.rootPaddingBottom,
            })
            .alignItems(HorizontalAlign.Start)
            .radialGradient({
                center: ["50%", "50%"],
                radius: this.gradientRadius === 0 ? "100%" : this.gradientRadius,
                colors: [[this.themeVM!.primaryColor, 0], ["#bf000000", 1]]
            })
        }
        .width('100%')
        .height('100%')
        .backgroundColor(Color.Black)
        .title("detail")
        .hideTitleBar(true)
        .onReady((context: NavDestinationContext) => {
            this.navPath = context.pathStack
        })
        .onBackPressed(() => {
            this.back()
            return true
        })
        .onSizeChange((_, size) => {
            let w = size.width as number
            let h = size.height as number
            this.gradientRadius = Math.min(w, h)
        })
    }

    private back() {
        this.getUIContext().animateTo({ duration: 500 }, () => {
            this.navPath.pop(false)
        })
    }
}