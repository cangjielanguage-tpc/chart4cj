/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package mpchart.line

internal import mpchart.pie.*
internal import mpchart.utils.*
internal import mpchart.bar.*
internal import std.collection.*
internal import std.math.*
internal import ohos.component.*
internal import ohos.base.*
internal import ohos.device_info.*
internal import ohos.animator.*

extend<T> Option<T> {
    operator func ()(): T {
        this.getOrThrow()
    }
}
