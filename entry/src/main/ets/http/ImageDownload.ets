import { http } from '@kit.NetworkKit';
import { image } from '@kit.ImageKit';
import { MediaLogger } from '../extensions/MediaLogger';

const TAG = "[ImageDownload]"

/**
 *
 * Author: Seagazer
 * Date: 2025/12/15
 */
export class ImageDownload {
    private http: http.HttpRequest = http.createHttp()
    private pixelMapCache: Map<string, PixelMap> = new Map()

    async getImage(url: string) {
        const cache = this.pixelMapCache.get(url)
        if (cache !== undefined) {
            return cache
        }
        let imageSource: image.ImageSource | undefined
        try {
            const result = await this.http.request(url)
            const buffer = result.result as ArrayBuffer
            imageSource = image.createImageSource(buffer)
            const pixelmap = await imageSource.createPixelMap()
            this.pixelMapCache.set(url, pixelmap)
            MediaLogger.w(TAG, "download success")
            return pixelmap
        } catch (error) {
            MediaLogger.e(TAG, "download error= " + JSON.stringify(error))
            return undefined
        } finally {
            if (imageSource !== undefined) {
                await imageSource.release()
            }
        }
    }
}