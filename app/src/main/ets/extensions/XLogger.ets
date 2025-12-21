import hilog from '@ohos.hilog';

const domain = 0x176

/**
 * The logger to print app log.
 *
 * Author: Seagazer
 * Date: 2024/9/18
 */
export class XLogger {
    private static DEBUG = true
    private static FILTER_NAME = "XPlayer: "

    static setDebugger(debug: boolean) {
        XLogger.DEBUG = debug
    }

    static isDebug(): boolean {
        return XLogger.DEBUG
    }

    static setFilterName(name: string) {
        XLogger.FILTER_NAME = name
    }

    static attentionW(tag: string, message: string) {
        hilog.warn(domain, XLogger.FILTER_NAME, tag + " " + message)
    }

    static attentionE(tag: string, message: string) {
        hilog.error(domain, XLogger.FILTER_NAME, tag + " " + message)
    }

    static d(tag: string, message: string) {
        if (!XLogger.DEBUG) {
            return
        }
        hilog.debug(domain, XLogger.FILTER_NAME, tag + " " + message)
    }

    static w(tag: string, message: string) {
        if (!XLogger.DEBUG) {
            return
        }
        hilog.warn(domain, XLogger.FILTER_NAME, tag + " " + message)
    }

    static i(tag: string, message: string) {
        if (!XLogger.DEBUG) {
            return
        }
        hilog.info(domain, XLogger.FILTER_NAME, tag + " " + message)
    }

    static e(tag: string, message: string) {
        if (!XLogger.DEBUG) {
            return
        }
        hilog.error(domain, XLogger.FILTER_NAME, tag + " " + message)
    }

    static f(tag: string, message: string) {
        if (!XLogger.DEBUG) {
            return
        }
        hilog.fatal(domain, XLogger.FILTER_NAME, tag + " " + message)
    }
}