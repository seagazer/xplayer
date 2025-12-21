import { MediaSource } from "@seagazer/ccplayer"

/**
 *
 * Author: Seagazer
 * Date: 2025/12/16
 */
@ObservedV2
export class PlaylistVM {
    @Trace isEmpty: boolean = true
    @Trace playlist: MediaSource[] = []
    @Trace playingIndex: number = 0
    @Trace playingItem?: MediaSource = undefined
}