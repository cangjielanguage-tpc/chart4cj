
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


func getnameBubble():ArrayList<String> {

        let listBubble = ArrayList<String>("L0_bubblel_bar_page",
                                        "L0_bubblel_bar_page2",
                                        "L1_bubble_chart_page",
                                        "L1_bubblel_addEntry_page",
                                        "L1_bubblel_bar_page",
                                        "L1_bubblel_bar_page1",
                                        "L1_bubblel_bar_page3",
                                        "L1_bubblel_bar_page4",
                                        "L1_bubblel_getAxis_page",
                                        "L1_bubblel_getAxis_page1",
                                        "L1_bubblel_getAxis_page2",
                                        "L1_bubblel_getAxis_page3",
                                        "L1_bubblel_getAxis_page4",
                                        "L1_bubblel_getAxis_page5",
                                        "L1_bubblel_getAxis_page6",
                                        "L1_bubblel_getAxis_page7",
                                        "L1_bubblel_getAxis_page8",
                                        "L1_bubblel_getAxis_page9",
                                        "L1_bubblel_getAxis_page10",
                                        "L1_bubblel_getAxis_page11",
                                        "L1_bubblel_getAxis_page12",
                                        "L1_bubblel_getAxis_page13",
                                        "L1_bubblel_getAxis_page14",
                                        "L1_bubblel_getAxis_page15",
                                        "L1_bubblel_getAxis_page16",
                                        "L1_bubblel_getAxis_page17",
                                        "L1_bubblel_getAxis_page18",
                                        "L1_bubblel_getAxis_page26",
                                        "L1_bubblel_getAxis_page27",
                                        "L1_bubblel_removeEntry_page",
                                        "L1_bubblel_setDrawValues_page",
                                        "L1_bubblel_setDrawValues_page1",
                                        "L1_bubblel_setKeepPositionOnRotation_page",
                                        "L1_bubblel_setLongPressCursorEnabled_page",
                                        "L1_bubblel_setLongPressCursorEnabled_page1",
                                        "L1_bubblel_setLongPressDuration_page",
                                        "L1_bubblel_setValueFormatter_page",
                                        "L1_bubblel_setValueTextColor_page",
                                        "L1_bubblel_setValueTextColors_page",
                                        "L1_bubblel_setValueTextSize_page",
                                        "L1_bubblel_setValueTypeface_page",
                                        "L1_bubblel_setVisibleXRange_page",
                                        "L1_bubblel_setVisibleYRange_page",
                                        "L2_bubblel_addEntry_page",
                                        "L2_bubblel_addEntry_page1",
                                        "L2_bubblel_bar_page",
                                        "L2_bubblel_bar_page3",
                                        "L2_bubblel_getAxis_page",
                                        "L2_bubblel_page4",
                                        "L2_bubblel_setHighlightCircleWidth_page1",
                                        "L2_bubblel_setValueTextSize_page1")
    return listBubble
}

@Entry
@Component
class index_Bubble {
    let arr2=getnameBubble()
    func build(): Unit {
            Scroll(){
            Column() {
                ForEach(this.arr2, itemGeneratorFunc: {item: String, _: Int64 =>
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
