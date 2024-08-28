/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package ohos_app_cangjie_entry.linePage
import ohos.state_macro_manage.*

@Entry
@Component
class DualAxisPage {
    private var model: LineChartModel = LineChartModel.build()
    private var leftAxis: ?YAxis = None
    private var rightAxis: ?YAxis = None
    private var xAxis: ?XAxis = None
    private var dataSet: LineDataSet = LineDataSet(ArrayList<EntryOhos>(), "")

    private func setData(count: Int64, range: Float64): Unit {
        let values1 = ArrayList<EntryOhos>()
        let values2 = ArrayList<EntryOhos>()
        let values3 = ArrayList<EntryOhos>()

        for (i in 0..count) {
            let yVal: Float64 = Random().nextFloat64() * (range / 2.0) + 50.0
            values1.append(EntryOhos(Float64(i), yVal))
        }

        for (i in 0..count) {
            let yVal: Float64 = Random().nextFloat64() * range + 100.0
            values2.append(EntryOhos(Float64(i), yVal))
        }

        for (i in 0..count) {
            let yVal: Float64 = Random().nextFloat64() * range + 120.0
            values3.append(EntryOhos(Float64(i), yVal))
        }

        let dataSet = ArrayList<ILineDataSet>()

        let set1 = LineDataSet(values1, "DataSet 1")
        set1.setDrawFilled(false)
        set1.setDrawValues(true)
        set1.setDrawCircles(true)
        set1.setDrawCircleHole(false)
        set1.setCircleRadius(3.0)
        set1.setCircleColor(0XFFFFFFFF)
        set1.setColorByColor(0XCC33FF)
        set1.setLineWidth(2.0)
        dataSet.append(set1)

        let set2 = LineDataSet(values2, "DataSet 2")
        set2.setDrawFilled(false)
        set2.setDrawValues(true)
        set2.setDrawCircles(true)
        set2.setDrawCircleHole(false)
        set2.setCircleRadius(3.0)
        set2.setCircleColor(0XFFFFFFFF)
        set2.setColorByColor(0Xff000000)
        set2.setLineWidth(2.0)
        dataSet.append(set2)

        let set3 = LineDataSet(values3, "DataSet 3")
        set3.setDrawFilled(false)
        set3.setDrawValues(true)
        set3.setDrawCircles(true)
        set3.setDrawCircleHole(false)
        set3.setCircleRadius(3.0)
        set3.setCircleColor(0xffffffff)
        set3.setColorByColor(0xFFFF00)
        set3.setLineWidth(2.0)
        dataSet.append(set3)
        let lineData: LineData = LineData(dataSet)
        lineData.setValueTextSize(10.0)

        this.model.setData(lineData)
    }

    protected override func aboutToAppear() {
        let description: Description = this.model.getDescription()

        description.setEnabled(false)

        this.model.setDrawGridBackground(false)

        this.xAxis = this.model.getXAxis()
        if (let Some(x) <- this.xAxis) {
            x.setPosition(XAxisPosition.TOP)
            x.setDrawGridLines(true) //纵向线格显示
            x.setLabelCount(6, false) //设置X轴坐标个数
            x.setTextColor(Color.WHITE)
        }

        this.leftAxis = this.model.getAxisLeft()
        if (let Some(l) <- this.leftAxis) {
            l.setLabelCount(6, false)
            l.setTextColor(Color.BLUE)
            l.setDrawGridLines(true)
            l.setPosition(YAxisLabelPosition.OUTSIDE_CHART)
            l.setDrawAxisLine(true)
        }

        this.rightAxis = this.model.getAxisRight()
        if (let Some(r) <- this.rightAxis) {
            r.setEnabled(true) //右Y轴是否显示
            r.setDrawGridLines(false)
            r.setLabelCount(6, false)
            r.setTextColor(Color.RED)
            r.setDrawAxisLine(false)
            r.setDrawLabels(true)
            r.setDrawZeroLine(false)
        }

        let legend: ?Legend = this.model.getLegend()
        if (let Some(l) <- legend) {
            l.setEnabled(false)
        }

        this.setData(18, 30.0) //数据点的个数太多会导致数据不能显示

        this.model.setVisibleXRangeMaximum(50.0) //会影响数据点的显示，太大也不会显示
    }

    func build() {
        Column {
            LineChart(model: this.model)
        }.width(100.percent).height(70.percent).backgroundColor(Color.WHITE)
    }
}
