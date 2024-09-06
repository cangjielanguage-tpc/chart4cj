/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package chart.charts

internal import ohos.ability.Ability
internal import ohos.ability.Want
internal import ohos.ability.LaunchParam
internal import ohos.window.WindowStage

internal import ohos.ability.AbilityStage
internal import ohos.ability.LaunchReason
internal import ohos.prompt_action.*

internal import std.sync.*
internal import std.collection.*
internal import std.time.Duration
internal import std.math.*
internal import std.random.*
internal import std.convert.*
internal import chart.pie.*
internal import chart.utils.*
internal import chart.components.*
internal import chart.bar.*
internal import chart.bubble.*
internal import chart.waterfall.*
internal import chart.line.*
internal import chart.candle.*
internal import chart.scatter.*
internal import chart.radar.*
internal import chart.combine.*


extend<T> Option<T> {
    operator func ()(): T {
        this.getOrThrow()
    }
}
