/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.combine

internal import chart.utils.*
internal import chart.pie.*
internal import chart.bar.*
internal import chart.line.*
internal import chart.scatter.*
internal import chart.candle.*
internal import chart.bubble.*
internal import chart.waterfall.*

//internal import ohos.component.*
//internal import ohos.base.*
//internal import ohos.device_info.*
internal import tpc.UIKit.*
internal import ohos.hilog.*

internal import std.collection.{ArrayList}
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
