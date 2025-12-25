import { fileIo, picker } from '@kit.CoreFileKit';
import { XLogger } from '../extensions/XLogger';
import { PlaylistVM } from '../vm/PlaylistVM';
import { AppStorageV2, ComponentContent, UIContext } from '@kit.ArkUI';
import { ImageLoader } from '../http/ImageLoader';
import { Api } from '../api/Api';
import { MediaFile } from './MediaFile';
import { media } from '@kit.MediaKit';
import { util } from '@kit.ArkTS';
import { emitter } from '@kit.BasicServicesKit';
import { rcp } from '@kit.RemoteCommunicationKit';
import { MediaInfo } from '../api/MediaInfo';
import { image } from '@kit.ImageKit';


const TAG = "[FileLibrary]"


@Builder
function LoadingDialog() {
    Column({ space: 16 }) {
        LoadingProgress()
            .width(100)
            .height(100)
        Text("正在添加...")
            .fontSize(24)
    }
    .width(300)
    .height(200)
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
    private playlist: PlaylistVM = AppStorageV2.connect<PlaylistVM>(PlaylistVM, () => new PlaylistVM())!
    private readonly endFix = ["mp3", "flac", "ogg"]
    private imageLoader: ImageLoader
    private context: UIContext
    private loadingDialog?: ComponentContent<[]> = undefined

    constructor(context: UIContext) {
        this.context = context
        this.imageLoader = new ImageLoader(context.getHostContext()!)
    }

    async select() {
        try {
            const filePicker = new picker.DocumentViewPicker()
            const result = await filePicker.select()
            XLogger.d(TAG, "select result= " + JSON.stringify(result))
            this.parseResult(result)
        } catch (e) {
            XLogger.e(TAG, "select file error= " + JSON.stringify(e))
        }
    }

    private async parseResult(result: string[]) {
        // let uriList = result.filter((uri) => {
        //     return this.isMusic(uri)
        // })
        // taskpool.execute(parseMediaFile, [uriList])
        if (this.loadingDialog === undefined) {
            this.loadingDialog = new ComponentContent(this.context, wrapBuilder(LoadingDialog))
        }
        this.context.getPromptAction().openCustomDialog(this.loadingDialog).catch(() => {
        })
        for (let i = 0; i < result.length; i++) {
            const uri = result[i];
            if (this.isMusic(uri)) {
                XLogger.w(TAG, "select music file= " + uri);
                await this.parseMediaFile(uri)
            }
        }
        // todo add to db
        this.playlist.isEmpty = this.playlist.playlist.length <= 0;
        this.context.getPromptAction().closeCustomDialog(this.loadingDialog).catch(() => {
        })
    }

    private checkNull(value: string | undefined) {
        return value === undefined ? "unknown" : value
    }

    private async parseMediaFile(uri: string) {
        let fd = -1
        try {
            const avParser = await media.createAVMetadataExtractor()
            XLogger.w(TAG, "parse " + uri)
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
            let coverImage: PixelMap | undefined
            if (mediaInfo !== undefined) {
                coverUrl = Api.QUERY_MEDIA_COVER(mediaInfo.data.song.list[0].albummid)
                coverImage = await this.imageLoader.loadCoverImage(coverUrl)
            }
            let duration = info.duration === undefined ? "0" : info.duration
            const item: MediaFile = {
                title: title,
                artist: artist,
                album: album,
                uri: uri,
                duration: parseInt(duration),
                coverUrl: coverUrl,
                cover: coverImage
            }
            this.playlist.playlist.push(item)
        } catch (error) {
            XLogger.e(TAG, "parse media file error= " + JSON.stringify(error))
            return
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

@Concurrent
async function parseMediaFile(uriList: string[]) {
    const TAG = "[FileLibrary]"
    const result: MediaFile[] = []
    for (let i = 0; i < uriList.length; i++) {
        let uri = uriList[i]
        uri = decodeURI(uri)
        let fd = -1
        try {
            XLogger.e(TAG, "parse " + uri)
            const avParser = await media.createAVMetadataExtractor()
            const file = await fileIo.open(uri)
            XLogger.w(TAG, "parse 3333")
            fd = file.fd
            avParser.fdSrc = { fd: fd }
            const info = await avParser.fetchMetadata()
            XLogger.w(TAG, "media info= " + JSON.stringify(info))
            await avParser.release()
            XLogger.w(TAG, "parse 4444")
            let title = info.title === undefined ? "unknown" : info.title
            let artist = info.artist === undefined ? "unknown" : info.artist
            let album = info.album === undefined ? "unknown" : info.album

            const session = rcp.createSession()

            const response = await session.get(Api.QUERY_MEDIA_INFO(title))
            XLogger.w(TAG, "-----" + response.statusCode)
            const buffer = response.body
            const decoder = new util.TextDecoder()
            const httpResult = decoder.decodeToString(new Uint8Array(buffer))
            const mediaInfo = JSON.parse(httpResult) as MediaInfo
            XLogger.w(TAG, "parse 6666")
            let coverUrl = ""
            let coverImage: PixelMap | undefined
            if (mediaInfo !== undefined) {
                XLogger.w(TAG, "parse 7777")
                coverUrl = Api.QUERY_MEDIA_COVER(mediaInfo.data.song.list[0].albummid)
                let imageSource: image.ImageSource | undefined
                try {
                    const request = new rcp.Request(coverUrl, 'GET')
                    const response = await session.fetch(request)
                    const buffer = response.body
                    if (buffer !== undefined) {
                        imageSource = image.createImageSource(buffer)
                        coverImage = await imageSource.createPixelMap()
                        XLogger.w(TAG, "download success")
                    }
                } catch (error) {
                } finally {
                    if (imageSource !== undefined) {
                        await imageSource.release()
                    }
                }
                XLogger.w(TAG, "parse 8888")
            }
            let duration = info.duration === undefined ? "0" : info.duration
            const item: MediaFile = {
                title: title,
                artist: artist,
                album: album,
                uri: uri,
                duration: parseInt(duration),
                coverUrl: coverUrl,
                cover: coverImage
            }
            XLogger.w(TAG, "parse 9999= " + JSON.stringify(item))
            result.push(item)
        } catch (error) {
            let err = error as BusinessError
            XLogger.e(TAG, "parse media file error= " + JSON.stringify(err.code))
            return
        } finally {
            if (fd !== -1) {
                await fileIo.close(fd)
            }
        }
        emitter.emit("0x110", {
            data: {
                mediaFileList: result
            }
        })
    }
}