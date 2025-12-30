import { duration2Text } from '../../base/extensions/Extensions'
import { ImageView } from '../../base/view/ImageView'
import { DEFAULT_PRIMARY_COLOR, DEFAULT_PRIMARY_COLOR_DARK } from '../tabs/settings/vm/ThemeVM'

/**
 *
 * Author: Seagazer
 * Date: 2025/12/15
 */
@ComponentV2
export struct FloatControllerView {
    @Param primaryColor: string = DEFAULT_PRIMARY_COLOR
    @Param primaryColorDark: string = DEFAULT_PRIMARY_COLOR_DARK
    @Param title: string = ""
    @Param artist: string = ""
    @Param isPlaying: boolean = false
    @Param progress: number = 0
    @Param duration: number = 0
    @Param cover?: string = undefined
    @Event onPlayButtonClick: () => void
    @Event onContainerClick: () => void
    @Local fadeAnimFlag: boolean = false
    private readonly animationDuration = 800

    @Monitor("cover")
    onCoverChanged() {
        this.getUIContext().animateTo({ duration: this.animationDuration }, () => {
            this.fadeAnimFlag = !this.fadeAnimFlag
        })
    }

    build() {
        Stack() {
            Stack()
                .width(this.progress / this.duration * 100 + "%")
                .height("100%")
                .backgroundColor("#33ffffff")
            Row() {
                if (this.fadeAnimFlag) {
                    ImageView({ url: this.cover, corner: 4 })
                        .height("100%")
                        .aspectRatio(1)
                        .geometryTransition("cover")
                        .transition(TransitionEffect.OPACITY)
                } else {
                    ImageView({ url: this.cover, corner: 4 })
                        .height("100%")
                        .aspectRatio(1)
                        .geometryTransition("cover")
                        .transition(TransitionEffect.OPACITY)
                }
                Column() {
                    Text(this.title)
                        .fontColor(this.primaryColor)
                        .animation({ duration: this.animationDuration })
                        .fontSize(24)
                        .fontWeight(FontWeight.Bold)
                        .maxLines(1)
                        .textOverflow({ overflow: TextOverflow.MARQUEE })
                        .width("100%")
                    Text(this.artist)
                        .fontColor(this.primaryColor)
                        .animation({ duration: this.animationDuration })
                        .fontSize(18)
                        .maxLines(1)
                        .textOverflow({ overflow: TextOverflow.MARQUEE })
                        .width("100%")
                }
                .width(250)
                .height("100%")
                .padding({ left: 16 })
                .justifyContent(FlexAlign.SpaceAround)
                .displayPriority(1)

                Blank()

                SymbolGlyph(this.isPlaying ? $r("sys.symbol.pause_fill") : $r("sys.symbol.play_fill"))
                    .fontColor([this.primaryColor])
                    .animation({ duration: this.animationDuration })
                    .fontSize(32)
                    .clickEffect({ level: ClickEffectLevel.HEAVY, scale: 0.8 })
                    .hoverEffect(HoverEffect.Highlight)
                    .margin({ right: 16 })
                    .onClick(() => {
                        this.onPlayButtonClick?.()
                    })

                Text() {
                    Span(duration2Text(this.progress))
                        .fontSize(24)
                    Span(" / " + duration2Text(this.duration))
                        .fontWeight(FontWeight.Bold)
                        .fontSize(18)
                }
                .fontColor(this.primaryColor)
                .animation({ duration: this.animationDuration })
                .textAlign(TextAlign.End)
            }
            .width("100%")
            .height("100%")
            .padding(16)
        }
        .align(Alignment.Start)
        .width("100%")
        .height("100%")
        .constraintSize({ minHeight: 64 })
        .border({ radius: 12, width: 0 })
        .shadow({
            radius: 12,
            color: "#4d000000",
            offsetX: 12,
            offsetY: 12
        })
        .backgroundColor(this.primaryColorDark)
        .animation({ duration: this.animationDuration })
        .clip(true)
        .onClick(() => {
            this.onContainerClick?.()
        })
    }
}

