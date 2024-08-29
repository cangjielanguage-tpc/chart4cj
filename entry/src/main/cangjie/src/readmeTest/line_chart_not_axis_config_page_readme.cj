/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package ohos_app_cangjie_entry.readmeTest

import ohos.state_macro_manage.*

@Entry
@Component
class LineChartNotAxisConfigPageReadme {
    private var model: LineChartModel = LineChartModel.build()
    var minOffset: Float64 = 15.0
    var leftAxis: ?YAxis = None
    var rightAxis: ?YAxis = None
    var lineData: LineData = LineData()

    protected override func aboutToAppear() {
        let legend: ?Legend = this.model.getLegend()
        if (let Some(v) <- legend) {
            v.setEnabled(true)
            v.setOrientation(LegendOrientation.HORIZONTAL)
            v.setVerticalAlignment(LegendVerticalAlignment.BOTTOM)
            v.setHorizontalAlignment(LegendHorizontalAlignment.RIGHT)
            v.setDrawInside(true)
            v.setYOffset(-40.0)
        }

        this.model.setMinOffset(this.minOffset)
        this.lineData = this.setData(10, 100.0)
        this.model.setData(this.lineData)
    }

    private func setData(count: Int64, range: Float64): LineData {
        let values1 = ArrayList<EntryOhos>()
        let values2 = ArrayList<EntryOhos>()
        let values3 = ArrayList<EntryOhos>()

        for (i in 0..count) {
            let val: Float64 = Random().nextFloat64() * range + 3.0
            values1.append(EntryOhos(Float64(i), val))
        }

        for (i in 0..count) {
            let val: Float64 = Random().nextFloat64() * range + 3.0
            values2.append(EntryOhos(Float64(i), val))
        }

        for (i in 0..count) {
            let val: Float64 = Random().nextFloat64() * range + 3.0
            values3.append(EntryOhos(Float64(i), val))
        }

        let dataSet = ArrayList<ILineDataSet>()

        let gradientFillColor = ArrayList<ChartColorStop>()
        gradientFillColor.append((0xffffff, 0.3))
        gradientFillColor.append((0x00ffff, 1.0))

        let set1 = LineDataSet(values1, "DataSet 1")
        set1.setDrawFilled(false)
        set1.setDrawValues(true)
        set1.setDrawCircles(true)
        set1.setCircleColor(0x2b89ab)
        set1.setCircleRadius(4.0)
        set1.setMode(Mode.LINEAR)
        set1.setColorByColor(0x2b89ab)
        set1.setLineWidth(2.5)
        dataSet.append(set1)

        let set2 = LineDataSet(values2, "DataSet 2")
        set2.setDrawFilled(false)
        set2.setDrawValues(true)
        set2.setDrawCircles(true)
        set2.setCircleColor(0xcd4e2e)
        set2.setCircleRadius(4.0)
        set2.setMode(Mode.LINEAR)
        set2.setColorByColor(0xcd4e2e)
        set2.setLineWidth(2.5)
        dataSet.append(set2)

        let set3 = LineDataSet(values3, "DataSet 3")
        set3.setDrawFilled(false)
        set3.setDrawValues(true)
        set3.setDrawCircles(true)
        set3.setCircleColor(0xacc045)
        set3.setCircleRadius(4.0)
        set3.setMode(Mode.LINEAR)
        set3.setColorByColor(0xacc045)
        set3.setLineWidth(2.5)
        dataSet.append(set3)

        let lineData: LineData = LineData(dataSet)

        return lineData
    }

    func build() {
        Column {
            LineChart(model: this.model)
        }.width(100.percent).height(70.percent).backgroundColor(Color.WHITE)
    }
}
