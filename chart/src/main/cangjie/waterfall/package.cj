/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.waterfall

internal import chart.utils.*
internal import chart.bar.*
internal import chart.pie.*
internal import ohos.component.*
internal import ohos.base.*
internal import ohos.device_info.*
internal import ohos.animator.*
internal import ohos.hilog.*

internal import std.collection.{ArrayList}
internal import std.math.*
internal import std.convert.*
internal import std.sort.*
internal import std.time.DateTime

extend<T> Option<T> {
    operator func ()(): T {
        this.getOrThrow()
    }
}
