/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package ohos_app_cangjie_entry.linePage
//internal import ohos.base.*
//internal import ohos.component.*
//internal import ohos.state_manage.*
internal import tpc.UIKit.*

internal import ohos.ability.Ability
internal import ohos.ability.Want
internal import ohos.ability.LaunchParam
internal import ohos.window.WindowStage

internal import ohos.ability.AbilityStage
internal import ohos.ability.LaunchReason
internal import cj_res_entry.app
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
internal import chart.line.*
internal import chart.charts.*


extend<T> Option<T> {
    operator func ()(): T {
        this.getOrThrow()
    }
}
