/**
 *
 * Author: Seagazer
 * Date: 2025/12/25
 */
export class TabTitleStyle implements AttributeModifier<TextAttribute> {
    applyNormalAttribute(instance: TextAttribute): void {
        instance.fontSize(36)
            .fontWeight(FontWeight.Bold)
    }
}

export const tabTitleStyle = new TabTitleStyle()