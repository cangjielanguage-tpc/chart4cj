/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package chart.bar

internal import chart.utils.*
internal import chart.pie.*
internal import chart.components.*

internal import ohos.component.*
internal import ohos.base.*
internal import ohos.device_info.*
internal import ohos.animator.*

internal import std.collection.{ArrayList,HashMap}
internal import std.math.*
internal import std.format.*
internal import std.time.*


extend<T> Option<T> {
    operator func ()(): T {
        this.getOrThrow()
    }
}
