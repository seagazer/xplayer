import { image } from '@kit.ImageKit';
import { XLogger } from '../extensions/XLogger';
import { util } from '@kit.ArkTS';
import { rcp } from '@kit.RemoteCommunicationKit';
import { Api } from '../api/Api';
import { MediaInfo } from '../api/MediaInfo';
import { Context } from '@kit.AbilityKit';

const TAG = "[ImageLoader]"

/**
 *
 * Author: Seagazer
 * Date: 2025/12/15
 */
export class ImageLoader {
    private pixelMapCache: util.LRUCache<string, PixelMap> = new util.LRUCache(10)
    private session?: rcp.Session = undefined
    private default?: PixelMap = undefined
    private context: Context
    private cacheDir: string

    constructor(context: Context) {
        this.context = context
        this.cacheDir = context.cacheDir
    }

    async createDefault() {
        try {
            const resource = this.context.resourceManager.getMediaContentSync($r("app.media.cover").id)
            const imageSource = image.createImageSource(resource)
            this.default = await imageSource.createPixelMap()
        } catch (error) {
            XLogger.e(TAG, "load default error= " + JSON.stringify(error))
        }
    }

    async getMediaInfo(mediaTitle: string) {
        try {
            if (this.session === undefined) {
                this.session = rcp.createSession()
            }
            const response = await this.session.get(Api.QUERY_MEDIA_INFO(mediaTitle))
            const buffer = response.body
            const decoder = new util.TextDecoder()
            const result = decoder.decodeToString(new Uint8Array(buffer))
            const info = JSON.parse(result) as MediaInfo
            return info
        } catch (error) {
            XLogger.e(TAG, "request media info error= " + JSON.stringify(error))
            return undefined
        }
    }

    async loadCoverImage(url: string) {
        let cache = this.pixelMapCache.get(url)
        if (cache !== undefined) {
            return cache
        }
        cache = await this.readFromFile(url)
        if (cache !== undefined) {
            return cache
        }
        let imageSource: image.ImageSource | undefined
        try {
            if (this.session === undefined) {
                this.session = rcp.createSession()
            }
            const request = new rcp.Request(url, 'GET')
            const response = await this.session.fetch(request)
            const buffer = response.body
            if (buffer !== undefined) {
                imageSource = image.createImageSource(buffer)
                const pixelmap = await imageSource.createPixelMap()
                this.pixelMapCache.put(url, pixelmap)
                XLogger.w(TAG, "download success")
                this.cacheToFile(url, buffer)
                return pixelmap
            } else {
                if (this.default === undefined) {
                    await this.createDefault()
                }
                return this.default
            }
        } catch (error) {
            XLogger.e(TAG, "download error= " + JSON.stringify(error))
            if (this.default === undefined) {
                await this.createDefault()
            }
            return this.default
        } finally {
            if (imageSource !== undefined) {
                await imageSource.release()
            }
        }
    }

    // todo get image from local file
    private async readFromFile(url: string): Promise<PixelMap | undefined> {
        return undefined
    }

    // todo save image to local file
    private async cacheToFile(url: string, buffer: ArrayBuffer) {

    }
}