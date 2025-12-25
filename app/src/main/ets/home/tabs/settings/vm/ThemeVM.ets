import { IVM } from "../../../../base/IVM"

/**
 *
 * Author: Seagazer
 * Date: 2025/12/15
 */
@ObservedV2
export class ThemeVM implements IVM {
    @Trace primaryColor: string = DEFAULT_PRIMARY_COLOR
    @Trace primaryColorDark: string = DEFAULT_PRIMARY_COLOR_DARK
    @Trace rootPaddingTop: number = 0
    @Trace rootPaddingBottom: number = 0
    @Trace rootPaddingLeft: number = 16
    @Trace rootPaddingRight: number = 16

    async onCreate(context: UIContext) {
    }

    onDestroy(): void {

    }

    reset() {
        this.primaryColor = DEFAULT_PRIMARY_COLOR
        this.primaryColorDark = DEFAULT_PRIMARY_COLOR_DARK
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


export const DEFAULT_PRIMARY_COLOR = "#ff92c6e5"

export const DEFAULT_PRIMARY_COLOR_DARK = "#ff276f84"