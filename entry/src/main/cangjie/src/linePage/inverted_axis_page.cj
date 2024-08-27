/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package ohos_app_cangjie_entry.linePage
import ohos.state_macro_manage.*

@Entry
@Component
class InvertedAxisPage {
    private var model: LineChartModel = LineChartModel.build()
    private var leftAxis: ?YAxis = None
    private var rightAxis: ?YAxis = None
    private var xAxis: ?XAxis = None
    private var dataSet: LineDataSet = LineDataSet(ArrayList<EntryOhos>(), "")

    protected override func aboutToAppear() {
        let description: Description = this.model.getDescription()
        description.setEnabled(false)

        this.model.setMaxVisibleValueCount(60)
        this.model.setPinchZoom(false)
        this.model.setDrawGridBackground(false)

        this.xAxis = this.model.getXAxis()
        if (let Some(x) <- this.xAxis) {
            x.setPosition(XAxisPosition.TOP)
            x.setDrawGridLines(true) //纵向线格显示
            x.setGranularity(1.0) //放大时轴设置的最小间隔，轴不允许低于该限制。这可用于在放大时避免标签复制。
            x.setLabelCount(6, false) //设置X轴坐标个数
        }

        this.leftAxis = this.model.getAxisLeft()
        if (let Some(l) <- this.leftAxis) {
            l.setLabelCount(6, false)
            l.setDrawGridLines(true)
            l.setPosition(YAxisLabelPosition.OUTSIDE_CHART)
            l.setDrawAxisLine(true)
            l.setInverted(true)
        }

        this.rightAxis = this.model.getAxisRight()
        if (let Some(r) <- this.rightAxis) {
            r.setEnabled(false) //右Y轴是否显示
            r.setDrawGridLines(false)
            r.setLabelCount(6, false)
            r.setDrawAxisLine(false)
            r.setDrawLabels(false)
        }

        let legend: ?Legend = this.model.getLegend()
        if (let Some(legend) <- legend) {
            legend.setEnabled(false)
        }

        this.setData(40, 125.0)
    }

    private func setData(count: Int64, range: Float64): Unit {
        let values: ArrayList<EntryOhos> = ArrayList<EntryOhos>()
        for (i in 1..count) { //X轴坐标个数
            // 设置数据点Y值
            let val = Random().nextFloat64() * range //Y轴值
            values.append(EntryOhos(Float64(i), val))
        }

        this.dataSet = LineDataSet(values, "DataSet 1")
        // this.dataSet.setDrawFilled(true)//是否显示阴影
        // this.dataSet.setDrawValues(true)
        this.dataSet.setMode(Mode.LINEAR)
        this.dataSet.setColorByColor(0xff000000)
        this.dataSet.setLineWidth(1.5)
        this.dataSet.setDrawCircles(true)
        this.dataSet.setCircleColor(0x3333FF) //设置圆环颜色
        this.dataSet.setCircleRadius(4.0)
        this.dataSet.setCircleHoleRadius(2.0)
        this.dataSet.setCircleHoleColor(0xffffff)
        this.dataSet.setDrawCircleHole(true)

        let dataSetList: ArrayList<ILineDataSet> = ArrayList<ILineDataSet>()
        dataSetList.append(this.dataSet)

        let lineData: LineData = LineData(dataSetList)
        lineData.setValueTextSize(10.0)

        this.model.setData(lineData)
    }

    func build() {
        Column {
            LineChart(model: this.model)
        }.width(100.percent).height(70.percent).backgroundColor(Color.WHITE)
    }
}
