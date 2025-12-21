/**
 *
 * Author: Seagazer
 * Date: 2025/12/21
 */
 export class Api {
    // https://c.y.qq.com/soso/fcgi-bin/client_search_cp?format=json&w=one last kiss&n=1&p=0
    static readonly QUERY_MEDIA_INFO = (title: string) => {
        return encodeURI("https://c.y.qq.com/soso/fcgi-bin/client_search_cp?format=json&w=" + title + "&n=1&p=0")
    }
    // https://y.gtimg.cn/music/photo_new/T002R${_coverSize}x${_coverSize}M000$mid.jpg
    static readonly QUERY_MEDIA_COVER = (albumMid: string, size: number = 300) => {
        return `https://y.gtimg.cn/music/photo_new/T002R${size}x${size}M000${albumMid}.jpg`
    }
}