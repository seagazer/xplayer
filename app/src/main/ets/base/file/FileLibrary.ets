import { fileIo, picker } from '@kit.CoreFileKit';
import { XLogger } from '../extensions/XLogger';
import { ComponentContent, UIContext } from '@kit.ArkUI';
import { ImageLoader } from '../http/ImageLoader';
import { Api } from '../api/Api';
import { MediaFile } from './MediaFile';
import { media } from '@kit.MediaKit';


const TAG = "[FileLibrary]"


@Builder
function LoadingDialog() {
    Column({ space: 16 }) {
        LoadingProgress()
            .width(56)
            .height(56)
        Text("正在添加...")
            .fontSize(20)
    }
    .padding({
        left: 56,
        right: 56,
        top: 24,
        bottom: 24
    })
    .justifyContent(FlexAlign.Center)
    .border({ radius: 16 })
    .backgroundColor("#ffffff")
}

/**
 *
 * Author: Seagazer
 * Date: 2025/12/22
 */
export class FileLibrary {
    private readonly endFix = ["mp3", "flac", "ogg"]
    private imageLoader: ImageLoader
    private context: UIContext
    private loadingDialog?: ComponentContent<[]> = undefined

    constructor(context: UIContext) {
        this.context = context
        this.imageLoader = ImageLoader.get(context.getHostContext()!)
    }

    async select() {
        try {
            const filePicker = new picker.DocumentViewPicker()
            const result = await filePicker.select()
            XLogger.d(TAG, "select result= " + JSON.stringify(result))
            const list = await this.parseResult(result)
            return list
        } catch (e) {
            XLogger.e(TAG, "select file error= " + JSON.stringify(e))
            return undefined
        }
    }

    private async parseResult(result: string[]) {
        if (this.loadingDialog === undefined) {
            this.loadingDialog = new ComponentContent(this.context, wrapBuilder(LoadingDialog))
        }
        this.context.getPromptAction().openCustomDialog(this.loadingDialog, {
            autoCancel: false
        }).catch(() => {

        })
        const list: MediaFile[] = []
        for (let i = 0; i < result.length; i++) {
            const uri = result[i];
            if (this.isMusic(uri)) {
                const item = await this.parseMediaFile(uri)
                if (item !== undefined) {
                    list.push(item)
                }
            }
        }
        this.context.getPromptAction().closeCustomDialog(this.loadingDialog).catch(() => {
        })
        return list
    }

    private checkNull(value: string | undefined) {
        return value === undefined ? "unknown" : value
    }

    private async parseMediaFile(uri: string) {
        let fd = -1
        try {
            const avParser = await media.createAVMetadataExtractor()
            XLogger.w(TAG, "parse file= " + uri)
            const file = await fileIo.open(uri)
            fd = file.fd
            avParser.fdSrc = { fd: fd }
            const info = await avParser.fetchMetadata()
            XLogger.w(TAG, "media info= " + JSON.stringify(info))
            await avParser.release()
            let title = this.checkNull(info.title)
            let artist = this.checkNull(info.artist)
            let album = this.checkNull(info.album)
            const mediaInfo = await this.imageLoader.getMediaInfo(title)
            let coverUrl = ""
            if (mediaInfo !== undefined) {
                coverUrl = Api.QUERY_MEDIA_COVER(mediaInfo.data.song.list[0].albummid)
            }
            let duration = info.duration === undefined ? "0" : info.duration
            const item: MediaFile = {
                title: title,
                artist: artist,
                album: album,
                uri: uri,
                duration: parseInt(duration),
                coverUrl: coverUrl,
            }
            return item
        } catch (error) {
            XLogger.e(TAG, "parse media file error= " + JSON.stringify(error))
            return undefined
        } finally {
            if (fd !== -1) {
                await fileIo.close(fd)
            }
        }
    }

    private isMusic(uri: string): boolean {
        const end = uri.split(".").pop()
        if (end === undefined) {
            return false
        }
        return this.endFix.indexOf(end) >= 0
    }
}