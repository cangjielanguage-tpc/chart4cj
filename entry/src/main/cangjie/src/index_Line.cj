
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
//import service.*
import std.collection.*
import ohos.base.*
import ohos.state_macro_manage.*
import ohos.ability.Ability
import ohos.ability.Want
import ohos.ability.LaunchParam
import ohos.window.WindowStage
import ohos.ability.AbilityStage
import ohos.ability.LaunchReason
import ohos.ui_test.*
import ohos.test_runner.*
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos.base.*
import ohos.component.*
import ohos.state_macro_manage.*
import std.collection.*
import ohos.base.*
import ohos.component.*
import ohos.state_macro_manage.*
import std.collection.*


func getnameLine():ArrayList<String> {

      let listLine = ArrayList<String>("L0_Line_EntryOhos",
                                        "L0_Line_EntryOhos1",
                                        "L1_Line_animateXY",
                                        "L1_Line_enableDashedLine",
                                        "L1_Line_EntryOhos2",
                                        "L1_Line_page",
                                        "L1_Line_page1",
                                        "L1_Line_setCircleColor",
                                        "L1_Line_setCircleColors",
                                        "L1_Line_setCircleHoleColor",
                                        "L1_Line_setCircleHoleRadius",
                                        "L1_Line_setCircleRadius",
                                        "L1_Line_setCubicIntensity",
                                        "L1_Line_setDrawFilled",
                                        "L1_Line_setDrawFilled1",
                                        "L1_Line_setFillAlpha",
                                        "L1_Line_setFillColor",
                                        "L1_Line_setGradientFillColor",
                                        "L1_Line_setMode",
                                        "L1_Line_setMode1",
                                        "L2_Line_EntryOhos",
                                        "L2_Line_EntryOhos1",
                                        "L2_Line_setCircleColors",
                                        "L2_Line_setCircleHoleRadius",
                                        "L2_Line_setCircleRadius",
                                        "L2_Line_setFillAlpha")
        return  listLine
    }

@Entry
@Component
class index_Line {

    let arr3=getnameLine()
    func build(): Unit {
            Scroll(){
            Column() {
                ForEach(this.arr3, itemGeneratorFunc: {item: String, _: Int64 =>
                   Button(item)
                  .height(40)
                  .margin(top: 5, bottom: 5)
                  .fontSize(16)
                   .shape(ShapeType.Capsule)
                   .onClick {Router.push(url: item)}
                })
            }.width(100.percent)
        }
    }
}
