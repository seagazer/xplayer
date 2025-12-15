import { AppStorageV2 } from '@kit.ArkUI'
import { XTheme } from './Theme'

/**
 *
 * Author: Seagazer
 * Date: 2025/12/15
 */
export class ThemeManager {
    private static sInstance?: ThemeManager
    private theme?: XTheme

    private constructor() {
        this.theme = AppStorageV2.connect<XTheme>(XTheme, () => new XTheme())
    }

    static getInstance(): ThemeManager {
        if (ThemeManager.sInstance === undefined) {
            ThemeManager.sInstance = new ThemeManager()
        }
        return ThemeManager.sInstance
    }

    update(primaryColor: string, primaryColorDark: string) {
        if (this.theme === undefined) {
            return
        }
        this.theme.primaryColor = primaryColor
        this.theme.primaryColorDark = primaryColorDark
    }

    updatePrimaryColor(primaryColor: string) {
        if (this.theme === undefined) {
            return
        }
        this.theme.primaryColor = primaryColor
    }

    updatePrimaryColorDark(primaryColorDark: string) {
        if (this.theme === undefined) {
            return
        }
        this.theme.primaryColorDark = primaryColorDark
    }
}