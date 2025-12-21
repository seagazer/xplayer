import { DrawContext, NodeController, RenderNode, Size, UIContext } from '@kit.ArkUI';


const TAG = "[SeekBar]"

/**
 *
 * Author: Seagazer
 * Date: 2025/12/17
 */
export class SeekBar extends NodeController implements ISeekBar {
    private view = new SeekView()

    makeNode(uiContext: UIContext): FrameNode | null {

        return null
    }

    aboutToResize(size: Size): void {
        this.view.onMeasure(size)
    }

    onTouchEvent(event: TouchEvent): void {

    }

    setBackgroundColor(color: ResourceColor): void {
        this.view.setBackgroundColor(color)
    }

    setProgressColor(color: ResourceColor): void {
        this.view.setProgressColor(color)
    }

    setBufferColor(color: ResourceColor): void {
        this.view.setBufferColor(color)
    }

    setMax(value: number): void {
        this.view.setMax(value)
    }

    setBuffer(value: number): void {
        this.view.setBuffer(value)
    }

    setProgress(value: number): void {
        this.view.setProgress(value)
    }
}

class SeekView extends RenderNode implements ISeekBar {
    setBackgroundColor(color: ResourceColor): void {
        this.invalidate
    }

    setProgressColor(color: ResourceColor): void {
        this.invalidate
    }

    setBufferColor(color: ResourceColor): void {
        this.invalidate
    }

    setMax(value: number): void {
        this.invalidate
    }

    setBuffer(value: number): void {
        this.invalidate
    }

    setProgress(value: number): void {
        this.invalidate
    }

    onMeasure(size: Size) {

    }

    draw(context: DrawContext): void {

    }
}

export interface ISeekBar {
    setBackgroundColor(color: ResourceColor): void

    setProgressColor(color: ResourceColor): void

    setBufferColor(color: ResourceColor): void

    setMax(value: number): void

    setBuffer(value: number): void

    setProgress(value: number): void

}