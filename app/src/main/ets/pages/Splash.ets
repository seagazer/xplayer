@ComponentV2
export struct Splash {
    @Event onReady: () => void


    aboutToAppear(): void {
        this.onReady()
    }

    build() {

    }
}