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

    async onCreate(context: UIContext) {
    }

    onDestroy(): void {

    }

    reset() {
        this.primaryColor = UIConstants.DEFAULT_PRIMARY_COLOR
        this.primaryColorDark = UIConstants.DEFAULT_PRIMARY_COLOR_DARK
    }

    updateByPixelmap(pixelmap: PixelMap | undefined) {
        if (pixelmap !== undefined) {
            this.palette.setImage(pixelmap).then(() => {
                const color = this.palette.getThemeColor()
                this.update(color[0], color[1])
            })
        } else {
            this.reset()
        }
    }

    update(primaryColor: string, primaryColorDark: string) {
        this.primaryColor = primaryColor
        this.primaryColorDark = primaryColorDark
    }

    updatePrimaryColor(primaryColor: string) {
        this.primaryColor = primaryColor
    }

    updatePrimaryColorDark(primaryColorDark: string) {
        this.primaryColorDark = primaryColorDark
    }
}