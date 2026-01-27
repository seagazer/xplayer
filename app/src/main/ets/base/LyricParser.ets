import { Lrc, LrcLine, LrcWord } from '@seagazer/cclyric';
import { fileIo } from '@kit.CoreFileKit';
import { util } from '@kit.ArkTS';
import { XLogger } from './extensions/XLogger';
import { MediaFile } from './model/MediaFile';


const TAG = "[LyricParser]"

/**
 *
 * Author: Seagazer
 * Date: 2026/1/22
 */

export function getLyric(mediaFile: MediaFile) {
    const title = mediaFile.title
    const uri = mediaFile.uri
    const index = uri.lastIndexOf("/")
    XLogger.w(TAG, "uri= " + uri)
    const lyricUri = uri.substring(0, index) + "/" + title + ".lrc"
    XLogger.w(TAG, "lyric uri= " + lyricUri)
    const lyric = LyricParser.parseFile(lyricUri)
    return lyric
}

export class LyricParser {
    private constructor() {
    }

    static parseFile(filePath: string): Lrc | undefined {
        filePath = encodeURI(filePath).replace("%EF%BB%BF", "")
        let fd = -1
        try {
            const lrcFile = fileIo.openSync(filePath, fileIo.OpenMode.READ_ONLY)
            fd = lrcFile.fd
            const lrcInfo = fileIo.statSync(fd)
            const buffer = new ArrayBuffer(lrcInfo.size)
            fileIo.readSync(lrcFile.fd, buffer)
            const decoder = util.TextDecoder.create('utf-8')
            const content = decoder.decodeToString(new Uint8Array(buffer))
            const lines = content.split(/\r?\n/)
            return LyricParser.parseStringLines(lines)
        } catch (error) {
            XLogger.e(TAG, "parse file error= " + JSON.stringify(error))
        } finally {
            if (fd !== -1) {
                fileIo.closeSync(fd)
            }
        }
        return undefined
    }

    static parseStringLines(lyricLines: string[]): Lrc {
        const lyric: Lrc = {
            lyricList: []
        };
        let offset = 0; // 偏移量，默认0ms
        // 解析元数据和歌词行
        for (const line of lyricLines) {
            // 匹配元数据行（如[ar:阿桑]、[ti:一直很安静]等）
            const metaMatch = line.match(/^\[(ar|ti|al|by|offset):(.*)\]$/);
            if (metaMatch) {
                // const [, key, value] = metaMatch;
                const key = metaMatch[1]
                const value = metaMatch[2]
                switch (key) {
                    case 'ar':
                        lyric.artist = value.trim();
                        break;
                    case 'ti':
                        lyric.title = value.trim();
                        break;
                    case 'al':
                        lyric.album = value.trim();
                        break;
                    case 'by':
                        lyric.by = value.trim();
                        break;
                    case 'offset':
                        offset = parseInt(value.trim(), 10) || 0;
                        lyric.offset = offset;
                        break;
                }
                continue; // 处理完元数据，继续下一行
            }
            // 解析歌词行（带时间标签的行）
            // 分割时间标签和字符（例如[00:00.195]阿 → 分割为时间和字符）
            const parts = line.split(/\[(\d+:\d+\.\d+)\]/);
            const times: number[] = []; // 时间数组（毫秒）
            const chars: string[] = []; // 字符数组
            // 提取时间（索引1,3,5...）并转换为毫秒
            for (let i = 1; i < parts.length; i += 2) {
                const timeStr = parts[i];
                const split1 = timeStr.split(':');
                const mmStr = split1[0];
                const ssPart = split1[1];
                if (!ssPart) {
                    continue
                }
                // 无效格式跳过
                const split2 = ssPart.split('.');
                const ssStr = split2[0];
                const sssStr = split2[1];
                if (!sssStr) {
                    continue
                }
                // 无效格式跳过
                const mm = parseInt(mmStr, 10) || 0;
                const ss = parseInt(ssStr, 10) || 0;
                const sss = parseInt(sssStr, 10) || 0;
                const ms = mm * 60 * 1000 + ss * 1000 + sss;
                times.push(ms + offset); // 加上偏移量
            }
            // 提取字符（索引2,4,6...）
            for (let i = 2; i < parts.length; i += 2) {
                const char = parts[i];
                if (char) {
                    chars.push(char);
                }
            }
            // 验证格式：时间数量应为字符数量+1（每个字符对应一个开始时间，最后一个时间是结束时间）
            if (times.length !== chars.length + 1) {
                continue
            }
            // 生成逐字歌词列表
            const wordList: LrcWord[] = chars.map((text, i) => {
                const data: LrcWord = {
                    text,
                    beginTime: times[i],
                    endTime: times[i + 1]
                }
                return data
            });
            // 生成歌词行
            const lyricLine: LrcLine = {
                text: chars.join(''), // 行完整文本
                beginTime: times[0], // 行开始时间（第一个字符的开始时间）
                endTime: times[times.length - 1], // 行结束时间（最后一个字符的结束时间）
                wordList
            };
            lyric.lyricList.push(lyricLine);
        }
        return lyric;
    }
}