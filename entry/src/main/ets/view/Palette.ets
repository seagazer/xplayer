/**
 *
 * Author: Seagazer
 * Date: 2025/12/15
 */
import { effectKit } from '@kit.ArkGraphics2D'

export class Palette {
    private picker?: effectKit.ColorPicker = undefined

    async setImage(pixelMap: PixelMap) {
        this.picker = await effectKit.createColorPicker(pixelMap)
    }

    getThemeColor(): string[] {
        if (this.picker === undefined) {
            return []
        }
        try {
            const color = this.picker.getMainColorSync()
            const light = this.rgbaToHex(this.light(color.red), this.light(color.green), this.light(color.blue))
            const dark = this.rgbaToHex(this.dark(color.red), this.dark(color.green), this.dark(color.blue))
            return [light, dark]
        } catch (error) {
            return []
        }
    }

    private light(color: number) {
        if (color < 50) {
            return color * 4
        } else if (color < 100) {
            return color * 2
        } else if (color < 150) {
            return color * 1.5
        } else if (color < 200) {
            return color * 1.2
        } else {
            return color
        }
    }

    private dark(color: number) {
        if (color < 50) {
            return color
        } else if (color < 100) {
            return color
        } else if (color < 150) {
            return color * 0.8
        } else if (color < 200) {
            return color * 0.6
        } else {
            return color * 0.5
        }
    }

    private rgbaToHex(r: number, g: number, b: number): string {
        r = Math.max(0, Math.min(255, Math.round(r)))
        g = Math.max(0, Math.min(255, Math.round(g)))
        b = Math.max(0, Math.min(255, Math.round(b)))
        let hex = '#' + this.toHex(r) + this.toHex(g) + this.toHex(b)
        return hex.toUpperCase()
    }

    private toHex(value: number): string {
        const hex = value.toString(16)
        return hex.length === 1 ? '0' + hex : hex
    }
}