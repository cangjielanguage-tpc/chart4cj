
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

func getnamewater():ArrayList<String> {
	        let listwater = ArrayList<String>("L0_waterfall_bar_page",
                                        "L0_waterfall_bar_page3",
                                        "L1_waterfall_addEntry_page",
                                        "L1_waterfall_bar_page2",
                                        "L1_waterfall_bar_page4",
                                        "L1_waterfall_groupBars_page",
                                        "L1_waterfall_groupBars_page1",
                                        "L1_waterfall_highlightValue_page",
                                        "L1_waterfall_removeEntryByXValue_page",
                                        "L1_waterfall_setBarBorderColor_page",
                                        "L1_waterfall_setBarShadowColor_page",
                                        "L1_waterfall_setBarWidth_page",
                                        "L1_waterfall_setDotsColors_page",
                                        "L1_waterfall_setDrawBarShadow_page",
                                        "L1_waterfall_setDrawValueAboveBar_page",
                                        "L1_waterfall_setEnableMaxOrMinHighlightColor_page",
                                        "L1_waterfall_setHighLightAlpha_page",
                                        "L1_waterfall_setHighlights_page",
                                        "L1_waterfall_setOpacity_page",
                                        "L1_waterfall_setStackLabels_page",
                                        "L1_waterfall_setTopRadius_page",
                                        "L1_waterfall_setValueTextColor_page",
                                        "L1_waterfall_setValueTextColors_page",
                                        "L1_waterfall_setValueTypeface_page",
                                        "L2_waterfall_addEntry_page1",
                                        "L2_waterfall_bar_page1")
    return listwater
}


@Entry
@Component
class index_water {

    let arr4=getnamewater()
    func build(): Unit {
            Scroll(){
            Column() {
                ForEach(this.arr4, itemGeneratorFunc: {item: String, _: Int64 =>
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
