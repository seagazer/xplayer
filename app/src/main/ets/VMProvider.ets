import { SettingsVM } from './home/tabs/vm/SettingsVM'
import { ThemeVM } from './home/tabs/vm/ThemeVM'
import { AppStorageV2, PersistenceV2 } from '@kit.ArkUI'
import { MediaLibraryVM } from './home/tabs/vm/MediaLibraryVM'
import { PlayerVM } from './player/vm/PlayerVM'
import { LyricVM } from './player/vm/LyricVM'
import { IVM } from './base/IVM'


export type VM = "ThemeVM" | "SettingsVM" | "MediaLibraryVM" | "PlayerVM" | "LyricVM"

/**
 *
 * Author: Seagazer
 * Date: 2026/1/26
 */
export class VMProvider implements IVM {
    private vmMap: Map<string, IVM> = new Map()
    private declare context: UIContext
    private static sInstance = new VMProvider()

    private constructor() {
    }

    static get(): VMProvider {
        return VMProvider.sInstance
    }

    async onCreate(context: UIContext) {
        this.context = context
        this.registerVm("ThemeVM", AppStorageV2.connect<ThemeVM>(ThemeVM, () => new ThemeVM())!)
        this.registerVm("SettingsVM", PersistenceV2.connect<SettingsVM>(SettingsVM, () => new SettingsVM())!)
        this.registerVm("MediaLibraryVM", AppStorageV2.connect<MediaLibraryVM>(MediaLibraryVM, () => new MediaLibraryVM())!)
        this.registerVm("PlayerVM", AppStorageV2.connect<PlayerVM>(PlayerVM, () => new PlayerVM())!)
        this.registerVm("LyricVM", AppStorageV2.connect<LyricVM>(LyricVM, () => new LyricVM())!)
    }

    private registerVm(tag: VM, vm: IVM) {
        this.vmMap.set(tag, vm)
        vm.onCreate(this.context)
    }

    private unregisterVm(tag: VM) {
        const vm = this.vmMap.get(tag)
        if (vm !== undefined) {
            vm.onDestroy()
            this.vmMap.delete(tag)
        }
    }

    onDestroy(): void {
        this.unregisterVm("ThemeVM")
        this.unregisterVm("SettingsVM")
        this.unregisterVm("MediaLibraryVM")
        this.unregisterVm("PlayerVM")
        this.unregisterVm("LyricVM")
    }

    getVM(tag: VM): IVM | undefined {
        return this.vmMap.get(tag)
    }
}