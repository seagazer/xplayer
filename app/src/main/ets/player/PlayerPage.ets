import { ThemeVM } from '../home/tabs/vm/ThemeVM'
import { AppStorageV2 } from '@kit.ArkUI'
import { duration2Text, stringToHex } from '../base/extensions/Extensions'
import { AlignMode, CcLyricController, CcLyricView } from '@seagazer/cclyric'
import { XLogger } from '../base/extensions/XLogger'
import { PlayerVM } from './vm/PlayerVM'
import { MediaLibraryVM } from '../home/tabs/vm/MediaLibraryVM'
import { ImageView } from '../base/view/ImageView'
import { UIConstants } from '../base/UIConstants'
import { LyricParser } from '../base/LyricParser'
import { MediaFile } from '../base/model/MediaFile'

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
    private parser = new LyricParser()

    @Monitor("playerVM.playerProgress")
    onProgressChanged() {
        this.lrcController.updatePosition(this.playerVM.playerProgress)
    }

    @Monitor("playerVM.currentItem")
    onMediaChanged() {
        const playingItem = this.playerVM.currentItem
        if (playingItem !== undefined) {
            this.changeLyric(playingItem)
        }
    }

    private changeLyric(playingItem: MediaFile) {
        const title = playingItem.title
        const uri = playingItem.uri
        const index = uri.lastIndexOf("/")
        XLogger.w(TAG, "uri= " + uri)
        const lyricUri = uri.substring(0, index) + "/" + title + ".lrc"
        XLogger.w(TAG, "lyric uri= " + lyricUri)
        const lyric = this.parser.parseFile(lyricUri)
        this.lrcController.setLyric(lyric)
    }

    aboutToAppear(): void {
        this.lrcController
            .setLineSpace(12)
            .setTextSize(22)
            .setHighlightScale(1.1)
            .setKrcTextBgColor(0xccc6ba75)
            .setTextColor(stringToHex(this.themeVM!.primaryColor))
            .setTextHighlightColor(stringToHex(this.themeVM!.primaryColorDark))
            .setEmptyHint("未找到歌词")
            .setFadePercent(0.25)
            .setAlignMode(AlignMode.START)
        if (this.playerVM.currentItem !== undefined) {
            this.changeLyric(this.playerVM.currentItem)
        }
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
                        Text("  " + this.playerVM.mediaTitle + "  ")
                            .textAlign(TextAlign.Center)
                            .fontColor(this.themeVM?.primaryColor)
                            .fontSize(24)
                            .maxLines(1)
                            .textOverflow({ overflow: TextOverflow.MARQUEE })
                            .textShadow({
                                radius: 8,
                                color: "#80000000",
                                type: ShadowType.BLUR,
                                offsetX: 4,
                                offsetY: 4
                            })
                            .fontWeight(FontWeight.Bold)
                            .margin({ top: 24 })
                            .padding({ left: 32, right: 32 })
                        Text("  " + this.playerVM.mediaArtist + "  ")
                            .textAlign(TextAlign.Center)
                            .fontColor(this.themeVM?.primaryColor)
                            .fontSize(18)
                            .maxLines(1)
                            .textOverflow({ overflow: TextOverflow.MARQUEE })
                            .textShadow({
                                radius: 8,
                                color: "#80000000",
                                type: ShadowType.BLUR,
                                offsetX: 4,
                                offsetY: 4
                            })
                            .margin({ top: 16 })
                            .padding({ left: 32, right: 32 })
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
                                    const pre = this.mediaLibraryVM.getPre(this.playerVM.currentItem)
                                    this.playerVM.setSource(pre)
                                })

                            SymbolGlyph($r("sys.symbol.forward_end_fill"))
                                .fontColor([this.themeVM?.primaryColor])
                                .fontSize(32)
                                .clickEffect({ level: ClickEffectLevel.HEAVY, scale: 0.8 })
                                .hoverEffect(HoverEffect.Highlight)
                                .margin({ left: 16 })
                                .transition(TransitionEffect.OPACITY)
                                .onClick(() => {
                                    const next = this.mediaLibraryVM.getNext(this.playerVM.currentItem)
                                    this.playerVM.setSource(next)
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
                                this.getUIContext().animateTo({ duration: UIConstants.VIEW_TRANSITION_DURATION }, () => {
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
        this.getUIContext().animateTo({ duration: UIConstants.PAGE_TRANSITION_DURATION }, () => {
            this.navPath.pop(false)
        })
    }
}