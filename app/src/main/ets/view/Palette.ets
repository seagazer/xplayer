import { effectKit } from '@kit.ArkGraphics2D'

/**
 *
 * Author: Seagazer
 * Date: 2025/12/15
 */
export class Palette {
    private picker?: effectKit.ColorPicker = undefined
    private lightColorValue: number[] = []
    private darkColorValue: number[] = []

    async setImage(pixelMap: PixelMap) {
        this.picker = await effectKit.createColorPicker(pixelMap)
    }

    getLightValue(): number[] {
        return this.lightColorValue
    }

    getDarkValue(): number[] {
        return this.darkColorValue
    }

    getThemeColor(): string[] {
        if (this.picker === undefined) {
            return []
        }
        try {
            const color = this.picker.getMainColorSync()
            this.lightColorValue = [this.light(color.red), this.light(color.green), this.light(color.blue)]
            const light = Palette.rgbaToHex(this.lightColorValue[0], this.lightColorValue[1], this.lightColorValue[2])
            this.darkColorValue = [this.dark(color.red), this.dark(color.green), this.dark(color.blue)]
            const dark = Palette.rgbaToHex(this.darkColorValue[0], this.darkColorValue[1], this.darkColorValue[2])
            return [light, dark]
        } catch (error) {
            return []
        }
    }

    private light(color: number) {
        if (color <= 0) {
            return 200
        } else if (color < 50) {
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
        if (color < 100) {
            return color
        } else if (color < 150) {
            return color * 0.8
        } else if (color < 200) {
            return color * 0.6
        } else {
            return color * 0.4
        }
    }

    static rgbaToHex(r: number, g: number, b: number): string {
        r = Math.max(0, Math.min(255, Math.round(r)))
        g = Math.max(0, Math.min(255, Math.round(g)))
        b = Math.max(0, Math.min(255, Math.round(b)))
        let hex = '#' + Palette.fillHex(r) + Palette.fillHex(g) + Palette.fillHex(b)
        return hex.toUpperCase()
    }

    static fillHex(value: number): string {
        const hex = value.toString(16)
        return hex.length === 1 ? '0' + hex : hex
    }

    static stringToHex(hexColor: string): number {
        let color: string = hexColor.startsWith('#') ? hexColor.substring(1) : hexColor;
        if (color.length === 6) {
            color = 'ff' + color;
        }
        return parseInt(color, 16);
    }
}