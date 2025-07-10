/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package ohos_app_cangjie_entry.scrollingCharts

internal import kit.UIKit.*

internal import std.collection.ArrayList

internal import std.math.*
internal import std.random.Random

internal import chart.pie.*
internal import chart.utils.*
internal import chart.charts.*
internal import chart.line.*
internal import chart.bar.*
internal import chart.components.*

internal import ohos_app_cangjie_entry.scrollingCharts.listViewItems.*
internal import ohos_app_cangjie_entry.scrollingCharts.viewPageItems.*
internal import ohos.hilog.*


extend<T> Option<T> {
    operator func ()(): T {
        this.getOrThrow()
    }
}
