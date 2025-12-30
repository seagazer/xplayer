import { DrawContext, FrameNode, NodeController, RenderNode, Size, UIContext } from '@kit.ArkUI'
import { drawing } from '@kit.ArkGraphics2D'

/**
 *
 * Author: Seagazer
 * Date: 2025/12/30
 */
export class ColorWheelSelector extends NodeController {
    private root: FrameNode | null = null
    private view: ColorWheelView | null = null
    private strokeWidth: number = 0
    private radius: number = 0
    private color = -1
    private onColorSelected: (color: string) => void = () => {
    }

    setSelectorCallback(callback: (color: string) => void) {
        this.onColorSelected = callback
    }

    setSelectorSize(strokeWidth: number, radius: number) {
        this.strokeWidth = strokeWidth
        this.radius = radius
        this.view?.setSelectorSize(strokeWidth, radius)
    }

    setSelectorColor(color: number) {
        this.color = color
        this.view?.setSelectorColor(color)
    }

    makeNode(uiContext: UIContext): FrameNode | null {
        if (this.root === null) {
            this.root = new FrameNode(uiContext)
            this.view = new ColorWheelView(uiContext, this.onColorSelected)
        }
        return this.root
    }

    aboutToResize(size: Size): void {
        if (size.width !== size.height) {
            throw new Error("The width is not the same as height of this view!")
        }
        const radius = size.width / 2
        this.root!.commonAttribute
            .border({ radius: radius })
            .sweepGradient({
                center: [radius, radius],
                start: 0,
                end: 360,
                rotation: 0,
                repeating: true,
                colors: [[0xff0000, 0.0], [0xFC27D9, 0.166], [0x0000ff, 0.332],
                    [0x0AE4E3, 0.5], [0x00ff00, 0.664], [0xffff00, 0.831], [0xff0000, 1]]
            })
        this.view!.onSizeChanged(size.width)
        if (this.strokeWidth !== 0 && this.radius !== 0) {
            this.view!.setSelectorSize(this.strokeWidth, this.radius)
        }
        if (this.color !== -1) {
            this.view!.setSelectorColor(this.color)
        }
        this.root!.getRenderNode()?.appendChild(this.view)
    }

    onTouchEvent(event: TouchEvent): void {
        this.view?.onTouch(event)
    }
}

export class ColorWheelView extends RenderNode {
    private brush = new drawing.Brush()
    private pen = new drawing.Pen()
    radius: number = 0
    selectorRadius: number = 8
    selectorBorderWidth = 2
    selectorBorderColor = 0xff000000
    touchX = 0
    touchY = 0
    onColorSelected: (color: string) => void
    private context: UIContext

    constructor(context: UIContext, callback: (color: string) => void) {
        super()
        this.context = context
        this.onColorSelected = callback
        this.pen.setStrokeWidth(this.selectorBorderWidth)
        this.pen.setColor(this.selectorBorderColor)
    }

    setSelectorSize(strokeWidth: number, radius: number) {
        this.selectorBorderWidth = this.context.vp2px(strokeWidth)
        this.selectorRadius = this.context.vp2px(radius)
        this.pen.setStrokeWidth(this.selectorBorderWidth)
        this.invalidate()
    }

    setSelectorColor(color: number) {
        this.selectorBorderColor = color
        this.pen.setColor(this.selectorBorderColor)
        this.invalidate()
    }

    onSizeChanged(size: number) {
        this.frame = {
            x: 0,
            y: 0,
            width: size,
            height: size
        }
        this.touchX = this.context.vp2px(size / 2)
        this.touchY = this.context.vp2px(size / 2)
        this.radius = this.context.vp2px(size / 2)
    }

    draw(context: DrawContext): void {
        const canvas = context.canvas
        this.drawColorWheel(canvas)
        this.drawSelector(canvas)
    }

