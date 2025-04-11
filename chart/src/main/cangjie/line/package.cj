/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.line

internal import chart.pie.*
internal import chart.utils.*
internal import chart.bar.*

internal import std.collection.*
internal import std.math.*

//internal import ohos.component.*
//internal import ohos.base.*
//internal import ohos.device_info.*
internal import tpc.UIKit.*
internal import ohos.animator.*
internal import ohos.hilog.*

extend<T> Option<T> {
    operator func ()(): T {
        this.getOrThrow()
    }
}
