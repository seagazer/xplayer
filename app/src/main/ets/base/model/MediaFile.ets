/**
 *
 * Author: Seagazer
 * Date: 2025/12/22
 */
export interface MediaFile {
    title: string,
    artist: string,
    album: string,
    uri: string,
    duration: number,
    coverUrl: string | undefined,
    collection: 0 | 1
}


export interface MediaAlbum {
    title: string,
    list: MediaFile[]
}