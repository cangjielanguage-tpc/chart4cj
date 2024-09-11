/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package ohos_app_cangjie_entry.scrollingCharts.listViewItems

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import chart.pie.*
import chart.utils.*
import chart.components.*
import chart.charts.*
import chart.line.*

@Component
public class LineChartItem {
    var data: LineData = LineData()
    @State
    var lineChartModel: LineChartModel = LineChartModel.build()

    protected override func aboutToAppear() {
        this.lineChartModel.setData(this.data)
    }

    func build() {
        Column() {
            LineChart(model: this.lineChartModel)
        }.alignItems(HorizontalAlign.Start).width(100.percent).height(30.percent)
    }
}
