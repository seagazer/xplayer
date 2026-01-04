import { MediaFile } from './MediaFile'

export interface Album {
    title: string
    cover: string | undefined
    mediaList: MediaFile[]
}
