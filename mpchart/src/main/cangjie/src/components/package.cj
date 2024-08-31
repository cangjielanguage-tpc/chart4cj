/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package mpchart.components

internal import mpchart.utils.*
internal import mpchart.basedata.*
internal import std.collection.{ArrayList, EquatableCollection}
internal import std.format.{Formatter}
internal import std.math.*
internal import ohos.component.*
internal import ohos.base.*

extend<T> Option<T> {
    operator func ()(): T {
        this.getOrThrow()
    }
}