    onTouch(ev: TouchEvent) {
        let touch = ev.touches[0]
        switch (touch.type) {
            case TouchType.Down:
            case TouchType.Move:
                this.touchX = this.context.vp2px(touch.x)
                this.touchY = this.context.vp2px(touch.y)
                this.invalidate()
                break
        }
    }

    private drawColorWheel(canvas: drawing.Canvas) {
        const effect =
            drawing.ShaderEffect.createRadialGradient({ x: this.radius, y: this.radius }, this.radius, [0xffe3e3e3, 0x80ffffff, 0x00ffffff],
                drawing.TileMode.CLAMP)
        this.brush.setShaderEffect(effect)
        canvas.attachBrush(this.brush)
        canvas.drawCircle(this.radius, this.radius, this.radius)
        canvas.detachBrush()
    }

    private drawSelector(ctx: drawing.Canvas) {
        ctx.attachPen(this.pen)
        // draw selector
        let dx = Math.abs(this.touchX - this.radius)
        let dy = Math.abs(this.touchY - this.radius)
        let touchR = Math.sqrt(dx * dx + dy * dy)
        let drawR = this.radius - this.selectorRadius
        if (touchR > drawR) {
            // draw edge
            let radians = Math.asin(dy / touchR)
            if (this.touchX >= this.radius && this.touchY < this.radius) { //右上象限
                this.touchX = this.radius + Math.cos(radians) * drawR
                this.touchY = this.radius - Math.sin(radians) * drawR
            } else if (this.touchX >= this.radius && this.touchY >= this.radius) { //右下象限
                this.touchX = this.radius + Math.cos(radians) * drawR
                this.touchY = this.radius + Math.sin(radians) * drawR
            } else if (this.touchX < this.radius && this.touchY >= this.radius) { //左下象限
                this.touchX = this.radius - Math.cos(radians) * drawR
                this.touchY = this.radius + Math.sin(radians) * drawR
            } else if (this.touchX < this.radius && this.touchY <= this.radius) { //左上象限
                this.touchX = this.radius - Math.cos(radians) * drawR
                this.touchY = this.radius - Math.sin(radians) * drawR
            }
        }
        ctx.drawCircle(this.touchX, this.touchY, this.selectorRadius)
        // calculate the hsv value
        let r = this.radius
        let hsv = new Array<number>()
        hsv[0] = Math.atan2((this.touchY - r), -(this.touchX - r)) / Math.PI * 180 + 180
        hsv[1] = Math.max(0, Math.min(1, touchR / r))
        hsv[2] = 1
        let selectedColor = this.hsv2rgb(hsv[0], hsv[1], hsv[2])
        this.onColorSelected(selectedColor)
        ctx.detachPen()
    }

    private hsv2rgb(h: number, s: number, v: number) {
        let i: number, f: number, p1: number, p2: number, p3: number
        let r = 0, g = 0, b = 0
        if (s < 0) {
            s = 0
        }
        if (s > 1) {
            s = 1
        }
        if (v < 0) {
            v = 0
        }
        if (v > 1) {
            v = 1
        }
        h %= 360
        if (h < 0) {
            h += 360
        }
        h /= 60
        i = Math.floor(h)
        f = h - i
        p1 = v * (1 - s)
        p2 = v * (1 - s * f)
        p3 = v * (1 - s * (1 - f))
        switch (i) {
            case 0:
                r = v
                g = p3
                b = p1
                break
            case 1:
                r = p2
                g = v
                b = p1
                break
            case 2:
                r = p1
                g = v
                b = p3
                break
            case 3:
                r = p1
                g = p2
                b = v
                break
            case 4:
                r = p3
                g = p1
                b = v
                break
            case 5:
                r = v
                g = p1
                b = p2
                break
        }
        let r1 = Math.round(r * 255)
        let g1 = Math.round(g * 255)
        let b1 = Math.round(b * 255)
        return "#" + ((1 << 24) + (r1 << 16) + (g1 << 8) + b1).toString(16).slice(1)
    }
}
