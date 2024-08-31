/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package ohos_app_cangjie_entry.waterfallPage

internal import  ohos.ability.Ability
internal import  ohos.ability.Want
internal import  ohos.ability.LaunchParam
internal import  ohos.window.WindowStage

internal import  ohos.ability.AbilityStage
internal import  ohos.ability.LaunchReason
internal import  ohos.prompt_action.*

internal import std.sync.*
internal import std.collection.*
internal import std.time.Duration
internal import std.math.*
internal import std.random.*
internal import std.convert.*
internal import std.format.*
internal import mpchart.pie.*
internal import mpchart.utils.*
internal import mpchart.charts.*
internal import mpchart.waterfall.*
internal import mpchart.components.*

extend<T> Option<T> {
    operator func ()(): T {
        this.getOrThrow()
    }
}
