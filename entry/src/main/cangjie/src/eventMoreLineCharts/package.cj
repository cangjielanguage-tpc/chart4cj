/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package ohos_app_cangjie_entry.eventMoreLineCharts

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*


internal import ohos.ability.Ability
internal import ohos.ability.Want
internal import ohos.ability.LaunchParam
internal import ohos.window.WindowStage

internal import ohos.ability.AbilityStage
internal import ohos.ability.LaunchReason
internal import ohos.hilog.*

internal import std.sync.*
internal import std.collection.*
internal import std.time.Duration
internal import std.math.*
internal import std.random.*
internal import std.convert.*
internal import std.format.*
internal import std.time.*
internal import chart.pie.*
internal import chart.utils.*
internal import chart.components.*
internal import chart.bar.*
internal import chart.charts.*
internal import chart.line.*


extend<T> Option<T> {
    operator func ()(): T {
        this.getOrThrow()
    }
}
