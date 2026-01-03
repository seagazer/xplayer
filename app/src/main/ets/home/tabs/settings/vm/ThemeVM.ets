import { animate } from '../../../../base/extensions/Extensions'
import { IVM } from '../../../../base/IVM'
import { UIConstants } from '../../../../base/UIConstants'
import { Palette } from '../../../../base/view/Palette'

/**
 *
 * Author: Seagazer
 * Date: 2025/12/15
 */
@ObservedV2
export class ThemeVM implements IVM {
    @Trace primaryColor: string = UIConstants.DEFAULT_PRIMARY_COLOR
    @Trace primaryColorDark: string = UIConstants.DEFAULT_PRIMARY_COLOR_DARK
    @Trace rootPaddingTop: number = 0
    @Trace rootPaddingBottom: number = 0
    @Trace rootPaddingLeft: number = 16
    @Trace rootPaddingRight: number = 16
    private palette = new Palette()
    private context?: UIContext = undefined

    async onCreate(context: UIContext) {
        this.context = context
    }

    onDestroy(): void {

    }

    reset() {
        animate(this.context!, () => {
            this.primaryColor = UIConstants.DEFAULT_PRIMARY_COLOR
            this.primaryColorDark = UIConstants.DEFAULT_PRIMARY_COLOR_DARK
        }, 500, false)
    }

    updateByPixelmap(pixelmap: PixelMap | undefined) {
        if (pixelmap !== undefined) {
            this.palette.setImage(pixelmap).then(() => {
                const color = this.palette.getThemeColor()
                animate(this.context!, () => {
                    this.primaryColor = color[0]
                    this.primaryColorDark = color[1]
                }, 500, true)
            })
        } else {
            this.reset()
        }
    }

    update(primaryColor: string, primaryColorDark: string) {
        animate(this.context!, () => {
            this.primaryColor = primaryColor
            this.primaryColorDark = primaryColorDark
        }, 500, false)
    }

    updatePrimaryColor(primaryColor: string) {
        this.primaryColor = primaryColor
    }

    updatePrimaryColorDark(primaryColorDark: string) {
        this.primaryColorDark = primaryColorDark
    }
}