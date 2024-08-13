/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package ohos_app_cangjie_entry.barPage

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*

@Entry
@Component
class HorizontalBarChartPage {
    private var title: String = "Horizontal"
    private var model: HorizontalBarChartModel = HorizontalBarChartModel.build()
    private var leftAxis: ?YAxis = Option<YAxis>.None
    private var rightAxis: ?YAxis = Option<YAxis>.None
    private var xAxis: ?XAxis = Option<XAxis>.None

    func aboutToAppear(): HorizontalBarChartModel {
        this.model = HorizontalBarChartModel.build()
        this.model.animateX(1000, easing: "linear")

        this.model.setDrawBarShadow(false)
        this.model.setDrawValueAboveBar(true)

        let description: Description = this.model.getDescription()

        description.setEnabled(false)

        this.model.setPinchZoom(false)
        this.model.setDrawGridBackground(false)

        let xAxis: ?XAxis = this.model.getXAxis()
        if (let Some(xaxis) <- this.xAxis) {
            xaxis.setPosition(XAxisPosition.BOTTOM)
            xaxis.setDrawGridLines(false)
            xaxis.setGranularity(1.0)
            xaxis.setLabelCount(7, Option<Bool>.None)
            xaxis.setDrawAxisLine(true)
        }

        let leftAxis: ?YAxis = this.model.getAxisLeft()
        if (let Some(leftaxis) <- this.leftAxis) {
            leftaxis.setLabelCount(8, false)
            leftaxis.setPosition(YAxisLabelPosition.OUTSIDE_CHART)
            leftaxis.setDrawAxisLine(true)
        }

        let rightAxis: ?YAxis = this.model.getAxisRight()
        if (let Some(rightaxis) <- this.rightAxis) {
            rightaxis.setLabelCount(8, false)
            rightaxis.setDrawGridLines(false)
            rightaxis.setDrawAxisLine(true)
        }

        let legend: ?Legend = this.model.getLegend()
        if (let Some(l) <- legend) {
            l.setEnabled(false)
        }
        this.model.setFitBars(true)
        this.setData(10, 50)
        return this.model
    }

    private func setData(count: Int64, range: Int64): Unit {
        let startAxis: Int64 = 0
        let endAxis: Int64 = startAxis + count

        let values: ArrayList<BarEntry> = ArrayList<BarEntry>()
        for (i in startAxis..endAxis) {
            let val = Random().nextFloat64() * Float64(range)
            values.append(BarEntry(Float64(i), val))
        }

        let dataSet: BarDataSet = BarDataSet(values, "DataSet")
        dataSet.setHighLightColor(0x000000)
        dataSet.setDrawIcons(false)

        dataSet.setColorByColor(0x8CEAFF)

        let dataSetList: ArrayList<IBarDataSet> = ArrayList<IBarDataSet>()
        dataSetList.append(dataSet)

        let barData: BarData = BarData(dataSetList)
        barData.setValueTextSize(10.0)
        barData.setBarWidth(0.9)

        this.model.setData(barData)
    }

    func build() {
        Column {
            Text(this.title).fontSize(21).fontColor(Color.WHITE).fontWeight(FontWeight.W600).layoutWeight(1).maxLines(1)
            HorizontalBarChart(model: aboutToAppear())
        }.width(100.percent).height(70.percent).backgroundColor(Color.WHITE)
    }
}
