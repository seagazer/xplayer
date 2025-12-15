import { AppStorageV2 } from '@kit.ArkUI'
import { XTheme } from '../theme/Theme'

/**
 *
 * Author: Seagazer
 * Date: 2025/12/15
 */
@ComponentV2
export struct FloatControllerView {
    @Param progress: number = 0
    @Param duration: number = 0
    @Param coverImage: PixelMap | ResourceStr | DrawableDescriptor = $r("app.media.startIcon")
    @Param title: string = "One Last Kiss"
    @Param subTitle: string = "宇多田光"
    @Param isPlaying: boolean = false
    @Event onButtonClick: () => void
    @Event onContainerClick: () => void
    private theme?: XTheme = undefined

    aboutToAppear(): void {
        this.theme = AppStorageV2.connect<XTheme>(XTheme, () => new XTheme())
    }

    build() {
        Stack() {
            Stack()
                .width(this.progress / this.duration * 100 + "%")
                .height("100%")
                .backgroundColor("#33ffffff")
                .animation({ duration: 1000 })
            Row() {
                Image(this.coverImage)
                    .id("media_icon")
                    .objectFit(ImageFit.Cover)
                    .height("100%")
                    .aspectRatio(1)
                    .displayPriority(2)
                    .border({ radius: 4 })
                Column() {
                    Text(this.title)
                        .id("media_title")
                        .fontColor(this.theme?.primaryColor)
                        .fontSize(24)
                        .fontWeight(FontWeight.Bold)
                        .maxLines(1)
                        .textOverflow({ overflow: TextOverflow.MARQUEE })
                        .width("100%")
                        .animation({ duration: 500 })
                        .animation({ duration: 1000 })

                    Text(this.subTitle)
                        .id("media_author")
                        .fontColor(this.theme?.primaryColor)
                        .fontSize(18)
                        .maxLines(1)
                        .textOverflow({ overflow: TextOverflow.MARQUEE })
                        .width("100%")
                        .animation({ duration: 500 })
                        .animation({ duration: 1000 })
                }
                .width(150)
                .height("100%")
                .padding({ left: 16 })
                .displayPriority(1)
                .justifyContent(FlexAlign.SpaceAround)

                Blank()

                SymbolGlyph(this.isPlaying ? $r("sys.symbol.pause_fill") : $r("sys.symbol.play_fill"))
                    .id("media_btn")
                    .fontColor([this.theme?.primaryColor])
                    .fontSize(32)
                    .clickEffect({ level: ClickEffectLevel.HEAVY, scale: 0.8 })
                    .hoverEffect(HoverEffect.Highlight)
                    .margin({ right: 16 })
                    .onClick(() => {
                        this.onButtonClick?.()
                    })
                    .displayPriority(2)
                    .animation({ duration: 1000 })

                Text() {
                    Span(duration2Text(this.progress))
                        .fontSize(24)
                    Span(" / " + duration2Text(this.duration))
                        .fontWeight(FontWeight.Bold)
                        .fontSize(18)
                }
                .id("media_progress")
                .fontColor(this.theme?.primaryColor)
                .displayPriority(1)
                .animation({ duration: 1000 })
                .textAlign(TextAlign.End)
            }
            .width("100%")
            .height("100%")
            .padding(12)
        }
        .align(Alignment.Start)
        .width("100%")
        .height("100%")
        .constraintSize({ minHeight: 64 })
        .border({ radius: 12, width: 0 })
        .shadow({
            radius: 16,
            color: "#80000000",
            offsetX: 12,
            offsetY: 16
        })
        .backgroundColor(this.theme?.primaryColorDark)
        .animation({ duration: 1000 })
        .clip(true)
        .onClick(() => {
            this.onContainerClick?.()
        })
    }
}

export function duration2Text(duration: number): string {
    const totalSeconds = Math.floor(duration / 1000);
    const minutes = Math.floor(totalSeconds / 60);
    const seconds = totalSeconds % 60;
    const minutesStr = minutes.toString().padStart(2, '0');
    const secondsStr = seconds.toString().padStart(2, '0');
    return `${minutesStr}:${secondsStr}`;
}