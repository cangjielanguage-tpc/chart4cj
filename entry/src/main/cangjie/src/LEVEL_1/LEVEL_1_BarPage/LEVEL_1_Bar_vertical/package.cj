package ohos_app_cangjie_entry.LEVEL_1.LEVEL_1_BarPage.LEVEL_1_Bar_vertical
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
internal import  ohos.base.*
internal import  ohos.state_manage.*
//internal import  ohos.state_macro_manage.*
import ohos.ui_test.*
import ohos.test_runner.*
import ohos.image.*
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
internal import mpchart.pie.*
internal import mpchart.utils.*
internal import mpchart.components.*
internal import mpchart.bar.*
internal import mpchart.charts.*


extend<T> Option<T> {
    operator func ()(): T {
        this.getOrThrow()
    }
}
