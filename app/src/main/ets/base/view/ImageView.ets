import { ImageLoader } from '../http/ImageLoader'

/**
 *
 * Author: Seagazer
 * Date: 2025/12/30
 */
@ComponentV2
export struct ImageView {
    @Require @Param url: string
    @Param corner: Length = 0
    @Param shadowValue?: ShadowOptions | ShadowStyle = undefined
    @Local pixel?: PixelMap | Resource = undefined

    @Monitor("url")
    onImageChanged() {
        this.loadImage()
    }

    aboutToAppear(): void {
        this.loadImage()
    }

    private loadImage() {
        ImageLoader.get(this.getUIContext().getHostContext()!).loadImage(this.url)
            .then((result) => {
                this.pixel = result
            })
    }

    build() {
        Image(this.pixel)
            .objectFit(ImageFit.Cover)
            .border({ radius: this.corner })
            .shadow(this.shadowValue)
    }
}