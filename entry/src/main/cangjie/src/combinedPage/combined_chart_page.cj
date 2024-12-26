/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package ohos_app_cangjie_entry.combinedPage

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*

@Entry
@Component
class CombinedChartPage {
    private var model: CombinedChartModel = CombinedChartModel.build()
    var combinedData: ?CombinedData = None
    var count: Int64 = 12

    protected override func aboutToAppear() {
        this.model.getDescription().setEnabled(false)

        let l = this.model.getLegend()
        if (let Some(l) <- l) {
            l.setEnabled(true)
            l.setWordWrapEnabled(true)
            l.setHorizontalAlignment(LegendHorizontalAlignment.LEFT)
            l.setVerticalAlignment(LegendVerticalAlignment.BOTTOM)
            l.setDrawInside(false)
            l.setYOffset(-10.0)
            l.setOrientation(LegendOrientation.HORIZONTAL)
        }

        this.model.setMaxVisibleValueCount(60)
        this.model.setDrawGridBackground(false)

        let xAxis: ?XAxis = this.model.getXAxis()
        if (let Some(xAxis) <- xAxis) {
            xAxis.setPosition(XAxisPosition.BOTTOM)
            xAxis.setDrawGridLines(false)
            xAxis.setLabelCount(7, false)
            xAxis.setAxisMinimum(0.0)
        }

        let leftAxis: ?YAxis = this.model.getAxisLeft()
        if (let Some(leftAxis) <- leftAxis) {
            leftAxis.setLabelCount(8, false)
            leftAxis.setPosition(YAxisLabelPosition.OUTSIDE_CHART)
            leftAxis.setSpaceTop(15.0)
            leftAxis.setAxisMinimum(0.0)
        }

        let rightAxis: ?YAxis = this.model.getAxisRight()
        if (let Some(rightAxis) <- rightAxis) {
            rightAxis.setLabelCount(8, false)
            rightAxis.setDrawGridLines(false)
            rightAxis.setSpaceTop(15.0)
            rightAxis.setAxisMinimum(0.0)
        }

        let data: CombinedData = CombinedData()
        this.generateLineData(data)
        this.generateWaterfallData(data)
        this.generateBubbleData(data)
        this.generateScatterData(data)
        this.generateCandleData(data)
        this.generateBarData(data)
        this.model.setData(data)
        this.model.invalidate()
    }

    private func generateLineData(data: CombinedData): Unit {
        let d: LineData = LineData()

        var entries: ArrayList<EntryOhos> = ArrayList()

        for (index in 0..this.count) {
            entries.append(EntryOhos(Float64(index) + 0.5, this.getRandom(15.0, 5.0)))
        }

        let set: LineDataSet = LineDataSet(entries, "Line DataSet")
        set.setColorByColor(0xca4443)
        set.setLineWidth(2.5)
        set.setCircleColor(0xca4443)
        set.setCircleRadius(3.0)
        set.setMode(Mode.LINEAR)
        set.setDrawValues(true)
        set.setValueTextSize(8.0)
        set.setValueTextColor(0xca4443)
        set.setAxisDependency(AxisDependency.LEFT)
        d.addDataSet(set)
        data.setLineData(d)
    }

    private func generateWaterfallData(data: CombinedData): Unit {
        var values: ArrayList<WaterfallEntry> = ArrayList<WaterfallEntry>()

        for (i in 0..this.count - 1) {
            values.append(WaterfallEntry(Float64(i) + 0.5, 35.0, 50.0))
        }

        let dataSet = WaterfallDataSet(values, "Waterfall")
        dataSet.setDrawIcons(false)
        dataSet.setColorByColor(UInt32(ColorTemplate.COLORFUL_COLORS[0]))
        dataSet.setValueTextSize(8.0)
        dataSet.setDrawValues(true)

        let dataSetList: ArrayList<IWaterfallDataSet> = ArrayList<IWaterfallDataSet>()
        dataSetList.append(dataSet)

        let waterfallData: WaterfallData = WaterfallData(dataSetList)
        waterfallData.setBarWidth(0.6)
        data.setWaterfallData(waterfallData)
    }

