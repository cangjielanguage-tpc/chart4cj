/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package ohos_app_cangjie_entry
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos.router.*
import std.collection.*

func getnamebar():ArrayList<String> {

        let listbar = ArrayList<String>("L0_bar_page",
                                    "L0_level_BarChartModel",
                                    "L0_level_BarChartModel5",
                                    "L0_bubblel_bar_page",
                                    "L0_bubblel_bar_page2",
                                    "L1_level_bar_groupBars_page",
                                    "L1_level_bar_groupBars_page1",
                                    "L1_level_bar_setBarBorderWidth_page",
                                    "L1_level_bar_setBarShadowColor_page",
                                    "L1_level_bar_setBarWidth_page",
                                    "L1_level_bar_setfills_page1",
                                    "L1_level_bar_setfills_page2",
                                    "L1_level_bar_setfills_page3",
                                    "L1_level_bar_setfills_page4",
                                    "L1_level_bar_setfills_page5",
                                    "L1_level_bar_setfills_page6",
                                    "L1_level_bar_setGradientColor_page",
                                    "L1_level_bar_setStackLabels_page",
                                    "L1_level_bar_setTopRadius_page",
                                    "L1_level_BarChartModel1",
                                    "L1_level_BarChartModel2",
                                    "L1_level_BarChartModel3",
                                    "L1_level_BarChartModel4",
                                    "L1_level_BarChartModel6",
                                    "L1_level_BarChartModel7",
                                    "L1_level_BarChartModel8",
                                    "L1_level_BarChartModel9",
                                    "L1_level_BarChartModel10",
                                    "L1_level_BarChartModel11",
                                    "L1_level_BarChartModel12",
                                    "L1_level_BarChartModel13",
                                    "L1_level_BarChartModel14",
                                    "L1_level_BarChartModel15",
                                    "L1_level_BarChartModel16",
                                    "L1_level_BarChartModel17",
                                    "L1_level_BarChartModel18",
                                    "L1_level_BarChartModel19",
                                    "L1_level_BarChartModel20",
                                    "L1_level_BarChartModel21",
                                    "L1_level_BarChartModel22",
                                    "L1_level_BarChartModel23",
                                    "L1_level_BarChartModel24",
                                    "L1_level_BarChartModel25",
                                    "L1_level_BarChartModel26",
                                    "L1_level_BarChartModel27",
                                    "L1_level_BarChartModel28",
                                    "L1_level_BarChartModel29",
                                    "L1_level_BarChartModel30",
                                    "L1_level_BarChartModel31",
                                    "L1_level_BarChartModel32",
                                    "L1_level_BarChartModel33",
                                    "L1_level_BarChartModel34",
                                    "L1_level_BarChartModel35",
                                    "L1_level_BarChartModel36",
                                    "L1_level_BarChartModel37",
                                    "L1_level_BarChartModel40",
                                    "L1_level_BarChartModel41",
                                    "L1_level_BarChartModel42",
                                    "L1_level_BarChartModel43",
                                    "L1_level_BarChartModel44",
                                    "L1_level_BarChartModel45",
                                    "L1_level_BarChartModel46",
                                    "L1_level_barentry_page1",
                                    "L1_level_barentry_page2",
                                    "L1_level_barentry_page3",
                                    "L1_level_barentry_page4",
                                    "L1_level_barentry_page5",
                                    "L1_level_barentry_page6",
                                    "L1_level_barentry_page7",
                                    "L1_level_barentry_page8",
                                    "L1_level_barentry_page9",
                                    "L1_level_copy_page1",
                                    "L1_bar_page1",
                                    "L1_vertical_bar_groupBars_page",
                                    "L1_vertical_bar_groupBars_page1",
                                    "L1_vertical_bar_setBarBorderWidth_page",
                                    "L1_vertical_bar_setBarShadowColor_page",
                                    "L1_vertical_bar_setBarWidth_page",
                                    "L1_vertical_bar_setfills_page1",
                                    "L1_vertical_bar_setfills_page2",
                                    "L1_vertical_bar_setfills_page3",
                                    "L1_vertical_bar_setfills_page4",
                                    "L1_vertical_bar_setfills_page5",
                                    "L1_vertical_bar_setfills_page6",
                                    "L1_vertical_bar_setGradientColor_page",
                                    "L1_vertical_bar_setHighLightAlpha_page",
                                    "L1_vertical_bar_setStackLabels_page",
                                    "L1_vertical_bar_setTopRadius_page",
                                    "L1_vertical_BarChartModel",
                                    "L1_vertical_BarChartModel1",
                                    "L1_vertical_BarChartModel2",
                                    "L1_vertical_BarChartModel5",
                                    "L1_vertical_BarChartModel6",
                                    "L1_vertical_BarChartModel7",
                                    "L1_vertical_BarChartModel8",
                                    "L1_vertical_BarChartModel9",
                                    "L1_vertical_BarChartModel10",
                                    "L1_vertical_BarChartModel11",
                                    "L1_vertical_BarChartModel12",
                                    "L1_vertical_BarChartModel13",
                                    "L1_vertical_BarChartModel14",
                                    "L1_vertical_BarChartModel15",
                                    "L1_vertical_BarChartModel16",
                                    "L1_vertical_BarChartModel17",
                                    "L1_vertical_BarChartModel18",
                                    "L1_vertical_BarChartModel19",
                                    "L1_vertical_BarChartModel20",
                                    "L1_vertical_BarChartModel21",
                                    "L1_vertical_BarChartModel25",
                                    "L1_vertical_BarChartModel26",
                                    "L1_vertical_BarChartModel27",
                                    "L1_vertical_BarChartModel28",
                                    "L1_vertical_BarChartModel29",
                                    "L1_vertical_BarChartModel30",
                                    "L1_vertical_BarChartModel31",
                                    "L1_vertical_BarChartModel32",
                                    "L1_vertical_BarChartModel33",
                                    "L1_vertical_BarChartModel34",
                                    "L1_vertical_BarChartModel35",
                                    "L1_vertical_BarChartModel36",
                                    "L1_vertical_BarChartModel37",
                                    "L1_vertical_BarChartModel38",
                                    "L1_vertical_BarChartModel39",
                                    "L1_vertical_BarChartModel40",
                                    "L1_vertical_BarChartModel41",
                                    "L1_vertical_BarChartModel42",
                                    "L1_vertical_BarChartModel43",
                                    "L1_vertical_BarChartModel44",
                                    "L1_vertical_BarChartModel45",
                                    "L1_vertical_BarChartModel46",
                                    "L1_vertical_barentry_page1",
                                    "L1_vertical_barentry_page2",
                                    "L1_vertical_barentry_page3",
                                    "L1_vertical_barentry_page4",
                                    "L1_vertical_barentry_page5",
                                    "L1_vertical_barentry_page6",
                                    "L1_vertical_barentry_page7",
                                    "L1_vertical_barentry_page8",
                                    "L1_vertical_barentry_page9",
                                    "L1_vertical_barentry_page10",
                                    "L1_vertical_barentry_page11",
                                    "L1_vertical_copy_page1",
                                    "L2_level_bar_chartModel2",
                                    "L2_level_BarChartModel",
                                    "L2_level_BarChartModel1",
                                    "L2_vertical_BarChartModel",
                                    "L2_vertical_BarChartModel1",
                                    "L2_vertical_BarChartModel2",
                                    "L2_vertical_BarChartModel3",
                                    "L2_vertical_BarChartModel4",
                                    "L2_vertical_setBarWidth_page",
                                    "L2_vertical_setDragDecelerationFrictionCoef")
                return listbar
}

@Entry
@Component
class index_bar {

    let arr1=getnamebar()
    func build(): Unit {
            Scroll(){
            Column() {
                ForEach(this.arr1, itemGeneratorFunc: {item: String, _: Int64 =>
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
