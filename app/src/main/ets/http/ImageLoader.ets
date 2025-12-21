import { image } from '@kit.ImageKit';
import { XLogger } from '../extensions/XLogger';
import { util } from '@kit.ArkTS';
import { rcp } from '@kit.RemoteCommunicationKit';
import { Api } from '../api/Api';
import { MediaInfo } from './MediaInfo';

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

    constructor(context: Context) {
        this.context = context
    }

    async createDefault() {
        try {
            const resource = this.context.resourceManager.getMediaContentSync($r("app.media.cover").id)
            const imageSource = image.createImageSource(resource)
            this.default = await imageSource.createPixelMap()
        } catch (error) {

        }
    }

    async getMediaInfo(mediaTitle: string) {
        try {
            if (this.session === undefined) {
                this.session = rcp.createSession()
            }
            const response = await this.session.get(Api.QUERY_MEDIA_INFO(mediaTitle))
            XLogger.w(TAG, "-----" + response.statusCode)
            const buffer = response.body
            const decoder = new util.TextDecoder()
            const result = decoder.decodeToString(new Uint8Array(buffer))
            const info = JSON.parse(result) as MediaInfo
            XLogger.w(TAG, "-----" + new String(result))
            return info
        } catch (error) {
            XLogger.e(TAG, "----" + JSON.stringify(error))
            return undefined
        }
    }

    async getCoverImage(url: string) {
        const cache = this.pixelMapCache.get(url)
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
}