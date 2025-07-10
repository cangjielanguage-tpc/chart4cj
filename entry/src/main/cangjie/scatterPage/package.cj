/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package ohos_app_cangjie_entry.scatterPage

internal import kit.UIKit.*


internal import std.collection.ArrayList
internal import std.core.Duration
internal import std.math.*
internal import std.random.Random
internal import std.convert.Formattable

internal import chart.pie.*
internal import chart.utils.*
internal import chart.charts.*
internal import chart.scatter.*
internal import chart.components.*

extend<T> Option<T> {
    operator func ()(): T {
        this.getOrThrow()
    }
}
