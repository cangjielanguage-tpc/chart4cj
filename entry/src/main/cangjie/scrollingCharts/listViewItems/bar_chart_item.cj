/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package ohos_app_cangjie_entry.scrollingCharts.listViewItems

//import ohos.base.*
//import ohos.component.*
//import ohos.state_manage.*
import tpc.UIKit.*
import ohos.state_macro_manage.*
import chart.pie.*
import chart.utils.*
import chart.components.*
import chart.charts.*
import chart.bar.*

@Component
public  class BarChartItem {
    var data: BarData = BarData()
    @State
    var barModel: BarChartModel = BarChartModel.build()

    var pageInfo: NavPathStack = NavPathStack()

    protected override func aboutToAppear() {
        let leftAxis = this.barModel.getAxisLeft()
        if (let Some(leftAxis) <- leftAxis) {
            leftAxis.setLabelCount(7, false)
            leftAxis.setAxisMinimum(0.0)
            leftAxis.setAxisMaximum(100.0)
            leftAxis.enableGridDashedLine(10.0, 10.0)
        }

        this.barModel.setData(this.data)

        this.barModel.setDrawBarShadow(false)
        this.barModel.setDrawValueAboveBar(true)
        this.barModel.getDescription().setEnabled(false)
        this.barModel.setMaxVisibleValueCount(60)
    }

    func build() {
        NavDestination() {
            Column() {
                BarChart(model: this.barModel)
            }.alignItems(HorizontalAlign.Start).width(100.percent).height(30.percent)
        }.onReady({
            context => pageInfo = context.pathStack
        }).onBackPressed({
            => false
        })
    }
}
