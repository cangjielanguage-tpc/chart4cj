/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package ohos_app_cangjie_entry.eventMoreLineCharts

import ohos.state_macro_manage.*
import ohos.state_manage.SubscriberManager
import ohos.state_manage.ObservedProperty
import ohos.state_macro_manage.Entry
import ohos.state_macro_manage.Component
import ohos.state_macro_manage.State

@Entry
@Component
class HourlyPage {
    @State
    var lineData: LineData = LineData()
    @State
    var lineChartModel: LineChartModel = LineChartModel.build()

    protected override func aboutToAppear() {
        this.lineData = this.initCurveData(100, 50.0)
        this.lineChartModel.setData(this.lineData)

        let topAxis = this.lineChartModel.getXAxis()
        if (let Some(topAxis) <- topAxis) {
            topAxis.setLabelCount(5, false)
            topAxis.setPosition(XAxisPosition.TOP_INSIDE)
            topAxis.setTextSize(10.0)
            topAxis.setTextColor(Color(UInt32(ColorTemplate.colorRgb(255, 192, 56))))
            topAxis.setAxisMinimum(0.0)
            topAxis.setAxisMaximum(100.0)
            topAxis.setCenterAxisLabels(true)
            topAxis.setDrawAxisLine(true)
            topAxis.setDrawLabels(true)
            topAxis.setDrawGridLines(true)
            topAxis.setGranularity(1.0)
            topAxis.setValueFormatter(TopAxisValueFormatter())
        }

    }

    private var values: ArrayList<EntryOhos> = ArrayList<EntryOhos>()

    private func initCurveData(count: Int64, range: Float64): LineData {
        let values = ArrayList<EntryOhos>()
        let now: Int64 = DateTime.now().hour
        let to: Int64 = now + count

        for (x in 0..count) {
            let yVal: Float64 = (Random().nextFloat64() * range) + 50.0
            values.add(EntryOhos(Float64(x), yVal))
        }
        let dataSet = ArrayList<ILineDataSet>()
        let dataSet1 = LineDataSet(values, "DataSet 1")
        dataSet1.setDrawFilled(false)
        dataSet1.setDrawValues(false)
        dataSet1.setDrawCircles(false)
        dataSet1.setDrawCircleHole(false)
        dataSet1.setCircleRadius(4.0)
        dataSet1.setCircleHoleRadius(2.0)
        dataSet1.setCircleHoleColor(0xffffff)
        dataSet1.setCircleColor(UInt32(ColorTemplate.colorRgb(140, 234, 255)))
        dataSet1.setMode(Mode.LINEAR)
        dataSet1.setColorByColor(UInt32(ColorTemplate.colorRgb(140, 234, 255)))

        dataSet.add(dataSet1)
        return LineData(dataSet)
    }

    func build() {
        Column {
            LineChart(model: this.lineChartModel)
        }.width(100.percent).height(70.percent).backgroundColor(Color.WHITE)
    }
}

class TopAxisValueFormatter <: IAxisValueFormatter {
    public func getFormattedValue(value: Float64, axis: AxisBase): String {
        let mmddd = DateTime.nowUTC().toString()[0..10]
        let mmdd = mmddd.split('-')
        Hilog.error(0x0000, "test", "----------${mmdd}")
        let day = Int64.parse(mmdd[2]) + Int64(value) / 20
        let hours = Int64(DateTime.now().hour) + Int64(value) / 20
        return "${day} ${mmdd[1]} ${hours}"
    }
}
