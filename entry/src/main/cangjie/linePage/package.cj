/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package ohos_app_cangjie_entry.linePage

internal import ohos_app_cangjie_entry.customcomponents.*
internal import ohos_app_cangjie_entry.utils.Util
internal import ohos_app_cangjie_entry.utils.globalAbilityContext

internal import kit.UIKit.*
internal import ohos.resource_manager.*

internal import std.collection.ArrayList
internal import std.core.Duration
internal import std.math.*
internal import std.random.Random
internal import std.convert.Formattable

internal import chart.pie.*
internal import chart.utils.*
internal import chart.components.*
internal import chart.line.*
internal import chart.charts.*



extend<T> Option<T> {
    operator func ()(): T {
        this.getOrThrow()
    }
}
