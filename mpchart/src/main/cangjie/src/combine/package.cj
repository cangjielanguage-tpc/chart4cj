/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package mpchart.combine

internal import mpchart.utils.*
internal import mpchart.pie.*
internal import mpchart.bar.*
internal import mpchart.line.*
internal import mpchart.scatter.*
internal import mpchart.candle.*
internal import mpchart.bubble.*
internal import mpchart.waterfall.*

internal import ohos.component.*
internal import ohos.base.*
internal import ohos.device_info.*
internal import ohos.hilog.*

internal import std.collection.*
internal import std.math.*

extend<T> Option<T> {
    operator func ()(): T {
        this.getOrThrow()
    }
}

extend <T> ArrayList<T> {
    func indexOf(element: T): Int64 {
        for (i in 0..this.size) {
            if (this[i] is T) {
                return i
            }
        }
        return -1
    }
}

public enum DrawOrder {
    | WATERFALL
    | BAR
    |BUBBLE
    |LINE
    | CANDLE
    |SCATTER
}
