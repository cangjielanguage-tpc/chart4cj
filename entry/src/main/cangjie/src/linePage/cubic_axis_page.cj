/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package ohos_app_cangjie_entry.linePage
import ohos.state_macro_manage.*

@Entry
@Component
class CubicAxisPage {
    private var model: LineChartModel = LineChartModel.build()
    private var leftAxis: ?YAxis = None
    private var rightAxis: ?YAxis = None
    private var xAxis: ?XAxis = None
    private var dataSet: LineDataSet = LineDataSet(ArrayList<EntryOhos>(), "")

    protected override func aboutToAppear() {
        let description: Description = this.model.getDescription()

        description.setEnabled(false)

        this.model.setDrawGridBackground(false)

        this.xAxis = this.model.getXAxis()
        if (let Some(xAxis) <- this.xAxis) {
            xAxis.setEnabled(false) //X轴是否显示
            xAxis.setPosition(XAxisPosition.TOP)
            xAxis.setDrawGridLines(true) //纵向线格显示
            xAxis.setLabelCount(6, false) //设置X轴坐标个数
        }

        this.leftAxis = this.model.getAxisLeft()
        if (let Some(leftAxis) <- this.leftAxis) {
            leftAxis.setLabelCount(7, false)
            leftAxis.setPosition(YAxisLabelPosition.OUTSIDE_CHART)
            leftAxis.setDrawGridLines(false)
            leftAxis.setDrawLabels(true)
            leftAxis.setTextColor(Color.WHITE)
            leftAxis.setAxisLineColor(Color.BLUE)
        }

        this.rightAxis = this.model.getAxisRight()
        if (let Some(rightAxis) <- this.rightAxis) {
            rightAxis.setDrawGridLines(false)
            rightAxis.setLabelCount(7, false)
            rightAxis.setDrawAxisLine(false)
            rightAxis.setDrawLabels(false)
        }

        let legend: ?Legend = this.model.getLegend()
        if (let Some(legend) <- legend) {
            legend.setEnabled(false)
        }

        this.setData(20, 100.0)
    }

    private func setData(count: Int64, range: Float64): Unit {
        let values: ArrayList<EntryOhos> = ArrayList<EntryOhos>()
        for (i in 1..count) { //X轴坐标个数
            // 设置数据点Y值
            let val = range * Random().nextFloat64() //Y轴值
            values.append(EntryOhos(Float64(i), val))
        }
        this.dataSet = LineDataSet(values, "DataSet 1")

        let gradientFillColor = ArrayList<ChartColorStop>()
        gradientFillColor.append((0xffffff, 0.3))
        gradientFillColor.append((0x00ffff, 1.0))
        this.dataSet.setGradientFillColor(gradientFillColor)
        this.dataSet.setDrawFilled(true) //是否显示阴影
        this.dataSet.setDrawValues(false)
        this.dataSet.setMode(Mode.CUBIC_BEZIER)
        this.dataSet.setColorByColor(0xffffff)
        this.dataSet.setLineWidth(1.0)
        this.dataSet.setDrawCircles(false)
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
