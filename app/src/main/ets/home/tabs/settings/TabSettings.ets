import { FileLibrary } from '../../../base/file/FileLibrary'
import { MediaLibraryVM } from '../vm/MediaLibraryVM'
import { ComponentContent } from '@kit.ArkUI'
import { ThemeVM } from '../vm/ThemeVM'
import { SettingsVM } from '../vm/SettingsVM'
import { SettingsButtonItem, SettingsCategory, SettingsSwitchItem, SettingsTextItem } from './SettingsItemView'
import { tabTitleStyle } from '../Style'
import { ImageLoader } from '../../../base/http/ImageLoader'
import { PlayerVM } from '../../../player/vm/PlayerVM'
import { ActiveDialog, ActiveParam } from '../../dialog/Dialog'
import { clickStyle } from '../../../base/Styles'
import { VMProvider } from '../../../VMProvider'


const TAG = "[TabSettings]"

/**
 *
 * Author: Seagazer
 * Date: 2025/12/23
 */
@Builder
export function TabSettingsView() {
    TabSettings()
}

@ComponentV2
struct TabSettings {
    private mediaLibraryVM: MediaLibraryVM = VMProvider.get().getVM("MediaLibraryVM") as MediaLibraryVM
    private playerVM: PlayerVM = VMProvider.get().getVM("PlayerVM") as PlayerVM
    private themeVM: ThemeVM = VMProvider.get().getVM("ThemeVM") as ThemeVM
    private settingsVM: SettingsVM = VMProvider.get().getVM("SettingsVM") as SettingsVM

    build() {
        Column() {
            Text("设置")
                .attributeModifier(tabTitleStyle)

            Scroll() {
                Column() {
                    // storage library
                    SettingsCategory({ title: "媒体库" })
                        .margin({ top: 24 })
                    SettingsButtonItem({
                        title: "歌曲文件", button: "添加", onAction: () => {
                            this.test()
                        }
                    }).margin({ top: 16 })

                    // theme
                    SettingsCategory({ title: "个性化" })
                        .margin({ top: 24 })
                    SettingsButtonItem({
                        title: "主题色", button: "取色", onAction: () => {
                        }
                    }).margin({ top: 16 })

                    Row() {
                        Text("动态主题色")
                            .fontSize(16)
                            .fontColor(Color.White)
                        Toggle({ type: ToggleType.Switch, isOn: $$this.settingsVM.autoMainTheme })
                            .selectedColor(this.themeVM.primaryColor)
                            .width(50)
                            .height(24)
                            .onChange((isOn) => {
                                if (isOn) {
                                    ImageLoader.get(this.getUIContext().getHostContext()!).loadImage(this.playerVM.coverUrl)
                                        .then((result) => {
                                            this.themeVM.updateByPixelmap(result)
                                        })
                                    this.settingsVM.autoMainTheme = true
                                } else {
                                    this.themeVM.reset()
                                    this.settingsVM.autoMainTheme = false
                                }
                            })
                    }
                    .width("100%")
                    .padding({ left: 16 })
                    .justifyContent(FlexAlign.SpaceBetween)
                    .margin({ top: 16 })

                    // SettingsSwitchItem({
                    //     title: "动态主题色",
                    //     theme: this.theme,
                    //     onAction: (isOn) => {
                    //         this.settings.autoMainTheme = isOn
                    //         if (isOn) {
                    //             ImageLoader.get(this.getUIContext().getHostContext()!).loadImage(this.player.coverUrl)
                    //                 .then((result) => {
                    //                     this.theme.updateByPixelmap(result)
                    //                 })
                    //         } else {
                    //             this.theme.reset()
                    //         }
                    //     }
                    // })
                    //     .margin({ top: 16 })

                    // lyric
                    SettingsCategory({ title: "歌词" })
                        .margin({ top: 24 })
                    Row() {
                        Text("左对齐")
                            .fontSize(16)
                            .fontColor(Color.White)
                        Toggle({ type: ToggleType.Switch, isOn: $$this.settingsVM.lyricAlignLeft })
                            .selectedColor(this.themeVM.primaryColor)
                            .width(50)
                            .height(24)
                    }
                    .width("100%")
                    .padding({ left: 16 })
                    .justifyContent(FlexAlign.SpaceBetween)
                    .margin({ top: 16 })

                    SettingsSwitchItem({ title: "自动下载歌词", theme: this.themeVM, })
                        .margin({ top: 16 })
                    SettingsButtonItem({
                        title: "字体大小", button: "20", onAction: () => {

                        }
                    }).margin({ top: 16 })
                    SettingsSwitchItem({ title: "动态主题色", theme: this.themeVM, })
                        .margin({ top: 16 })
                    // about
                    SettingsCategory({ title: "关于" })
                        .margin({ top: 24 })
                    SettingsTextItem({ title: "当前版本", value: this.settingsVM.appVersion })
                        .margin({ top: 16 })

                    Row() {
                        Text("激活状态")
                            .fontSize(18)
                            .fontColor(Color.White)
                        if (!this.settingsVM.appActive) {
                            Text("激活")
                                .fontSize(18)
                                .fontColor(Color.White)
                                .textAlign(TextAlign.Center)
                                .padding({
                                    left: 16,
                                    right: 16,
                                    top: 8,
                                    bottom: 8
                                })
                                .constraintSize({ minWidth: 100 })
                                .border({ radius: 4 })
                                .backgroundColor("#80ffffff")
                                .clickEffect(clickStyle)
                                .onClick(() => {
                                    this.openActiveDialog()
                                })
                        } else {
                            Text("已激活")
                                .fontSize(18)
                                .fontColor(Color.White)
                        }
                    }
                    .width("100%")
                    .padding({ left: 16 })
                    .margin({ top: 16 })
                    .justifyContent(FlexAlign.SpaceBetween)

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
            top: this.themeVM.rootPaddingTop,
            bottom: this.themeVM.rootPaddingBottom,
            left: this.themeVM.rootPaddingLeft,
            right: this.themeVM.rootPaddingRight
        })
    }

    private async test() {
        const result = await new FileLibrary(this.getUIContext()).select()
        if (result !== undefined) {
            await this.mediaLibraryVM.add(result)
        }
    }

    private aActiveDialog?: ComponentContent<ActiveParam> = undefined

    private openActiveDialog() {
        const param = new ActiveParam((input) => {
            if (input === "12345") {
                this.settingsVM.appActive = true
                this.getUIContext().getPromptAction().closeCustomDialog(this.aActiveDialog).catch(() => {
                    // TODO: Implement error handling.
                })
            }
        })
        if (this.aActiveDialog === undefined) {
            this.aActiveDialog = new ComponentContent(this.getUIContext(), wrapBuilder(ActiveDialog), param)
        }
        this.getUIContext().getPromptAction().openCustomDialog<ActiveParam>(this.aActiveDialog).catch(() => {
            // TODO: Implement error handling.
        })
    }
}


