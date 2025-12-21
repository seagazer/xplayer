import { ImageLoader } from "../http/ImageLoader"
import { Palette } from "../view/Palette"
import { ThemeVM } from "../vm/ThemeVM"
import { AppStorageV2 } from "@kit.ArkUI"
import { Api } from "../api/Api"
import { FloatControllerView } from "../view/FloatControllerView"
import { PlayerVM } from "../vm/PlayerVM"
import { common } from "@kit.AbilityKit"

@ComponentV2
export struct Home {
    private theme: ThemeVM = AppStorageV2.connect<ThemeVM>(ThemeVM, () => new ThemeVM())!
    private player: PlayerVM = AppStorageV2.connect<PlayerVM>(PlayerVM, () => new PlayerVM())!
    private palette = new Palette()
    private imageDownload = new ImageLoader(this.getUIContext()!.getHostContext()!)
    private navigation = new NavPathStack()
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
    @Local gradientRadius: number = 0

    aboutToAppear(): void {
        // todo test progress
        setInterval(() => {
            this.player.progress += 300
        }, 300)
    }

    build() {
        NavDestination() {
            Column() {
                // todo tab container
                Button("Next")
                    .onClick(() => {
                        // TODO: media change
                        // this.imageDownload.getMediaInfo("one last kiss").then((info) => {
                        //     const coverUrl = Api.QUERY_MEDIA_COVER(info!.data.song.list[0].albummid)
                        // this.imageDownload.getCover(this.imageList[this.index])
                        this.imageDownload.getCoverImage(this.imageList[this.index])
                            .then((pixelmap) => {
                                if (pixelmap !== undefined) {
                                    this.player.coverImage = pixelmap
                                    this.palette.setImage(pixelmap).then(() => {
                                        const color = this.palette.getThemeColor()
                                        this.theme?.update(color[0], color[1])
                                    })
                                } else {
                                    this.player.coverImage = $r("app.media.cover")
                                    this.theme?.reset()
                                }
                            })
                        // })

                        this.index++
                        if (this.index > this.imageList.length - 1) {
                            this.index = 0
                        }
                    })

                FloatControllerView({
                    primaryColor: this.theme.primaryColor,
                    primaryColorDark: this.theme.primaryColorDark,
                    title: this.player.mediaTitle,
                    author: this.player.mediaAuthor,
                    isPlaying: this.player.isPlaying,
                    progress: this.player.progress,
                    duration: this.player.duration,
                    cover: this.player.coverImage,
                    onPlayButtonClick: () => {
                        if (this.player.isPlaying) {
                            this.player.pause()
                        } else {
                            this.player.start()
                        }
                    },
                    onContainerClick: () => {
                        this.getUIContext().animateTo({ duration: 500 }, () => {
                            this.navigation.pushPath({ name: "detail" }, false)
                        })
                    }
                })
                    .width("80%")
                    .height(80)
                    .geometryTransition("controller", { follow: true })
            }
            .height('100%')
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .padding(32)
            .radialGradient({
                center: ["50%", "50%"],
                radius: this.gradientRadius === 0 ? "100%" : this.gradientRadius,
                colors: [[this.theme!.primaryColor, 0], ["#bf000000", 1]]
            })
            .animation({ duration: 1000 })
            .onSizeChange((_, size) => {
                let w = size.width as number
                let h = size.height as number
                this.gradientRadius = Math.min(w, h)
            })
        }
        .title("home")
        .hideTitleBar(true)
        .onReady((context) => {
            this.navigation = context.pathStack
        })
        .onBackPressed(() => {
            const context = this.getUIContext().getHostContext() as common.UIAbilityContext
            context.terminateSelf().catch(() => {
            })
            return true
        })
    }
}