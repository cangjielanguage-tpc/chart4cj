/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.bubble

internal import chart.utils.*
internal import chart.pie.*
internal import chart.bar.*

//internal import ohos.component.*
//internal import ohos.base.*
//internal import ohos.device_info.*
internal import tpc.UIKit.*
internal import ohos.animator.*

internal import std.collection.{ArrayList}
internal import std.math.*
internal import std.format.*
//import ohos.measure.*



extend<T> Option<T> {
    operator func ()(): T {
        this.getOrThrow()
    }
}
