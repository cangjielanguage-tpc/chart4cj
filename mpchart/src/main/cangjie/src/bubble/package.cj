/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package mpchart.bubble

internal import mpchart.utils.*
internal import mpchart.pie.*
internal import mpchart.bar.*
internal import ohos.component.*
internal import ohos.base.*
internal import ohos.device_info.*
internal import ohos.animator.*

internal import std.collection.{ArrayList}
internal import std.math.*
internal import std.format.*


extend<T> Option<T> {
    operator func ()(): T {
        this.getOrThrow()
    }
}
