///*
// * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
// */
package ohos_app_cangjie_entry
//internal import ohos.base.LengthProp
//internal import ohos.component.Column
//internal import ohos.component.Scroll
//internal import ohos.component.Row
//internal import ohos.component.Button
//internal import ohos.component.Text
//internal import ohos.component.CustomView
//internal import ohos.component.CJEntry
//internal import ohos.component.loadNativeView
//internal import ohos.state_manage.SubscriberManager
//internal import ohos.state_manage.ObservedProperty
//import ohos.state_macro_manage.Entry
//import ohos.state_macro_manage.Component
//import ohos.state_macro_manage.State
//import ohos.state_macro_manage.r
//import ohos.image.createPixelMap
//import ohos.image.PixelMapFormat
//import ohos.image.Size
//import ohos.image.InitializationOptions
//import ohos.image.DecodingOptions
//import ohos.image.createImageSource
//import ohos.ability.*
//import ohos.router.*
//import encoding.json.*
////import service.*
//import std.collection.*
//import ohos.base.*
//import ohos.state_macro_manage.*
//import ohos.ability.Ability
//import ohos.ability.Want
//import ohos.ability.LaunchParam
//import ohos.window.WindowStage
//import ohos.ability.AbilityStage
//import ohos.ability.LaunchReason
//import ohos.ui_test.*
//import ohos.test_runner.*
//import ohos.component.*
//import ohos.state_manage.*
//
//
//class MyTestRunner <: TestRunner {
//    public func onRun() {
//        UITest.setup()
//    }
//
//    public func onPrepare() {
//        AppLog.info("CJTestRunner onPrepare")
//    }
//
//    public func chart_click(name:String) {
//        AppLog.info("CJTestRunner onPrepare")
//        let driver:Driver = Driver.create()
//        let button: UIComponent = driver.findComponent(On().onType(name))
//        button.click()
//        driver.screenCap("/data/storage/el2/base/cache/"+name+".png")
//    }
//}
