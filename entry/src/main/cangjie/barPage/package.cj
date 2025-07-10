/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package ohos_app_cangjie_entry.barPage

internal import ohos_app_cangjie_entry.customcomponents.*

internal import kit.UIKit.*


internal import std.collection.ArrayList
internal import std.core.Duration
internal import std.math.*
internal import std.random.Random
internal import std.convert.Formattable
internal import std.convert.Parsable

internal import chart.pie.*
internal import chart.utils.*
internal import chart.components.*
internal import chart.bar.*
internal import chart.charts.*
import ohos.state_macro_manage.Builder


extend<T> Option<T> {
    operator func ()(): T {
        this.getOrThrow()
    }
}

