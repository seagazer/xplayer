import { cryptoFramework } from '@kit.CryptoArchitectureKit';

export function duration2Text(duration: number): string {
    const totalSeconds = Math.floor(duration / 1000);
    const minutes = Math.floor(totalSeconds / 60);
    const seconds = totalSeconds % 60;
    const minutesStr = minutes.toString().padStart(2, '0');
    const secondsStr = seconds.toString().padStart(2, '0');
    return `${minutesStr}:${secondsStr}`;
}

export async function Md5(value: string) {
    try {
        const inputArray = new Uint8Array(value.length);
        for (let i = 0; i < value.length; i++) {
            inputArray[i] = value.charCodeAt(i)
        }
        const md5 = cryptoFramework.createMd('MD5')
        await md5.update({ data: inputArray })
        const mdOutput = await md5.digest();
        const hashArray = Array.from(new Uint8Array(mdOutput.data))
        const hashHex = hashArray.map(b => b.toString(16).padStart(2, '0')).join('')
        return hashHex
    } catch (error) {
        return undefined
    }
}

export function stringToHex(hexColor: string): number {
    let color: string = hexColor.startsWith('#') ? hexColor.substring(1) : hexColor;
    if (color.length === 6) {
        color = 'ff' + color;
    }
    return parseInt(color, 16);
}

export function animate(context: UIContext, action: () => void, duration: number, async: boolean) {
    if (async) {
        setTimeout(() => {
            context.animateTo({ duration: duration }, () => {
                action()
            })
        }, 0)
    } else {
        context.animateTo({ duration: duration }, () => {
            action()
        })
    }
}