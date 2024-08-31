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
class HorizontalBarNegativeChartPage {
    private var title: String = "Horizontal Negative"
    private var model: HorizontalBarChartModel = HorizontalBarChartModel.build()
    private var leftAxis: ?YAxis = Option<YAxis>.None
    private var rightAxis: ?YAxis = Option<YAxis>.None
    private var xAxis: ?XAxis = Option<XAxis>.None

    protected override func aboutToAppear(){
        this.model = HorizontalBarChartModel.build()
        this.model.animateX(2000, easing: "linear")

        this.model.setDrawBarShadow(false)
        this.model.setDrawValueAboveBar(true)

        let description: Description = this.model.getDescription()

        description.setEnabled(false)

        this.model.setDrawGridBackground(false)

        let xAxis: ?XAxis = this.model.getXAxis()
        if (let Some(xaxis) <- this.xAxis) {
            xaxis.setPosition(XAxisPosition.BOTTOM)
            xaxis.setDrawGridLines(false)
            xaxis.setLabelCount(7, Option<Bool>.None)
            xaxis.setDrawAxisLine(true)
        }

        let leftAxis: ?YAxis = this.model.getAxisLeft()
        if (let Some(leftaxis) <- this.leftAxis) {
            leftaxis.setLabelCount(8, false)
            leftaxis.setSpaceTop(15.0)
            leftaxis.setPosition(YAxisLabelPosition.OUTSIDE_CHART)
            leftaxis.setDrawAxisLine(true)
        }

        let rightAxis: ?YAxis = this.model.getAxisRight()
        if (let Some(rightaxis) <- this.rightAxis) {
            rightaxis.setLabelCount(8, false)
            rightaxis.setDrawGridLines(false)
            rightaxis.setSpaceTop(15.0)
            rightaxis.setDrawAxisLine(true)
        }

        let legend: ?Legend = this.model.getLegend()
        if (let Some(l) <- legend) {
            l.setEnabled(false)
        }
        this.model.setFitBars(true)
        this.setData(12, 50)
    }

    private func setData(count: Int64, range: Int64): Unit {
        let spaceForBar: Int64 = 10

        let values: ArrayList<BarEntry> = ArrayList<BarEntry>()
        for (i in 0..count) {
            let val = Random().nextFloat64() * Float64(range) - Float64(range) / 2.0
            values.append(BarEntry(Float64(i * spaceForBar), val))
        }

        let dataSet: BarDataSet = BarDataSet(values, "DataSet")
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
            HorizontalBarChart(model: this.model)
        }.width(100.percent).height(70.percent).backgroundColor(Color.WHITE)
    }
}
