/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package ohos_app_cangjie_entry.linePage
import ohos.state_macro_manage.*

@Entry
@Component
class MultiplePage {
    private var model: LineChartModel = LineChartModel.build()
    var topAxis: XAxis = XAxis() //顶部X轴
    var bottomAxis: XAxis = XAxis() //底部X轴
    var mWidth: Float64 = 350.0 //表的宽度
    var mHeight: Float64 = 300.0 //表的高度
    var minOffset: Float64 = 15.0
    var leftAxis: ?YAxis = None
    var rightAxis: ?YAxis = None
    var lineData: LineData = LineData()

    protected override func aboutToAppear(){
        let legend: ?Legend = this.model.getLegend()
        if (let Some(legend) <- legend) {
            legend.setEnabled(true)
            // 设置图例的位置
            legend.setVerticalAlignment(LegendVerticalAlignment.TOP)
            legend.setHorizontalAlignment(LegendHorizontalAlignment.CENTER)
            legend.setOrientation(LegendOrientation.HORIZONTAL)
            legend.setDrawInside(false)
        }

        this.model.setMinOffset(this.minOffset)
        this.model.setVisibleXRangeMaximum(5.0)
        this.lineData = this.setData(20, 100.0)
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
        set1.setDrawCircleHole(true)
        set1.setCircleColor(0xCCFF00)
        set1.setCircleRadius(4.0)
        set1.setCircleHoleRadius(2.0)
        set1.setMode(Mode.LINEAR)
        set1.setColorByColor(0x008000)
        set1.setLineWidth(2.5)
        set1.enableDashedLine(10, 10)
        dataSet.append(set1)

        let set2 = LineDataSet(values2, "DataSet 2")
        set2.setDrawFilled(false)
        set2.setDrawValues(true)
        set2.setDrawCircles(true)
        set2.setDrawCircleHole(true)
        set2.setCircleColor(0xCC00FF)
        set2.setCircleRadius(4.0)
        set2.setCircleHoleRadius(2.0)
        set2.setMode(Mode.LINEAR)
        set2.setColorByColor(0xFFA500)
        set2.setLineWidth(2.5)
        dataSet.append(set2)

        let set3 = LineDataSet(values3, "DataSet 3")
        set3.setDrawFilled(false)
        set3.setDrawValues(true)
        set3.setDrawCircles(true)
        set3.setDrawCircleHole(true)
        set3.setCircleColor(0x33FF33)
        set3.setCircleRadius(4.0)
        set3.setCircleHoleRadius(2.0)
        set3.setMode(Mode.LINEAR)
        set3.setColorByColor(0xFFFF00)
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
