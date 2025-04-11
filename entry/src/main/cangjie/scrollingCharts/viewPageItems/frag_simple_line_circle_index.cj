/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package ohos_app_cangjie_entry.scrollingCharts.viewPageItems

//import ohos.base.*
//import ohos.component.*
//import ohos.state_manage.*

import tpc.UIKit.*
import ohos.state_macro_manage.*
import chart.pie.*
import chart.utils.*
import chart.components.*
import chart.charts.*
import chart.line.*
import std.collection.{ArrayList}
import std.format.*
import ohos_app_cangjie_entry.scrollingCharts.data.*

@Component
public  class fragSimpleLineCircleIndex {
    var topAxis: XAxis = XAxis() //顶部X轴
    var bottomAxis: XAxis = XAxis() //底部X轴
    var mWidth: Float64 = 380.0 //表的宽度
    var mHeight: Float64 = 600.0 //表的高度
    var minOffset: Float64 = 15.0
    var leftAxis: ?YAxis = None
    var rightAxis: ?YAxis = None
    var lineData: LineData = LineData()
    var legendArr: Array<LegendEntry> = []
    @State
    var lineChartModel: LineChartModel = LineChartModel.build()

    var pageInfo: NavPathStack = NavPathStack()

    func build() {
        NavDestination() {
            Column() {
            Stack(Alignment.TopStart) {
                LineChart(model: this.lineChartModel)
            }.width(100.percent).height(80.percent)
        }.alignItems(HorizontalAlign.Start)
        }.onReady({
            context => pageInfo = context.pathStack
        }).onBackPressed({
            => false
        })
    }

    protected override func aboutToAppear() {
        this.lineData = this.initCurveData(45, 100.0)
        this.lineChartModel.setData(this.lineData)
        let leftAxis = this.lineChartModel.getAxisLeft()
        if (let Some(leftAxis) <- leftAxis) {
            leftAxis.setLabelCount(7, false)
            leftAxis.setAxisMinimum(this.lineData.getYMin())
            leftAxis.setAxisMaximum(this.lineData.getYMax() + 10.0)
            leftAxis.setDrawGridLines(true)
            leftAxis.setDrawAxisLine(true)
            leftAxis.setDrawLabels(true)
            leftAxis.setSpaceTop(15.0)
            leftAxis.setAxisLineColor(Color(0x80333333))

        }

        let rightAxis = this.lineChartModel.getAxisRight()
        if (let Some(rightAxis) <- rightAxis) {
            rightAxis.setDrawGridLines(false)
            rightAxis.setAxisMinimum(this.lineData.getYMin()) // this replaces setStartAtZero(true)
            rightAxis.setAxisMaximum(this.lineData.getYMax())
            rightAxis.setDrawAxisLine(false)
            rightAxis.setDrawLabels(false)
        }
    }

    /**
     * 初始化数据
     * @param count  曲线图点的个数
     * @param range  y轴范围
     */
    private func initCurveData(count: Int64, range: Float64): LineData {
        let valuesN = ArrayList<EntryOhos>()
        let n: Array<Float64> = N().data
        for (i in 0..n.size) {
            valuesN.append(EntryOhos(Float64(i), n[i]))
        }

        let valuesNlogn = ArrayList<EntryOhos>()
        let nlogn: Array<Float64> = Nlogn().data
        for (i in 0..nlogn.size) {
            valuesNlogn.append(EntryOhos(Float64(i), nlogn[i]))
        }

        let valuesSquare = ArrayList<EntryOhos>()
        let square: Array<Float64> = Square().data
        for (i in 0..square.size) {
            valuesSquare.append(EntryOhos(Float64(i), square[i]))
        }

        let valuesThree = ArrayList<EntryOhos>()
        let three: Array<Float64> = Three().data
        for (i in 0..three.size) {
            valuesThree.append(EntryOhos(Float64(i), three[i]))
        }

        let dataSet = ArrayList<ILineDataSet>()

        let set1 = LineDataSet(valuesN, "O(n)")
        set1.setDrawFilled(false)
        set1.setDrawValues(false)
        set1.setDrawCircles(true)
        set1.setDrawCircleHole(true)
        set1.setCircleColor(0xc0ff8c)
        set1.setCircleRadius(3.0)
        set1.setCircleHoleRadius(2.0)
        set1.setMode(Mode.LINEAR)
        set1.setColorByColor(0xc0ff8c)
        set1.setLineWidth(2.5)

        let set2 = LineDataSet(valuesNlogn, "O(nlogn)")
        set2.setDrawFilled(false)
        set2.setDrawValues(false)
        set2.setDrawCircles(true)
        set2.setDrawCircleHole(true)
        set2.setCircleColor(0xfff78c)
        set2.setCircleRadius(3.0)
        set2.setCircleHoleRadius(2.0)
        set2.setMode(Mode.LINEAR)
        set2.setColorByColor(0xfff78c)
        set2.setLineWidth(2.5)

        let set3 = LineDataSet(valuesSquare, "O(n²)")
        set3.setDrawFilled(false)
        set3.setDrawValues(false)
        set3.setDrawCircles(true)
        set3.setDrawCircleHole(true)
        set3.setCircleColor(0xffd068)
        set3.setCircleRadius(3.0)
        set3.setCircleHoleRadius(2.0)
        set3.setMode(Mode.LINEAR)
        set3.setColorByColor(0xffd068)
        set3.setLineWidth(2.5)

        let set4 = LineDataSet(valuesThree, "O(n³)")
        set4.setDrawFilled(false)
        set4.setDrawValues(false)
        set4.setDrawCircles(true)
        set4.setDrawCircleHole(true)
        set4.setCircleColor(0x8ceaff)
        set4.setCircleRadius(3.0)
        set4.setCircleHoleRadius(2.0)
        set4.setMode(Mode.LINEAR)
        set4.setColorByColor(0x8ceaff)
        set4.setLineWidth(2.5)

        dataSet.append(set1)
        dataSet.append(set2)
        dataSet.append(set3)
        dataSet.append(set4)

        return LineData(dataSet)
    }

    private func getFormattedValue(value: Float64): String {
        return value.format(".1")
    }
}
