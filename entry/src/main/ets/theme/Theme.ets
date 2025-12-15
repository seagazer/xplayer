/**
 *
 * Author: Seagazer
 * Date: 2025/12/15
 */
@ObservedV2
export class XTheme {
    @Trace primaryColor: string = DEFAULT_PRIMARY_COLOR
    @Trace primaryColorDark: string = DEFAULT_PRIMARY_COLOR_DARK
}

export const DEFAULT_PRIMARY_COLOR = "#ff92c6e5"

export const DEFAULT_PRIMARY_COLOR_DARK = "#ff276f84"