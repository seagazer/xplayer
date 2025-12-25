/**
 *
 * Author: Seagazer
 * Date: 2025/12/16
 */
export interface IVM {
    onCreate(context: UIContext): Promise<void>

    onDestroy(): void
}