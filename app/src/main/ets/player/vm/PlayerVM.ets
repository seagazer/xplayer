import { CcPlayer, MediaSourceFactory, PlayerState } from '@seagazer/ccplayer'
import { XLogger } from '../../base/extensions/XLogger'
import { MediaFile } from '../../base/file/MediaFile'
import { IVM } from '../../base/IVM'
import { common, wantAgent } from '@kit.AbilityKit'
import { ImageLoader } from '../../base/http/ImageLoader'
import { ThemeVM } from '../../home/tabs/settings/vm/ThemeVM'
import { SettingsVM } from '../../home/tabs/settings/vm/SettingsVM'
import { AppStorageV2 } from '@kit.ArkUI'


const TAG = "[PlayerVM]"

/**
 *
 * Author: Seagazer
 * Date: 2025/12/16
 */
@ObservedV2
export class PlayerVM implements IVM {
    @Trace isPlaying: boolean = false
    @Trace currentItem?: MediaFile = undefined
    @Trace userProgress: number = 0
    @Trace playerProgress: number = 0
    @Trace duration: number = 0
    @Trace mediaTitle: string = ""
    @Trace mediaArtist: string = ""
    @Trace showLyric: boolean = false
    @Trace coverUrl?: string = undefined
    private context?: UIContext = undefined
    private player?: CcPlayer = undefined
    private isSeeking = false
    private preparedListener = () => {
        this.duration = this.player!.getDuration()
    }
    private progressListener = (position: number) => {
        this.playerProgress = position
        if (this.isSeeking) {
            return
        }
        this.userProgress = position
    }
    private stateChangedListener = (state: PlayerState) => {
        this.isPlaying = this.player!.isPlaying()
    }
    private seekChangedListener = (position: number) => {
        this.isSeeking = false
        this.userProgress = position
        this.playerProgress = position
    }

    async onCreate(context: UIContext) {
        this.context = context
        this.player = new CcPlayer(context.getHostContext()!)
        this.player.addOnPreparedListener(this.preparedListener)
            .addOnProgressChangedListener(this.progressListener)
            .addOnStateChangedListener(this.stateChangedListener)
            .addOnSeekChangedListener(this.seekChangedListener)
        this.player.bindAvSession(context.getHostContext()!, "listen", "audio", {
            wants: [{
                bundleName: (context.getHostContext()! as common.UIAbilityContext).abilityInfo.bundleName,
                abilityName: (context.getHostContext()! as common.UIAbilityContext).abilityInfo.name
            }],
            requestCode: 0x112,
            actionType: wantAgent.OperationType.START_ABILITIES,
            wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
        })
        this.player.setBackgroundPlayEnable(true)
    }

    onDestroy(): void {
        this.player?.release()
    }

    private theme: ThemeVM = AppStorageV2.connect<ThemeVM>(ThemeVM, () => new ThemeVM())!
    private settings: SettingsVM = AppStorageV2.connect<SettingsVM>(SettingsVM, () => new SettingsVM())!

    async setSource(mediaFile: MediaFile, autoPlay: boolean = true) {
        this.mediaTitle = mediaFile.title
        this.mediaArtist = mediaFile.artist
        this.coverUrl = mediaFile.coverUrl
        this.currentItem = mediaFile
        XLogger.w(TAG, "set src= " + JSON.stringify(mediaFile))
        const mediaSource = await MediaSourceFactory.createFile(mediaFile.title, mediaFile.uri, mediaFile.coverUrl)
        this.player?.setMediaSource(mediaSource, () => {
            if (autoPlay) {
                this.start()
            }
        })
        // update theme
        XLogger.w(TAG, "auto theme= " + this.settings.autoMainTheme)
        if (this.settings.autoMainTheme) {
            let pixelmap = await ImageLoader.get(this.context!.getHostContext()!).loadImage(mediaFile.coverUrl)
            this.theme.updateByPixelmap(pixelmap)
        }
    }

    start() {
        this.player?.start()
    }

    pause() {
        this.player?.pause()
    }

    onSeekChanged(position: number, mode: SliderChangeMode) {
        if (mode === SliderChangeMode.Begin) {
            this.isSeeking = true
        } else if (mode === SliderChangeMode.End) {
            this.seekTo(position)
        }
    }

    seekTo(position: number) {
        this.player?.seekTo(position)
    }
}