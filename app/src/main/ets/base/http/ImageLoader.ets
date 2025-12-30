import { image } from '@kit.ImageKit';
import { XLogger } from '../extensions/XLogger';
import { util } from '@kit.ArkTS';
import { rcp } from '@kit.RemoteCommunicationKit';
import { Md5 } from '../extensions/Extensions';
import { Api } from '../api/Api';
import { MediaInfo } from '../api/MediaInfo';
import { Context } from '@kit.AbilityKit';
import { fileIo } from '@kit.CoreFileKit';

const TAG = "[ImageLoader]"

/**
 *
 * Author: Seagazer
 * Date: 2025/12/15
 */
export class ImageLoader {
    private pixelMapCache: util.LRUCache<string, PixelMap> = new util.LRUCache(30)
    private session?: rcp.Session = undefined
    private default?: PixelMap = undefined
    private context: Context
    private cacheDir: string
    private static sInstance?: ImageLoader = undefined

    private constructor(context: Context) {
        this.context = context
        this.cacheDir = context.cacheDir
        this.createDefault()
    }

    static get(context: Context): ImageLoader {
        if (ImageLoader.sInstance === undefined) {
            ImageLoader.sInstance = new ImageLoader(context)
        }
        return ImageLoader.sInstance
    }

    async createDefault() {
        try {
            const resource = this.context.resourceManager.getMediaContentSync($r("app.media.cover").id)
            const imageSource = image.createImageSource(resource.buffer)
            this.default = await imageSource.createPixelMap()
        } catch (error) {
            XLogger.e(TAG, "load default error= " + JSON.stringify(error))
        }
    }

    async getMediaInfo(mediaTitle: string): Promise<MediaInfo | undefined> {
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

    async loadImage(url: string | undefined) {
        if (url === undefined) {
            if (this.default === undefined) {
                await this.createDefault()
            }
            return this.default
        }
        XLogger.i(TAG, "load image= " + url)
        let cache = this.pixelMapCache.get(url)
        if (cache !== undefined) {
            XLogger.d(TAG, "get image from memory")
            return cache
        }
        cache = await this.loadFromFile(url)
        if (cache !== undefined) {
            XLogger.d(TAG, "get image from file")
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
                XLogger.d(TAG, "download success")
                this.cacheToMemory(url, pixelmap)
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

    // load image from local file
    private async loadFromFile(url: string): Promise<PixelMap | undefined> {
        const md5 = await Md5(url)
        if (md5 === undefined) {
            return undefined
        }
        let source: image.ImageSource | undefined = undefined
        try {
            const filePath = this.cacheDir + "/" + md5
            source = image.createImageSource(filePath)
            const result = await source.createPixelMap()
            XLogger.d(TAG, "load image from file success= " + md5)
            this.cacheToMemory(url, result)
            return result
        } catch (error) {
            XLogger.e(TAG, "load image from file error= " + JSON.stringify(error))
            return undefined
        } finally {
            if (source !== undefined) {
                await source.release()
            }
        }
    }

    private currentMemory: number = 0

    private cacheToMemory(url: string, pixelmap: PixelMap) {
        const size = pixelmap.getPixelBytesNumber()
        XLogger.w(TAG, "------" + size)
        this.pixelMapCache.put(url, pixelmap)
        this.currentMemory += size
        if (this.currentMemory > 100 * 1024 * 1024) {
            // todo 根据内存管控缓存
        }
    }

    // save image to local file
    private async cacheToFile(url: string, buffer: ArrayBuffer) {
        const md5 = await Md5(url)
        if (md5 === undefined) {
            return
        }
        let fd = -1
        try {
            XLogger.d(TAG, "save image to file= " + md5)
            const file = await fileIo.open(this.cacheDir + "/" + md5, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE)
            fd = file.fd
            await fileIo.write(fd, buffer)
            XLogger.d(TAG, "save image to file success= " + md5)
        } catch (error) {
            XLogger.e(TAG, "cache image error= " + JSON.stringify(error))
        } finally {
            if (fd != -1) {
                fileIo.closeSync(fd)
            }
        }
    }

    async release(url: string) {
        const pixelmap = this.pixelMapCache.get(url)
        if (pixelmap !== undefined) {
            await pixelmap.release()
            this.pixelMapCache.remove(url)
        }
    }
}