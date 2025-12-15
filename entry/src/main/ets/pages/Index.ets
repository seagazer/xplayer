import { ImageDownload } from '../http/ImageDownload';
import { XTheme } from '../theme/Theme';
import { ThemeManager } from '../theme/ThemeManager';
import { FloatControllerView } from '../view/FloatControllerView';
import { Palette } from '../view/Palette';
import { AppStorageV2 } from '@kit.ArkUI';

@Entry
@ComponentV2
struct Index {
    private imageDownload = new ImageDownload()
    private imageList: string[] = [
        "https://bkimg.cdn.bcebos.com/pic/8435e5dde71190ef76c6a446a04b8a16fdfaaf51ca50",
        "https://img2.baidu.com/it/u=956090023,2932271795&fm=253&app=138&f=JPEG?w=500&h=500",
        "https://sns-img-hw.xhscdn.com/1000g0081s5krlguf602g493161ds2k5o0vthsmo?imageView2/2/w/1080/format/webp",
        "https://sns-img-hw.xhscdn.com/1000g0081s5krlguf6020493161ds2k5odr9pks0?imageView2/2/w/1080/format/webp",
        "https://img1.baidu.com/it/u=3371320002,2522194089&fm=253&app=138&f=JPEG?w=500&h=500",
        "https://img2.baidu.com/it/u=229329335,1673444713&fm=253&app=138&f=JPEG?w=500&h=500",
        "https://c-ssl.dtstatic.com/uploads/item/201603/05/20160305191438_ZnPWN.thumb.400_0.jpeg",
        "https://image11.m1905.cn/uploadfile/2018/0726/20180726022153851996.jpg",
        "https://img.1ting.com/images/special/249/71cfd3c64faf3cd1470eacb99aa6ce00.jpg"

    ]
    private index: number = 0
    @Local cover?: PixelMap | Resource = $r("app.media.startIcon")
    private palette = new Palette()
    private theme?: XTheme = undefined
    @Local sizeLimit: number = 0
    @Local progress: number = 0

    aboutToAppear(): void {
        this.theme = AppStorageV2.connect<XTheme>(XTheme, () => new XTheme())
        setInterval(() => {
            this.progress += 1000
        }, 1000)
    }

    build() {
        Column() {

            Button("Next")
                .onClick(() => {
                    this.imageDownload.getImage(this.imageList[this.index])
                        .then((pixelmap) => {
                            if (pixelmap != undefined) {
                                this.cover = pixelmap
                                this.palette.setImage(pixelmap).then(() => {
                                    const color = this.palette.getThemeColor()
                                    ThemeManager.getInstance().update(color[0], color[1])
                                })
                            }
                        })
                    this.index++
                    if (this.index > this.imageList.length - 1) {
                        this.index = 0
                    }
                })

            FloatControllerView({
                coverImage: this.cover,
                progress: this.progress,
                duration: 100 * 1000
            })
                .width("80%")
                .height(80)
        }
        .height('100%')
        .width('100%')
        .justifyContent(FlexAlign.SpaceEvenly)
        .padding(32)
        .radialGradient({
            center: ["50%", "50%"],
            radius: this.sizeLimit === 0 ? "100%" : this.sizeLimit,
            colors: [[this.theme!.primaryColor, 0], ["#cc000000", 1]]
        })
        .animation({ duration: 1000 })
        .onSizeChange((_, size) => {
            let w = size.width as number
            let h = size.height as number
            this.sizeLimit = Math.min(w, h)
        })
    }
}