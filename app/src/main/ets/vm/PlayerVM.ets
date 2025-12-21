import { MediaSource } from "@seagazer/ccplayer"

/**
 *
 * Author: Seagazer
 * Date: 2025/12/16
 */
@ObservedV2
export class PlayerVM {
    @Trace isPlaying: boolean = false
    @Trace mediaSource?: MediaSource = undefined
    @Trace progress: number = 0
    @Trace duration: number = 250000
    @Trace mediaTitle: string = "One Last Kiss"
    @Trace mediaAuthor: string = "宇多田光"
    @Trace showLyric: boolean = false
    @Trace coverImage: PixelMap | Resource = $r("app.media.cover")

    start() {
        this.isPlaying = true
    }

    pause() {
        this.isPlaying = false
    }
}