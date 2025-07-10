/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package ohos_app_cangjie_entry.bubblePage

internal import kit.UIKit.*


internal import std.collection.*
internal import std.core.Duration
internal import std.math.*
internal import std.random.Random
internal import std.convert.Formattable

internal import chart.pie.*
internal import chart.utils.*
internal import chart.charts.*
internal import chart.bubble.*
internal import chart.components.*

extend<T> Option<T> {
    operator func ()(): T {
        this.getOrThrow()
    }
}
