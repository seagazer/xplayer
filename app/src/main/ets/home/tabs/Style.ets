/**
 *
 * Author: Seagazer
 * Date: 2025/12/25
 */
export class TabTitleStyle implements AttributeModifier<TextAttribute> {
    applyNormalAttribute(instance: TextAttribute): void {
        instance.fontSize(32)
            .fontWeight(FontWeight.Bold)
            .fontColor("#ccffffff")
    }
}

export const tabTitleStyle = new TabTitleStyle()