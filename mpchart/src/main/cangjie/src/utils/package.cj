/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package mpchart.utils

internal import std.collection.{ArrayList}
internal import std.format.{Formatter}
internal import std.sort.*
internal import std.math.*
internal import std.convert.{Parsable}
internal import std.unicode.{UnicodeExtension}
internal import ohos.base.*
internal import ohos.component.*
internal import ohos.device_info.*
internal import ohos.image.*

extend<T> Option<T> {
    operator func ()(): T {
        this.getOrThrow()
    }
}
