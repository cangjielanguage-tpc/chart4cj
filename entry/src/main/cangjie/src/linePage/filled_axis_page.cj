/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package ohos_app_cangjie_entry.linePage
import ohos.state_macro_manage.*

@Entry
@Component
class FilledAxisPage {
    private var model: LineChartModel = LineChartModel.build()
    private var leftAxis: ?YAxis = None
    private var rightAxis: ?YAxis = None
    private var xAxis: ?XAxis = None

    private func setData(count: Int64, range: Float64): Unit {
        let values1 = ArrayList<EntryOhos>()
        for (i in 0..count) {
            let val: Float64 = Random().nextFloat64() * range + 550.0
            values1.append(EntryOhos(Float64(i), val))
        }

        let values2 = ArrayList<EntryOhos>()
        for (i in 0..count) {
            let val: Float64 = Random().nextFloat64() * range + 150.0
            values2.append(EntryOhos(Float64(i), val))
        }

        let gradientFillColor1 = ArrayList<ChartColorStop>()
        gradientFillColor1.append((0x00ffff, 0.1))
        gradientFillColor1.append((0xffffff, 1.0))

        let gradientFillColor2 = ArrayList<ChartColorStop>()
        gradientFillColor2.append((0xffffff, 0.1))
        gradientFillColor2.append((0xffffff, 1.0))

        let dataSet = ArrayList<ILineDataSet>()

        let set1 = LineDataSet(values1, "DataSet 1")
        set1.setDrawFilled(true)
        set1.setDrawValues(false)
        set1.setDrawCircles(false)
        set1.setMode(Mode.LINEAR)
        set1.setGradientFillColor(gradientFillColor1)
        set1.setColorByColor(0xff000000)
        set1.setLineWidth(2.0)
        dataSet.append(set1)

        let set2 = LineDataSet(values2, "DataSet 2")
        set2.setDrawFilled(true)
        set2.setDrawValues(false)
        set2.setDrawCircles(false)
        set2.setMode(Mode.LINEAR)
        set2.setGradientFillColor(gradientFillColor2)
        set2.setColorByColor(0xff000000)
        set2.setLineWidth(2.0)
        dataSet.append(set2)

        let lineData: LineData = LineData(dataSet)
        lineData.setValueTextSize(10.0)

        this.model.setData(lineData)
    }

    func aboutToAppear(): LineChartModel {
        let description: Description = this.model.getDescription()

        description.setEnabled(false)

        this.model.setMaxVisibleValueCount(60)
        this.model.setPinchZoom(false)
        this.model.setDrawGridBackground(false)

        this.xAxis = this.model.getXAxis()
        if (let Some(x) <- this.xAxis) {
            x.setEnabled(false) //X轴是否显示
            x.setPosition(XAxisPosition.TOP)
            x.setDrawGridLines(true) //纵向线格显示
            x.setGranularity(1.0)
            x.setLabelCount(6, false) //设置X轴坐标个数
            x.setAxisMinimum(0.0)
            x.setAxisMaximum(40.0) //设置X轴最大值
        }

        this.leftAxis = this.model.getAxisLeft()
        if (let Some(l) <- this.leftAxis) {
            l.setLabelCount(6, false)
            l.setDrawGridLines(false)
            l.setPosition(YAxisLabelPosition.OUTSIDE_CHART)
            l.setAxisMinimum(-250.0)
            l.setAxisMaximum(900.0)
            l.setDrawAxisLine(true)
        }

        this.rightAxis = this.model.getAxisRight()
        if (let Some(r) <- this.rightAxis) {
            r.setDrawGridLines(false)
            r.setLabelCount(6, false)
            r.setAxisMinimum(-250.0) // this replaces setStartAtZero(true)
            r.setAxisMaximum(900.0)
            r.setDrawAxisLine(true)
            r.setDrawLabels(false)
        }

        let legend: ?Legend = this.model.getLegend()
        if (let Some(l) <- legend) {
            l.setEnabled(false)
        }

        this.setData(100, 60.0)

        this.model.setMinOffset(15.0)
        this.model.setVisibleXRangeMaximum(50.0)
        return this.model
    }

    func build() {
        Column {
            LineChart(model: aboutToAppear())
        }.width(100.percent).height(70.percent).backgroundColor(Color.WHITE)
    }
}
