/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package ohos_app_cangjie_entry.readmeTest
internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*

internal import ohos.image.createPixelMap
internal import ohos.image.PixelMapFormat
internal import ohos.image.Size
internal import ohos.image.InitializationOptions
internal import ohos.image.DecodingOptions
internal import ohos.image.createImageSource
internal import ohos.ability.*
internal import ohos.resource_manager.*

internal import ohos.ability.*
internal import ohos.resource_manager.*
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
internal import std.format.*
internal import mpchart.pie.*
internal import mpchart.utils.*
internal import mpchart.components.*
internal import mpchart.bar.*
internal import mpchart.charts.*
internal import mpchart.bubble.*
internal import mpchart.waterfall.*
internal import mpchart.line.*
internal import ohos.router.*
//internal import service.*
internal import ohos.animator.*

extend<T> Option<T> {
    operator func ()(): T {
        this.getOrThrow()
    }
}