    private func generateBarData(data: CombinedData): Unit {
        var entries1: ArrayList<BarEntry> = ArrayList()
        var entries2: ArrayList<BarEntry> = ArrayList()

        for (index in 0..this.count) {
            entries1.append(BarEntry(0.0, this.getRandom(10.0, 6.0)))

            // stacked
            entries2.append(BarEntry(0.0, [this.getRandom(10.0, 6.0), this.getRandom(10.0, 6.0)]))
        }

        let set1: BarDataSet = BarDataSet(entries1, "Bar 1")
        set1.setColorByAlpha(0x328fb8, 200.0)
        set1.setValueTextColor(0x328fb8)
        set1.setValueTextSize(8.0)
        set1.setAxisDependency(AxisDependency.LEFT)
        set1.setDrawValues(true)

        let set2: BarDataSet = BarDataSet(entries2, "")
        set2.setStackLabels(["Stack 1", "Stack 2"])
        set2.setColorsByArrAndAlpha([0x219ea4, 0x46dcc1], 200.0)
        set2.setValueTextColor(0x219ea4)
        set2.setValueTextSize(8.0)
        set2.setAxisDependency(AxisDependency.LEFT)
        set2.setDrawValues(true)

        let groupSpace = 0.06
        let barSpace = 0.02 // x2 dataset
        let barWidth = 0.45 // x2 dataset

        let set: ArrayList<IBarDataSet> = ArrayList()
        set.append(set1)
        set.append(set2)
        let d: BarData = BarData(set)
        d.setBarWidth(barWidth)

        // make this BarData object grouped
        d.groupBars(0.0, groupSpace, barSpace) // start at x = 0
        data.setBarData(d)
    }

    private func generateScatterData(data: CombinedData): Unit {
        let d: ScatterData = ScatterData()

        var entries: ArrayList<EntryOhos> = ArrayList<EntryOhos>()

        for (index in 0..this.count) {
            entries.append(EntryOhos(Float64(index) + 0.25, this.getRandom(10.0, 55.0)))
        }

        let set: ScatterDataSet = ScatterDataSet(entries, "Scatter DataSet")
        set.setColorsByArr([0x2ecc71, 0xf1c40f, 0xe74c3c, 0x3498db])
        set.setScatterShapeSize(7.5)
        set.setDrawValues(true)
        set.setValueTextSize(10.0)
        d.addDataSet(set)
        data.setScatterData(d)
    }

    private func generateCandleData(data: CombinedData): Unit {
        let d: CandleData = CandleData()

        var entries: ArrayList<CandleEntry> = ArrayList()

        for (index in 0..this.count : 2) {
            entries.append(CandleEntry(Float64(index + 1), shadowH: 90.0, shadowL: 70.0, open: 85.0, close: 75.0))
        }

        let set: CandleDataSet = CandleDataSet(entries, "Candle DataSet")
        set.setDecreasingColor(0x4f506c)
        set.setShadowColor(ColorTemplate.DKGRAY)
        set.setBarSpace(0.3)
        set.setValueTextSize(10.0)
        set.setDrawValues(true)
        d.addDataSet(set)
        data.setCandleData(d)
    }

    private func generateBubbleData(data: CombinedData): Unit {
        let bd: BubbleData = BubbleData()

        let entries: ArrayList<BubblesEntry> = ArrayList<BubblesEntry>()

        for (index in 0..this.count) {
            let y = this.getRandom(10.0, 105.0)
            let size = this.getRandom(20.0, 30.0)
            entries.append(BubblesEntry(Float64(index) + 0.5, y, size: size))
        }

        let set: BubbleDataSet = BubbleDataSet(entries, "Bubble DataSet")
        set.setColorsByArr(
            [UInt32(ChartColor.rgb(192, 255, 140)), UInt32(ChartColor.rgb(255, 247, 140)),
        UInt32(ChartColor.rgb(255, 208, 140)), UInt32(ChartColor.rgb(140, 234, 255)),
        UInt32(ChartColor.rgb(255, 140, 157))])
        set.setValueTextSize(8.0)
        set.setValueTextColor(0xffffff)
        set.setDrawValues(true)
        bd.addDataSet(set)
        data.setBubbleData(bd)
    }

    func getRandom(range: Float64, start: Float64): Float64 {
        return (Random().nextFloat64() * range) + start
    }

    func build() {
        Column() {
            CombinedChart(model: this.model)
        }.width(100.percent).height(70.percent).backgroundColor(Color.WHITE)

    }
}
