import { FileLibrary } from '../file/FileLibrary'
import { PlaylistVM } from '../vm/PlaylistVM'
import { AppStorageV2, ComponentContent } from '@kit.ArkUI'
import { Palette } from '../view/Palette'
import { PlayerVM } from '../vm/PlayerVM'
import { ThemeVM } from '../vm/ThemeVM'
import { SettingsVM } from '../vm/SettingsVM'
import { SettingsButtonItem, SettingsCategory, SettingsSwitchItem, SettingsTextItem } from '../view/SettingsItem'


const TAG = "[TabSettings]"

/**
 *
 * Author: Seagazer
 * Date: 2025/12/23
 */
@ComponentV2
export struct TabSettings {
    private playlist: PlaylistVM = AppStorageV2.connect<PlaylistVM>(PlaylistVM, () => new PlaylistVM())!
    private palette = new Palette()
    private player: PlayerVM = AppStorageV2.connect<PlayerVM>(PlayerVM, () => new PlayerVM())!
    private theme: ThemeVM = AppStorageV2.connect<ThemeVM>(ThemeVM, () => new ThemeVM())!
    private settings: SettingsVM = AppStorageV2.connect<SettingsVM>(SettingsVM, () => new SettingsVM())!

    build() {
        Column() {
            Text("设置")
                .fontSize(36)
                .fontWeight(FontWeight.Bold)
            Scroll() {
                Column() {
                    // storage library
                    SettingsCategory({ title: "媒体库" })
                    SettingsButtonItem({
                        title: "歌曲文件", button: "添加", onAction: () => {
                            this.test()
                        }
                    })

                    // theme
                    SettingsCategory({ title: "个性化" })
                    SettingsButtonItem({
                        title: "主题色", button: "取色", onAction: () => {
                        }
                    })
                    SettingsSwitchItem({ title: "动态主题色" })

                    // lyric
                    SettingsCategory({ title: "歌词" })
                    SettingsSwitchItem({ title: "左对齐" })
                    SettingsSwitchItem({ title: "自动下载歌词" })
                    SettingsButtonItem({
                        title: "字体大小", button: "20", onAction: () => {

                        }
                    })
                    SettingsSwitchItem({ title: "动态主题色" })
                    // about
                    SettingsCategory({ title: "关于" })
                    SettingsTextItem({ title: "当前版本", value: this.settings.appVersion })
                    SettingsButtonItem({
                        title: "激活", button: "输入激活码", onAction: () => {
                            this.openActiveDialog()
                        }
                    })

                    Blank().height(100)
                }
                .justifyContent(FlexAlign.Start)
            }
            .width("100%")
            .layoutWeight(1)
            .scrollBarColor("#33ffffff")
        }
        .width("100%")
        .height("100%")
        .alignItems(HorizontalAlign.Start)
        .padding({
            top: this.theme.statusBarHeight,
            bottom: this.theme.navigationBarHeight,
            left: 16,
            right: 16
        })
    }

    private test() {
        new FileLibrary(this.getUIContext()).select()
    }

    private openActiveDialog() {
        const param = new ActiveParam((input) => {
            if (input === "12345") {
                this.settings.appActive = true
            }
        })
        const content = new ComponentContent(this.getUIContext(), wrapBuilder(ActiveDialog), param)
        this.getUIContext().getPromptAction().openCustomDialog<ActiveParam>(content)
    }
}


@Builder
function ActiveDialog(param: ActiveParam) {
    Column() {
        TextInput()
            .onChange((input) => {
                param.input = input
            })
        Button("ok")
            .onClick(() => {
                param.onConfirm(param.input)
            })
    }
}

class ActiveParam {
    input: string = ""
    onConfirm: (input: string) => void

    constructor(onConfirm: (input: string) => void) {
        this.onConfirm = onConfirm
    }
}