@ComponentV2
export struct SettingsCategory {
    @Require @Param title: string

    build() {
        Column() {
            Text(this.title)
                .fontSize(24)

            Line()
                .width("100%")
                .height(1)
                .margin({ top: 8 })
        }
        .width("100%")
        .alignItems(HorizontalAlign.Start)
    }
}

@ComponentV2
export struct SettingsTextItem {
    @Require @Param title: string
    @Require @Param value: string

    build() {
        Row() {
            Text(this.title)
                .fontSize(18)

            Text(this.value)
                .fontSize(18)
        }
        .width("100%")
        .justifyContent(FlexAlign.SpaceBetween)
    }
}

@ComponentV2
export struct SettingsButtonItem {
    @Require @Param title: string
    @Require @Param button: string
    @Event onAction: () => void

    build() {
        Row() {
            Text(this.title)
                .fontSize(18)

            Text(this.button)
                .textAlign(TextAlign.Center)
                .padding({
                    left: 16,
                    right: 16,
                    top: 8,
                    bottom: 8
                })
                .constraintSize({ minWidth: 100 })
                .border({ radius: 4 })
                .fontSize(18)
                .backgroundColor("#80ffffff")
                .clickEffect({ level: ClickEffectLevel.MIDDLE, scale: 0.95 })
                .onClick(() => {
                    this.onAction?.()
                })
        }
        .width("100%")
        .justifyContent(FlexAlign.SpaceBetween)
    }
}

@ComponentV2
export struct SettingsSwitchItem {
    @Require @Param title: string

    build() {
        Row() {
            Text(this.title)
                .fontSize(20)

            Toggle({ type: ToggleType.Switch })
                .width(50)
                .height(24)
        }
        .width("100%")
        .justifyContent(FlexAlign.SpaceBetween)
    }
}