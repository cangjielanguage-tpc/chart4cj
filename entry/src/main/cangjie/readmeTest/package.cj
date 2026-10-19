/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package ohos_app_cangjie_entry.readmeTest

internal import ohos_app_cangjie_entry.customcomponents.*

internal import kit.UIKit.*

internal import chart.utils.*
internal import chart.charts.*
internal import chart.components.*
internal import chart.combine.*
internal import chart.pie.*
internal import chart.line.*
internal import chart.waterfall.*
internal import chart.bar.*
internal import chart.scatter.*
internal import chart.candle.*
internal import chart.bubble.*
internal import chart.radar.*

internal import std.collection.{ArrayList}
internal import std.math.*
internal import std.random.Random
internal import std.convert.Formattable
import ohos.state_macro_manage.*

extend<T> Option<T> {
    operator func ()(): T {
        this.getOrThrow()
    }
}


