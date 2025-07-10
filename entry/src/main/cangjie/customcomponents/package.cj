/**
 * Created on 2025/7/15
 */
package ohos_app_cangjie_entry.customcomponents

internal import chart.pie.*
internal import chart.utils.*
internal import chart.bar.*
internal import chart.line.*

internal import kit.UIKit.*

internal import std.convert.*
internal import std.math.*
import ohos.hilog.Hilog

extend<T> Option<T> {
    operator func ()(): T {
        this.getOrThrow()
    }
}
