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
class StackedNegativePage {
    private var model: BarChartModel = HorizontalBarChartModel.build()
    private var leftAxis: ?YAxis = Option<YAxis>.None
    private var rightAxis: ?YAxis = Option<YAxis>.None
    private var xAxis: ?XAxis = Option<XAxis>.None
    private var limitLine1: LimitLine = LimitLine(0.0, "limit1")
    private var limitLine2: LimitLine = LimitLine(0.0, "limit2")
    private var barData: BarData = BarData()

    protected override func aboutToAppear() {
        let description: Description = this.model.getDescription()

        description.setEnabled(false)

        let l: ?Legend = this.model.getLegend()
        if (let Some(l) <- l) {
            l.setEnabled(false)
        }

        this.model.setDrawGridBackground(false)
        this.model.setGridBackgroundColor(0x500000ff)
        this.model.setDrawBarShadow(false)

        this.model.setDrawValueAboveBar(true)

        this.leftAxis = this.model.getAxisLeft()
        if (let Some(leftAxis) <- this.leftAxis) {
            leftAxis.setEnabled(false)
        }

        this.rightAxis = this.model.getAxisRight()
        if (let Some(rightAxis) <- this.rightAxis) {
            rightAxis.setAxisMaximum(25.0)
            rightAxis.setAxisMinimum(-25.0)
            rightAxis.setDrawGridLines(false)
            rightAxis.setDrawZeroLine(true)
            rightAxis.setLabelCount(7, false)
            rightAxis.setValueFormatter(CustomFormatter())
        }

        this.xAxis = this.model.getXAxis()
        if (let Some(xAxis) <- this.xAxis) {
            xAxis.setPosition(XAxisPosition.BOTH_SIDED)
            xAxis.setDrawGridLines(false)
            xAxis.setDrawAxisLine(false)
            xAxis.setAxisMinimum(0.0)
            xAxis.setAxisMaximum(110.0)
            xAxis.setCenterAxisLabels(true)
            xAxis.setLabelCount(12, false)
            xAxis.setGranularity(10.0)
            xAxis.setValueFormatter(CustomValueFormatter())
        }

        this.barData = this.getStackData()
        this.barData.setBarWidth(8.5)
        this.model.setData(this.barData)
    }

    private func getStackData(): BarData {
        let values: ArrayList<BarEntry> = ArrayList<BarEntry>()
        values.append(BarEntry(5.0, [-10.0, 10.0]))
        values.append(BarEntry(15.0, [-12.0, 13.0]))
        values.append(BarEntry(25.0, [-15.0, 15.0]))
        values.append(BarEntry(35.0, [-17.0, 17.0]))
        values.append(BarEntry(45.0, [-19.0, 20.0]))
        values.append(BarEntry(45.0, [-19.0, 20.0]))
        values.append(BarEntry(55.0, [-19.0, 19.0]))
        values.append(BarEntry(65.0, [-16.0, 16.0]))
        values.append(BarEntry(75.0, [-13.0, 14.0]))
        values.append(BarEntry(85.0, [-10.0, 11.0]))
        values.append(BarEntry(95.0, [-5.0, 6.0]))
        values.append(BarEntry(105.0, [-1.0, 2.0]))

        let set1: BarDataSet

        set1 = BarDataSet(values, "Statistics Vienna 2014")
        set1.setDrawIcons(false)
        set1.setColorsByVariable(this.getColors())
        set1.setStackLabels(["Births", "Divorces", "Marriages"])

        set1.setDrawValues(true)
        let dataSets: ArrayList<IBarDataSet> = ArrayList<IBarDataSet>()
        dataSets.append(set1)

        let data: BarData = BarData(dataSets)
        data.setValueTextColor(0XFFFFFF)
        return data
    }
    private func getColors(): Array<UInt32> {
        let colors: Array<UInt32> = [UInt32(ChartColor.rgb(67, 67, 67)), UInt32(ChartColor.rgb(124, 181, 236))]
        return colors
    }

    func build() {
        Column {
            BarChart(model: this.model)
        }.width(100.percent).height(70.percent).backgroundColor(Color.WHITE)
    }
}

class CustomFormatter <: IAxisValueFormatter {
    public func getFormattedValue(value: Float64, axis: AxisBase): String {
        return abs(value).format(".0") + "m";
    }
}

class CustomValueFormatter <: IAxisValueFormatter {
    public func getFormattedValue(value: Float64, axis: AxisBase): String {
        return abs(value).format(".0") + "- ${(Int64.parse(abs(value).format(".0")) + 10)}"
    }
}
