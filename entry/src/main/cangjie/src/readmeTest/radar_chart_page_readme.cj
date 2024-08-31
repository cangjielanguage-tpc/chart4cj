/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package ohos_app_cangjie_entry.readmeTest

import ohos.state_macro_manage.*
import ohos.base.LengthProp
import ohos.component.Column
import ohos.component.Row
import ohos.component.Button
import ohos.component.Text
import ohos.component.CustomView
import ohos.component.CJEntry
import ohos.component.loadNativeView
import ohos.state_manage.SubscriberManager
import ohos.state_manage.ObservedProperty
import ohos.state_macro_manage.Entry
import ohos.state_macro_manage.Component
import ohos.state_macro_manage.State
import ohos.state_macro_manage.r
import ohos.base.*
import ohos.component.*
import std.collection.{ArrayList}
import std.math.*
import std.random.*
import mpchart.pie.*
import mpchart.utils.*
import mpchart.components.*

@Entry
@Component
class RadarChartPageReadme {
    private var model: RadarChartModel = RadarChartModel.build()

    protected override func aboutToAppear() {
        let description: Description = this.model.getDescription()
        description.setEnabled(false)
        description.setPosition(200.0, 200.0)
        description.setTextColor(Color(0xffffff))
        description.setTextSize(15.0)

        let l: ?Legend = this.model.getLegend()
        if (let Some(legend) <- l) {
            legend.setEnabled(true)
            legend.setOrientation(LegendOrientation.HORIZONTAL)
            legend.setVerticalAlignment(LegendVerticalAlignment.BOTTOM)
            legend.setDrawInside(false)
            legend.setXEntrySpace(7.0)
            legend.setYEntrySpace(5.0)
            legend.setTextColor(Color(0xffffff))
            legend.setYOffset(50.0)
        }

        this.model.setWebLineWidth(0.3)
        this.model.setWebColor(0xFFCCCCCC)
        this.model.setWebLineWidthInner(0.3)
        this.model.setWebColorInner(0xFFCCCCCC)
        this.model.setExtraTopOffset(-100.0)

        let xAxis: ?XAxis = this.model.getXAxis()
        if (let Some(xAxis) <- xAxis) {
            xAxis.setPosition(XAxisPosition.BOTTOM)
            xAxis.setDrawGridLines(false)
            xAxis.setYOffset(0.0)
            xAxis.setXOffset(0.0)
            xAxis.setLabelCount(7, false)
            xAxis.setValueFormatter(valueFormatter())
            xAxis.setTextColor(Color(0xffffff))
        }

        let leftAxis: ?YAxis = this.model.getYAxis()
        if (let Some(yAxis) <- leftAxis) {
            yAxis.setLabelCount(5, false)
            yAxis.setAxisMinimum(0.0)
            yAxis.setAxisMaximum(80.0)
            yAxis.setDrawLabels(false)
        }

        this.setData()
    }

    private func setData(): Unit {
        let mul = 80.0
        let min = 20.0
        let cnt = 5

        let entries1: ArrayList<RadarEntry> = ArrayList<RadarEntry>()
        let entries2: ArrayList<RadarEntry> = ArrayList<RadarEntry>()

        for (i in 0..cnt) {
            let val1 = (Random().nextFloat64() * mul) + min
            entries1.append(RadarEntry(val1))

            let val2 = (Random().nextFloat64() * mul) + min
            entries2.append(RadarEntry(val2))
        }

        let set1: RadarDataSet = RadarDataSet(entries1, "Last Week")
        set1.setColorByColor(UInt32(ChartColor.rgb(103, 110, 129)))
        set1.setLineWidth(2.0)

        let set2: RadarDataSet = RadarDataSet(entries2, "This Week")
        set2.setColorByColor(UInt32(ChartColor.rgb(121, 162, 175)))
        set2.setLineWidth(2.0)

        let sets: ArrayList<IRadarDataSet> = ArrayList<IRadarDataSet>()
        sets.append(set1)
        sets.append(set2)

        let data: RadarData = RadarData(sets)
        data.setValueTextSize(20.0)
        data.setDrawValues(false)
        data.setValueTextColor(0xffffff)
        this.model.setData(data)
    }

    func build() {
        Column() {
            Column() {
                RadarChart(model: this.model)
            }.backgroundColor(0x3C4152)
        }
    }
}

class valueFormatter <: IAxisValueFormatter {
    private var mActivities: Array<String> = ["Burger", "Steak", "Salad", "Pasta", "Pizza"]

    public func getFormattedValue(value: Float64, axis: AxisBase): String {
        return this.mActivities[Int64(floor(Float64(Int64(value) % (this.mActivities.size))))]
    }
}
