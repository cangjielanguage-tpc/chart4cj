/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.components

internal import chart.utils.*
internal import chart.basedata.*

internal import std.collection.{ArrayList, EquatableCollection}
internal import std.format.{Formatter}
internal import std.math.*

//internal import ohos.component.*
//internal import ohos.base.*
internal import tpc.UIKit.*

extend<T> Option<T> {
    operator func ()(): T {
        this.getOrThrow()
    }
}
