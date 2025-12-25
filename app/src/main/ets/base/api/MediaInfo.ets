/**
 *
 * Author: Seagazer
 * Date: 2025/12/17
 */
export interface MediaInfo {
    code: number
    data: MediaData
    message: string
    notice: string
    subcode: number
    time: number
    tips: string
}

export interface Singer {
    id: number
    mid: string
    name: string
    name_hilight: string
}

export interface Pay {
    payalbum: number
    payalbumprice: number
    paydownload: number
    payinfo: number
    payplay: number
    paytrackmouth: number
    paytrackprice: number
}

export interface Preview {
    trybegin: number
    tryend: number
    trysize: number
}

export interface SongItem {
    albumid: number
    albummid: string
    albumname: string
    albumname_hilight: string
    alertid: number
    belongCD: number
    cdIdx: number
    chinesesinger: number
    docid: string
    grp: Array<Object>
    interval: number
    isonly: number
    lyric: string
    lyric_hilight: string
    media_mid: string
    msgid: number
    newStatus: number
    nt: number
    pay: Pay
    preview: Preview
    pubtime: number
    pure: number
    singer: Array<Singer>
    size128: number
    size320: number
    sizeape: number
    sizeflac: number
    sizeogg: number
    songid: number
    songmid: string
    songname: string
    songname_hilight: string
    strMediaMid: string
    stream: number
    switch: number
    t: number
    tag: number
    type: number
    ver: number
    vid: string
}

export interface Song {
    curnum: number
    curpage: number
    list: Array<SongItem>
    totalnum: number
}

export interface Semantic {
    curnum: number
    curpage: number
    list: Array<Object>
    totalnum: number
}

export interface Zhida {
    chinesesinger: number
    type: number
}

export interface MediaData {
    keyword: string
    priority: number
    qc: Array<Object>
    semantic: Semantic
    song: Song
    tab: number
    taglist: Array<Object>
    totaltime: number
    zhida: Zhida
}

