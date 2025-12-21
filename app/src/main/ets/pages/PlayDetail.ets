import { ThemeVM } from '../vm/ThemeVM'
import { AppStorageV2 } from '@kit.ArkUI'
import { duration2Text } from '../extensions/Extensions'
import { CcLrcController, CcLyricView } from '@seagazer/cclyric'
import { MockData, StringParser } from '../mock/MockData'
import { XLogger } from '../extensions/XLogger'
import { PlayerVM } from '../vm/PlayerVM'
import { Palette } from '../view/Palette'
import { PlaylistVM } from '../vm/PlaylistVM'

const TAG = "[PlayDetail]"

/**
 *
 * Author: Seagazer
 * Date: 2025/12/16
 */
@ComponentV2
export struct PlayDetail {
    private theme: ThemeVM = AppStorageV2.connect<ThemeVM>(ThemeVM, () => new ThemeVM())!
    @Local player: PlayerVM = AppStorageV2.connect<PlayerVM>(PlayerVM, () => new PlayerVM())!
    private playlist: PlaylistVM = AppStorageV2.connect<PlaylistVM>(PlaylistVM, () => new PlaylistVM())!
    @Local gradientRadius: number = 0
    private lrcController = new CcLrcController()
    private navPath = new NavPathStack()

    @Monitor("player.progress")
    onProgressChanged() {
        this.lrcController.updatePosition(this.player.progress)
    }

    aboutToAppear(): void {
        this.lrcController
            .setLineSpace(12)
            .setTextSize(22)
            .setHighlightScale(1.1)
            .setTextColor(Palette.stringToHex(this.theme!.primaryColor))
            .setTextHighlightColor(Palette.stringToHex(this.theme!.primaryColorDark))
            .setFadeColor(Color.Transparent)
            .setEmptyHint("未找到歌词")
        // todo test lyric data
        const lyric = new StringParser().parse(MockData.krc3)
        this.lrcController.setLyric(lyric)
    }

    build() {
        NavDestination() {
            Column() {
                SymbolGlyph($r("sys.symbol.chevron_down"))
                    .fontColor([this.theme?.primaryColor])
                    .fontSize(32)
                    .clickEffect({ level: ClickEffectLevel.HEAVY, scale: 0.8 })
                    .hoverEffect(HoverEffect.Highlight)
                    .margin({ left: 16, top: 16 })
                    .opacity(0.5)
                    .transition(TransitionEffect.OPACITY)
                    .animation({ duration: 500 })
                    .onClick(() => {
                        this.back()
                    })

                Row() {
                    Column() {
                        Image(this.player.coverImage)
                            .objectFit(ImageFit.Cover)
                            .width(240)
                            .height(240)
                            .displayPriority(2)
                            .border({ radius: 8 })
                        Text(this.player.mediaTitle)
                            .fontColor(this.theme?.primaryColor)
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
                        Text(this.player.mediaAuthor)
                            .fontColor(this.theme?.primaryColor)
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

                    if (this.player.showLyric) {
                        Column() {
                            CcLyricView({
                                controller: this.lrcController,
                                supportSeek: false,
                                onDataSourceReady: () => {
                                    XLogger.w(TAG, "init scroll to " + this.player.progress)
                                    this.lrcController.updatePosition(this.player.progress, true)
                                }
                            })
                        }
                        .layoutWeight(1)
                        .height("60%")
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
                        max: this.player.duration,
                        value: this.player.progress
                    })
                        .width("100%")
                        .trackColor(this.theme?.primaryColorDark)
                        .selectedColor(this.theme?.primaryColor)

                    // TODO controller bar
                    Row() {
                        Text() {
                            Span(duration2Text(this.player.progress))
                                .fontSize(24)
                            Span(" / " + duration2Text(this.player.duration))
                                .fontWeight(FontWeight.Lighter)
                                .fontSize(18)
                        }
                        .fontColor(this.theme?.primaryColor)
                        .animation({ duration: 1000 })
                        .textAlign(TextAlign.End)
                        .displayPriority(1)


                        Blank()

                        if (!this.playlist.isEmpty) {
                            SymbolGlyph($r("sys.symbol.backward_end_fill"))
                                .fontColor([this.theme?.primaryColor])
                                .fontSize(32)
                                .clickEffect({ level: ClickEffectLevel.HEAVY, scale: 0.8 })
                                .hoverEffect(HoverEffect.Highlight)
                                .margin({ left: 16 })
                                .transition(TransitionEffect.OPACITY)
                                .onClick(() => {
                                })

                            SymbolGlyph($r("sys.symbol.forward_end_fill"))
                                .fontColor([this.theme?.primaryColor])
                                .fontSize(32)
                                .clickEffect({ level: ClickEffectLevel.HEAVY, scale: 0.8 })
                                .hoverEffect(HoverEffect.Highlight)
                                .margin({ left: 16 })
                                .transition(TransitionEffect.OPACITY)
                                .onClick(() => {
                                })
                        }

                        SymbolGlyph(this.player.isPlaying ? $r("sys.symbol.pause_fill") : $r("sys.symbol.play_fill"))
                            .fontColor([this.theme?.primaryColor])
                            .fontSize(32)
                            .clickEffect({ level: ClickEffectLevel.HEAVY, scale: 0.8 })
                            .hoverEffect(HoverEffect.Highlight)
                            .margin({ left: 16 })
                            .onClick(() => {
                                this.getUIContext().animateTo({ duration: 500 }, () => {
                                    this.playlist.isEmpty = !this.playlist.isEmpty
                                })
                            })

                        if (!this.playlist.isEmpty) {
                            SymbolGlyph($r("sys.symbol.list_square"))
                                .fontColor([this.theme?.primaryColor])
                                .fontSize(32)
                                .clickEffect({ level: ClickEffectLevel.HEAVY, scale: 0.8 })
                                .hoverEffect(HoverEffect.Highlight)
                                .margin({ left: 16 })
                                .transition(TransitionEffect.OPACITY)
                                .onClick(() => {
                                })
                        }

                        SymbolGlyph($r("sys.symbol.lyrics_square"))
                            .fontColor([this.theme?.primaryColor])
                            .fontSize(32)
                            .clickEffect({ level: ClickEffectLevel.HEAVY, scale: 0.8 })
                            .hoverEffect(HoverEffect.Highlight)
                            .margin({ left: 16 })
                            .onClick(() => {
                                this.getUIContext().animateTo({ duration: 500 }, () => {
                                    this.player.showLyric = !this.player.showLyric
                                })
                            })
                    }
                    .width("100%")
                    .padding({ bottom: 16, left: 16, right: 16 })
                }
                .width("100%")
                .geometryTransition("controller")
                .transition(TransitionEffect.OPACITY)
            }
            .height('100%')
            .width('100%')
            .alignItems(HorizontalAlign.Start)
            .radialGradient({
                center: ["50%", "50%"],
                radius: this.gradientRadius === 0 ? "100%" : this.gradientRadius,
                colors: [[this.theme!.primaryColor, 0], ["#bf000000", 1]]
            })
            .padding({ top: 32 })
        }
        .height('100%')
        .width('100%')
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