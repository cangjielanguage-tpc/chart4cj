
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

func getnamepie():ArrayList<String> {
	        let listpie = ArrayList<String>("L0_piechart",
                            "L0_piechart1",
                            "L1_pieCenter1",
                            "L1_pieCenter2",
                            "L1_pieCenterColor",
                            "L1_pieCenterText1",
                            "L1_pieCenterText2",
                            "L1_pieCenterText3",
                            "L1_pieCenterText4",
                            "L1_pieCenterText5",
                            "L1_pieCenterTextRadiusPercent",
                            "L1_piechart",
                            "L1_piechart1",
                            "L1_piechart2",
                            "L1_piechart3",
                            "L1_piechart4",
                            "L1_piechart5",
                            "L1_piechart6",
                            "L1_pieChartPage1",
                            "L1_pieclear1",
                            "L1_pieclear2",
                            "L1_pieColorsByVariable1",
                            "L1_pieColorsByVariable2",
                            "L1_pieColorsByVariable3",
                            "L1_pieColorsByVariable4",
                            "L1_pieColorsByVariable5",
                            "L1_pieColorsByVariable6",
                            "L1_pieColorsByVariable7",
                            "L1_pieColorsByVariable8",
                            "L1_pieColorsByVariable9",
                            "L1_pieColorsByVariable10",
                            "L1_pieColorsByVariable11",
                            "L1_pieDescription",
                            "L1_pieDragDecelerationEnabled1",
                            "L1_pieDragDecelerationEnabled2",
                            "L1_pieDragDecelerationEnabled3",
                            "L1_pieDrawEntryLabels1",
                            "L1_pieDrawEntryLabels2",
                            "L1_pieDrawEntryLabels3",
                            "L1_pieDrawEntryLabels4",
                            "L1_pieDrawIcons",
                            "L1_pieDrawRoundedSlices",
                            "L1_pieDrawVaule1",
                            "L1_pieDrawVaule2",
                            "L1_pieExtraOffsets1",
                            "L1_pieExtraOffsets2",
                            "L1_pieExtraOffsets3",
                            "L1_pieExtraOffsets4",
                            "L1_pieExtraOffsets5",
                            "L1_pieHoleColor1",
                            "L1_pieHoleColor2",
                            "L1_pieLabel",
                            "L1_pieLabel1",
                            "L1_pieLogEnabled1",
                            "L1_pieMarker",
                            "L1_pieNoData1",
                            "L1_pieNoData2",
                            "L1_pieonAnimationUpdate",
                            "L1_pieonSizeChanged",
                            "L1_piesetSliceSpace",
                            "L1_pieslicespace",
                            "L1_pieslicespace1",
                            "L1_pieslicespace2",
                            "L1_pieTransparentCircleColor1",
                            "L1_pieTransparentCircleColor2",
                            "L1_pieTransparentCircleColor3",
                            "L1_pieUnbindEnabled",
                            "L1_pieUsePercentValues",
                            "L1_pieUsePercentValues1",
                            "L1_pieValueFormatter",
                            "L1_pieValueFormatter1",
                            "L1_pieValueLine",
                            "L1_pieValueLine1",
                            "L1_pieValueLine2",
                            "L1_pieValueLine3",
                            "L1_pieValueLine4",
                            "L1_pieValueLine5",
                            "L1_pieValueTextColor",
                            "L1_pieValueTextColor1",
                            "L1_pieValueTextColors",
                            "L1_pieValueTextColors1",
                            "L1_pieVisible1",
                            "L1_pieVisible2",
                            "L1_pieXYvalue",

                            "L2_piePiEntry",
                            "L2_pie_CenterColor",
                            "L2_pie_chart",
                            "L2_pie_chart1",
                            "L2_pie_chart2",
                            "L2_pie_ColorsByVariable",
                            "L2_pie_setCenterTextTypeface",
                            "L2_pie_setExtraBottomOffset",
                            "L2_pie_setExtraLeftOffset",
                            "L2_pie_setExtraOffsets",
                            "L2_pie_setExtraRightOffset",
                            "L2_pie_setExtraTopOffset",
                            "L2_pie_setLabel",
                            "L2_pie_setValueLineVariableLength",
                            "L2_pie_setValueLineVariableLength1")
    return listpie
}

@Entry
@Component
class index_pie {
    let arr3=getnamepie()
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
