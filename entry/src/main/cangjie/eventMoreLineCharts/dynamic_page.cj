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
class DynamicPage {
    private var leftAxis: ?YAxis = None
    private var rightAxis: ?YAxis = None
    private var topAxis: ?XAxis = None
    private var bottomAxis: ?XAxis = None
    @State
    var lineData: LineData = LineData()
    private var mWidth = 300.0
    private var mHeight = 300.0
    @State
    var flag: Int64 = 0
    private var colors: Array<Int64> = ColorTemplate.VORDIPLOM_COLORS
    private var index: Int64 = 0
    @State
    var lineChartModel: LineChartModel = LineChartModel.build()

    protected override func aboutToAppear() {
        let topAxis = this.lineChartModel.getXAxis()
        if (let Some(topAxis) <- topAxis) {
            topAxis.setLabelCount(5, false)
            topAxis.setAxisMinimum(0.0)
            topAxis.setAxisMaximum(50.0)
            topAxis.setDrawAxisLine(false)
            topAxis.setDrawLabels(true)
            topAxis.setDrawGridLines(true)
        }

        let leftAxis = this.lineChartModel.getAxisLeft()
        if (let Some(leftAxis) <- leftAxis) {
            leftAxis.setLabelCount(6, false)
            leftAxis.setDrawGridLines(true)
            leftAxis.setPosition(YAxisLabelPosition.OUTSIDE_CHART)
            leftAxis.setAxisMinimum(0.0)
            leftAxis.setAxisMaximum(50.0)
        }

        let rightAxis = this.lineChartModel.getAxisRight()
        if (let Some(rightAxis) <- rightAxis) {
            rightAxis.setDrawGridLines(true)
            rightAxis.setLabelCount(6, false)
            rightAxis.setAxisMinimum(0.0)
            rightAxis.setAxisMaximum(50.0)
        }
        this.lineChartModel.setData(this.lineData)
    }

    private var values: ArrayList<EntryOhos> = ArrayList<EntryOhos>()

    private func initCurveData(count: Int64, range: Float64): LineData {
        this.values.append(EntryOhos(Float64(count), range))
        let dataSet = ArrayList<ILineDataSet>()
        let set1 = LineDataSet(this.values, "DataSet 1")
        set1.setDrawFilled(false)
        set1.setDrawValues(true)
        set1.setDrawCircles(true)
        set1.setDrawCircleHole(true)
        set1.setCircleRadius(4.0)
        set1.setCircleHoleRadius(2.0)
        set1.setCircleHoleColor(0xffffff)
        set1.setCircleColor(UInt32(ColorTemplate.colorRgb(140, 234, 255)))
        set1.setMode(Mode.LINEAR)
        set1.setColorByColor(UInt32(ColorTemplate.colorRgb(140, 234, 255)))
        set1.setLineWidth(1.5)
        dataSet.append(set1)
        return LineData(dataSet)
    }

    func build() {
        Column {
            Flex(FlexParams(alignItems: ItemAlign.Center, wrap: FlexWrap.Wrap)) {
                Button("Add Entry").backgroundColor(0x317aff).onClick({
                    => this.addEntry()
                }).stateEffect(true).shape(ShapeType.Capsule)
//                Button("RemoveLastEntry").backgroundColor(0x317aff).onClick({
//                    => this.removeLastEntry()
//                }).stateEffect(true).shape(ShapeType.Capsule)
//                Button("AddDataSet").backgroundColor(0x317aff).onClick({
//                    => this.addDataSet()
//                }).stateEffect(true).shape(ShapeType.Capsule)
//                Button("RemoveDataSet").backgroundColor(0x317aff).onClick({
//                    => this.removeDataSet()
//                }).stateEffect(true).shape(ShapeType.Capsule)
                Button("Clear").backgroundColor(0x317aff).onClick({
                    => this.clear()
                }).stateEffect(true).shape(ShapeType.Capsule)
            }

            if (this.flag == 0) {
                Text("No chart data available. Use the menu to add entries and data sets!").width(100.percent).height(
                    100.percent)
            } else {
                LineChart(model: this.lineChartModel)
            }
        }.width(100.percent).height(70.percent).backgroundColor(Color.WHITE)
    }

    func addEntry() {
        if (this.flag != 1) {
            this.flag = 1
        }
        this.index = this.index + 1
        this.lineChartModel.setData(this.initCurveData(this.index, Random().nextFloat64() * 50.0))
    }

    func removeLastEntry() {
        let set: ?ILineDataSet = this.lineData.getDataSetByIndex(0)
        if (set.isSome()) {
            let e: ?EntryOhos = set().getEntryForXValue(Float64(set().getEntryCount() - 1), Float64.NaN,
                rounding: Rounding.CLOSEST)
            if (e.isSome()) {
                this.lineData.removeEntry(e(), 0)
            }
        }
    }

    func addDataSet() {
        let count: Int64 = this.lineData.getDataSetCount() + 1

        let dataSetByIndex = this.lineData.getDataSetByIndex(0)
        if (dataSetByIndex.isSome()) {
            let amount: Int64 = dataSetByIndex().getEntryCount()

            let values: ArrayList<EntryOhos> = ArrayList<EntryOhos>()

            for (i in 0..amount) {
                values.append(EntryOhos(Float64(i), (Random().nextFloat64() * 50.0) + 50.0 * Float64(count)))
            }

            let dataSet: LineDataSet = LineDataSet(values, "DataSet${count}")

            dataSet.setLineWidth(2.5)
            dataSet.setCircleRadius(4.5)

            let color: UInt32 = UInt32(this.colors[count % this.colors.size])

            dataSet.setColorByColor(color)
            dataSet.setCircleColor(color)
            dataSet.setHighLightColor(color)
            dataSet.setValueTextSize(10.0)
            dataSet.setValueTextColor(color)

            this.lineData.addDataSet(dataSet)
            this.lineData.notifyDataChanged()
        }

        this.flag = 1
    }

    func removeDataSet() {
        let dataSet = this.lineData.getDataSetByIndex(this.lineData.getDataSetCount() - 1)
        if (dataSet.isSome()) {
            this.lineData.removeDataSet(dataSet())
        }
    }

    func clear() {
        this.lineData.clearValues()
        this.flag = 0
    }

    func createSet(): LineDataSet {
        let values = ArrayList<EntryOhos>()

        for (i in 0..10) {
            let yVal: Float64 = (Random().nextFloat64() * 50.0)
            values.append(EntryOhos(Float64(i), yVal))
        }
        let set1: LineDataSet = LineDataSet(values, "DataSet 1")

        set1.setDrawFilled(false)
        set1.setDrawValues(true)
        set1.setDrawCircles(true)
        set1.setDrawCircleHole(true)
        set1.setCircleRadius(4.0)
        set1.setCircleHoleRadius(2.0)
        set1.setCircleHoleColor(0xffffff)
        set1.setCircleColor(UInt32(ColorTemplate.colorRgb(140, 234, 255)))
        set1.setMode(Mode.LINEAR)
        set1.setColorByColor(UInt32(ColorTemplate.colorRgb(140, 234, 255)))
        set1.setLineWidth(2.5)
        return set1
    }
}
