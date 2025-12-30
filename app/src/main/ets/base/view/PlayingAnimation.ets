/**
 *
 * Author: Seagazer
 * Date: 2025/12/30
 */
@ComponentV2
export struct PlayingAnimation {
    @Require @Param viewSize: number;
    @Require @Param themeColor: ResourceColor;
    @Local scale1: number = 0.4;
    @Local scale2: number = 0.4;
    @Local scale3: number = 0.4;
    @Local scale4: number = 0.4;
    @Local scale5: number = 0.4;

    build() {
        Row() {
            Stack()
                .chunkStyle()
                .scale({ y: this.scale1, centerY: "100%" })

            Stack()
                .chunkStyle()
                .scale({ y: this.scale2, centerY: "100%" })

            Stack()
                .chunkStyle()
                .scale({ y: this.scale3, centerY: "100%" })

            Stack()
                .chunkStyle()
                .scale({ y: this.scale4, centerY: "100%" })

            Stack()
                .chunkStyle()
                .scale({ y: this.scale5, centerY: "100%" })
        }
        .width(this.viewSize)
        .height(this.viewSize)
        .onAppear(() => {
            let keyframes1: Array<KeyframeState> = [
                {
                    duration: 300,
                    curve: Curve.EaseInOut,
                    event: () => {
                        this.scale1 = 1;
                    }
                },
                {
                    duration: 300,
                    curve: Curve.EaseInOut,
                    event: () => {
                        this.scale1 = 0.4;
                    }
                },
                {
                    duration: 900,
                    event: () => {

                    }
                }
            ];
            let keyframes2: Array<KeyframeState> = [
                {
                    duration: 300,
                    curve: Curve.EaseInOut,
                    event: () => {
                        this.scale2 = 1;
                    }
                },
                {
                    duration: 300,
                    curve: Curve.EaseInOut,
                    event: () => {
                        this.scale2 = 0.4;
                    }
                },
                {
                    duration: 900,
                    event: () => {

                    }
                }
            ];
            let keyframes3: Array<KeyframeState> = [
                {
                    duration: 300,
                    curve: Curve.EaseInOut,
                    event: () => {
                        this.scale3 = 1;
                    }
                },
                {
                    duration: 300,
                    curve: Curve.EaseInOut,
                    event: () => {
                        this.scale3 = 0.4;
                    }
                },
                {
                    duration: 900,
                    event: () => {

                    }
                }
            ];
            let keyframes4: Array<KeyframeState> = [
                {
                    duration: 300,
                    curve: Curve.EaseInOut,
                    event: () => {
                        this.scale4 = 1;
                    }
                },
                {
                    duration: 300,
                    curve: Curve.EaseInOut,
                    event: () => {
                        this.scale4 = 0.4;
                    }
                },
                {
                    duration: 900,
                    event: () => {

                    }
                }
            ];
            let keyframes5: Array<KeyframeState> = [
                {
                    duration: 300,
                    curve: Curve.EaseInOut,
                    event: () => {
                        this.scale5 = 1;
                    }
                },
                {
                    duration: 300,
                    curve: Curve.EaseInOut,
                    event: () => {
                        this.scale5 = 0.4;
                    }
                },
                {
                    duration: 900,
                    event: () => {

                    }
                }
            ];
            this.getUIContext().keyframeAnimateTo({ iterations: -1, delay: 0 }, keyframes1);
            this.getUIContext().keyframeAnimateTo({ iterations: -1, delay: -1100 }, keyframes2);
            this.getUIContext().keyframeAnimateTo({ iterations: -1, delay: -1000 }, keyframes3);
            this.getUIContext().keyframeAnimateTo({ iterations: -1, delay: -900 }, keyframes4);
            this.getUIContext().keyframeAnimateTo({ iterations: -1, delay: -800 }, keyframes5);
        })
    }

    @Styles
    chunkStyle(){
        .height('100%')
        .width('14%')
        .margin({ left: '3%', right: '3%' })
        .backgroundColor(this.themeColor)
        .shadow(ShadowStyle.OUTER_DEFAULT_XS)
    }
}