/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package chart.candle

internal import chart.utils.*
internal import chart.pie.*
internal import chart.bar.*
internal import chart.line.*

internal import ohos.component.*
internal import ohos.base.*
internal import ohos.device_info.*
internal import ohos.animator.*

internal import std.collection.{ArrayList}
internal import std.math.*

extend<T> Option<T> {
    operator func ()(): T {
        this.getOrThrow()
    }
}
