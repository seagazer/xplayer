import { UIConstants } from '../../base/UIConstants'

/**
 *
 * Author: Seagazer
 * Date: 2025/12/25
 */
export class TabTitleStyle implements AttributeModifier<TextAttribute> {
    applyNormalAttribute(instance: TextAttribute): void {
        instance.fontSize(32)
            .fontWeight(FontWeight.Bold)
            .fontColor(UIConstants.DEFAULT_TEXT_COLOR)
    }
}

export const tabTitleStyle = new TabTitleStyle()