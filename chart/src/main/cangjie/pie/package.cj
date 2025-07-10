/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.pie

internal import chart.utils.*
internal import chart.components.*
internal import chart.basedata.*
internal import std.collection.{ArrayList, HashSet, EquatableCollection, HashMap,map,collectArrayList}
internal import std.convert.Formattable
internal import std.math.*
internal import ohos.component.*
internal import ohos.base.*
internal import ohos.device_info.*
internal import ohos.animator.*
//internal import std.unicode.{UnicodeExtension}
internal import std.time.*
internal import std.convert.*
internal import std.convert.*
internal import ohos.image.*
internal import ohos.measure.Size as MeasureSize
internal import ohos.measure.MeasureOptions
internal import ohos.measure.Measure
internal import ohos.hilog.*

extend<T> Option<T> {
    operator func ()(): T {
        this.getOrThrow()
    }
}

public enum Event {
    | TouchEvent
    //TODO | GestureEvent
}
