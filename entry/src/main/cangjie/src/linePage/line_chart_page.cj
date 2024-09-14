/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package ohos_app_cangjie_entry.linePage
import ohos.state_macro_manage.*

class customFormatter <: IAxisValueFormatter {
    public func getFormattedValue(value: Float64, axis: AxisBase): String {
        if (Int64(value) % 2 == 0) {
            return value.toString() + value.toString() + value.toString()
        }
        return value.toString()
    }
}

@Entry
@Component
class LineChartPage {
    private var model: LineChartModel = LineChartModel.build()
    private var leftAxis: ?YAxis = Option<YAxis>.None
    private var rightAxis: ?YAxis = Option<YAxis>.None
    private var xAxis: ?XAxis = Option<XAxis>.None
    private var mCurrentMaxVisibleXCount: String = "20"
    private var mLastMaxVisibleXCount: String = "20"
    private var mBackgroundColor: UInt32 = 0x50000ff
    private var mLineWidth: String = "85"
    private var limitLine1: LimitLine = LimitLine(0.0, "")
    private var limitLine2: LimitLine = LimitLine(0.0, "")
    private var dataSet: LineDataSet = LineDataSet(ArrayList<EntryOhos>(EntryOhos(0.0, 0.0)), "")
    private var lineData: LineData = LineData()

    protected override func aboutToAppear() {
        let description: Description = this.model.getDescription()
        description.setEnabled(true)
        description.setText("this is line chart")

        let legend: ?Legend = this.model.getLegend()
        if (let Some(l) <- legend) {
            l.setEnabled(true)
        }

        this.model.setMaxVisibleValueCount(60)
        this.model.setDrawGridBackground(false)

        this.limitLine1 = LimitLine(120.0, "Upper Limit")
        this.limitLine1.setLineWidth(4.0)
        this.limitLine1.enableDashedLine(10, 10)
        this.limitLine1.setLabelPosition(LimitLabelPosition.RIGHT_TOP)
        this.limitLine1.setTextSize(10.0)

        this.limitLine2 = LimitLine(50.0, "Lower Limit")
        this.limitLine2.setLineWidth(4.0)
        this.limitLine2.enableDashedLine(10, 10)
        this.limitLine2.setLineColor(0xFFFF00)
        this.limitLine2.setLabelPosition(LimitLabelPosition.RIGHT_BOTTOM)
        this.limitLine2.setTextSize(10.0)

        this.xAxis = this.model.getXAxis()
        if (let Some(x) <- this.xAxis) {
            x.setPosition(XAxisPosition.BOTTOM)
            x.setDrawGridLines(false)
            x.setLabelCount(7, false)
            x.setValueFormatter(DefaultAxisValueFormatter(3))
        }

        this.leftAxis = this.model.getAxisLeft()
        if (let Some(ly) <- this.leftAxis) {
            ly.setLabelCount(8, false)
            ly.setPosition(YAxisLabelPosition.OUTSIDE_CHART)
            ly.setSpaceTop(15.0)
            ly.setAxisMinimum(0.0)
            ly.setAxisMaximum(200.0)
            ly.addLimitLine(this.limitLine1)
            ly.addLimitLine(this.limitLine2)
        }

        this.rightAxis = this.model.getAxisRight()
        if (let Some(ry) <- this.rightAxis) {
            ry.setLabelCount(8, false)
            ry.setDrawGridLines(false)
            ry.setSpaceTop(15.0)
            ry.setAxisMinimum(0.0)
            ry.setAxisMaximum(200.0)
            ry.setEnabled(false)
        }



        let lineData: LineData = this.getLineData()
        lineData.setValueTextSize(10.0)
        this.model.setData(lineData)
        this.model.setVisibleXRangeMaximum(7.0) //x 轴显示最大数量
    }

    private func getLineData(): LineData {
        let start: Int64 = 0
        let values: ArrayList<EntryOhos> = ArrayList<EntryOhos>()
        let val: Array<Float64> = [58.2, 103.8, 94.4, 162.0, 131.6, 33.3, 27.8, 114.4, 76.0, 81.8, 43.2]
        for (i in start..=10) {
            values.append(EntryOhos(Float64(i), val[i]))
        }

        this.dataSet = LineDataSet(values, "DataSet")
        this.dataSet.setDrawIcons(false)

        this.dataSet.setMode(Mode.LINEAR)
        this.dataSet.setDrawCircles(true) //折线点画圆圈
        this.dataSet.setDrawCircleHole(false) //设置内部孔
        this.dataSet.setColorByColor(0x000000) //设置折线颜色

        let gradientFillColor = ArrayList<ChartColorStop>()
        gradientFillColor.append((0x0C0099CC, 0.2))
        gradientFillColor.append((0x7F0099CC, 0.4))
        gradientFillColor.append((0x0099CC, 1.0))
        this.dataSet.setGradientFillColor(gradientFillColor) // 设置图表填充颜色
        this.dataSet.setDrawFilled(true)

        // 设置数据点的颜色
        this.dataSet.setCircleColor(0x0000FF) // 可以设置为你想要的颜色

        // 设置数据点的半径
        this.dataSet.setCircleRadius(4.0) // 设置半径大小
        this.dataSet.setCircleHoleRadius(2.0) //设置内径

        let dataSetList: ArrayList<ILineDataSet> = ArrayList<ILineDataSet>()
        dataSetList.append(this.dataSet)

        let lineData: LineData = LineData(dataSetList)
        return lineData
    }

    func build() {
        Column {
            LineChart(model: this.model)
        }.width(100.percent).height(70.percent).backgroundColor(Color.WHITE)
    }
}
