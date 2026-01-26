/**
 *
 * Author: Seagazer
 * Date: 2026/1/26
 */
@Builder
export function ActiveDialog(param: ActiveParam) {
    Column({ space: 16 }) {
        TextInput()
            .type(InputType.Number)
            .border({ width: 1 })
            .onChange((input) => {
                param.input = input
            })
        Button("确认")
            .onClick(() => {
                param.onConfirm(param.input)
            })
    }
    .width(300)
    .height(200)
    .backgroundColor(Color.White)
    .border({ radius: 16 })
    .justifyContent(FlexAlign.Center)
}

export class ActiveParam {
    input: string = ""
    onConfirm: (input: string) => void

    constructor(onConfirm: (input: string) => void) {
        this.onConfirm = onConfirm
    }
}