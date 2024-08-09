/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package ohos_app_cangjie_entry

import ohos.state_macro_manage.*
internal import ohos.base.LengthProp
internal import ohos.component.Column
internal import ohos.component.Scroll
internal import ohos.component.Row
internal import ohos.component.Button
internal import ohos.component.Text
internal import ohos.component.CustomView
internal import ohos.component.CJEntry
internal import ohos.component.loadNativeView
internal import ohos.state_manage.SubscriberManager
internal import ohos.state_manage.ObservedProperty
import ohos.state_macro_manage.Entry
import ohos.state_macro_manage.Component
import ohos.state_macro_manage.State
import ohos.state_macro_manage.r
import ohos.image.createPixelMap
import ohos.image.PixelMapFormat
import ohos.image.Size
import ohos.image.InitializationOptions
import ohos.image.DecodingOptions
import ohos.image.createImageSource
import ohos.ability.*
import ohos.router.*
import encoding.json.*
import std.collection.*
import ohos.base.*
import ohos.state_macro_manage.*
import ohos.ability.Ability
import ohos.ability.Want
import ohos.ability.LaunchParam
import ohos.window.WindowStage
import ohos.ability.AbilityStage
import ohos.ability.LaunchReason

@Entry
@Component
class MyView {
    func build() {
        Column {
            Button("PieChartPage").onClick {
                Router.push(url: "PieChartPage")
            }

            Button("SimpleWaterfallChartPage").onClick {
                Router.push(url: "SimpleWaterfallChartPage")
            }

            Button("IconPieChartPage").onClick {
                Router.push(url: "IconPieChartPage")
            }



        }
    }
}
