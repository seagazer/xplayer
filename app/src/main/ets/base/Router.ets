import { HomePage } from '../home/HomePage'
import { PlayerPage } from '../player/PlayerPage'
import { SplashPage } from '../splash/SplashPage'

/**
 *
 * Author: Seagazer
 * Date: 2025/12/25
 */
export class RouterConstants {
    static readonly SPLASH = "SPLASH"
    static readonly WELCOME = "WELCOME"
    static readonly HOME = "HOME"
    static readonly PLAYER = "PLAYER"
}

@Builder
export function RouterMapper(title: string) {
    if (title === RouterConstants.SPLASH) {
        SplashPage()
    } else if (title === RouterConstants.HOME) {
        HomePage()
    } else if (title === RouterConstants.PLAYER) {
        PlayerPage()
    }
}