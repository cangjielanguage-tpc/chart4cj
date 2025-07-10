/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package ohos_app_cangjie_entry.waterfallPage

internal import kit.UIKit.*

internal import std.collection.ArrayList
internal import std.convert.Formattable

internal import chart.pie.*
internal import chart.utils.*
internal import chart.charts.*
internal import chart.waterfall.*
internal import chart.components.*

extend<T> Option<T> {
    operator func ()(): T {
        this.getOrThrow()
    }
}
