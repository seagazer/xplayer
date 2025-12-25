import { TabAlbumView } from './tabs/album/TabAlbum'
import { TabCollectionView } from './tabs/collection/TabCollection'
import { TabLibraryView } from './tabs/library/TabLibrary'
import { TabPlaylistView } from './tabs/playlist/TabPlaylist'
import { TabSettingsView } from './tabs/settings/TabSettings'

/**
 *
 * Author: Seagazer
 * Date: 2025/12/25
 */
export const TabConfig: TabItem[] = [
    {
        index: 0,
        icon: $r("sys.symbol.music"),
        title: "音乐",
        tabView: wrapBuilder(TabLibraryView)
    },
    {
        index: 1,
        icon: $r("sys.symbol.record_circle"),
        title: "专辑",
        tabView: wrapBuilder(TabAlbumView)
    },
    {
        index: 2,
        icon: $r("sys.symbol.heart"),
        title: "收藏",
        tabView: wrapBuilder(TabCollectionView)
    },
    {
        index: 3,
        icon: $r("sys.symbol.music_note_list"),
        title: "播放列表",
        tabView: wrapBuilder(TabPlaylistView)
    },
    {
        index: 4,
        icon: $r("sys.symbol.gearshape"),
        title: "设置",
        tabView: wrapBuilder(TabSettingsView)
    },
]


export interface TabItem {
    index: number
    icon: Resource
    title: ResourceStr
    tabView: WrappedBuilder<[]>
}