/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package ohos_app_cangjie_entry.scrollingCharts.viewPageItems

import ohos.state_macro_manage.*

@Entry
@Component
public class FragSimpleScatterIndex {
    var minOffset: Float64 = 15.0
    var XLimtLine: LimitLine = LimitLine(35.0, "Index 10")
    var legendScatter: LegendEntry = LegendEntry()
    var legendColorWidth: Float64 = 10.0
    var legendColorHeight: Float64 = 10.0
    var legendArr: Array<Array<LegendEntry>> = [[], [], []]
    var dataScatter: ScatterData = ScatterData()
    @State
    var scatterChartModel: ScatterChartModel = ScatterChartModel.build()

    func build() {
        Column() {
            Column() {
                Stack(Alignment.TopStart) {
                    ScatterChart(model: this.scatterChartModel)
                }.width(100.percent).height(70.percent)
            }
        }.alignItems(HorizontalAlign.Start)
    }

    protected override func aboutToAppear() {
        this.dataScatter = this.generateScatterData(6, 10000.0, 20)
        this.scatterChartModel.setData(this.dataScatter)
        let xAxis = this.scatterChartModel.getXAxis()
        if (let Some(xAxis) <- xAxis) {
            xAxis.setLabelCount(7, false)
            xAxis.setPosition(XAxisPosition.TOP)
            xAxis.setAxisMinimum(0.0)
            xAxis.setAxisMaximum(this.dataScatter.getXMax())
            xAxis.enableGridDashedLine(10, 10)
            xAxis.setDrawAxisLine(false)
            xAxis.setDrawLabels(false)
            xAxis.setDrawGridLines(true)
        }

        let leftAxis = this.scatterChartModel.getAxisLeft()
        if (let Some(leftAxis) <- leftAxis) {
            leftAxis.setLabelCount(6, false)
            leftAxis.setPosition(YAxisLabelPosition.OUTSIDE_CHART)
            leftAxis.setSpaceTop(15.0)
            leftAxis.setAxisMinimum(this.dataScatter.getYMin() - 500.0)
            leftAxis.setAxisMaximum(this.dataScatter.getYMax() + 1000.0)
            leftAxis.setDrawGridLines(true)
            leftAxis.enableGridDashedLine(10, 10)
            leftAxis.setDrawLabels(true)
        }

        let rightAxis = this.scatterChartModel.getAxisRight()
        if (let Some(rightAxis) <- rightAxis) {
            rightAxis.setDrawGridLines(false)
            rightAxis.setLabelCount(6, false)
            rightAxis.setSpaceTop(15.0)
            rightAxis.setAxisMinimum(this.dataScatter.getYMin() - 500.0) // this replaces setStartAtZero(true)
            rightAxis.setAxisMaximum(this.dataScatter.getYMax() + 1000.0)
            rightAxis.setDrawAxisLine(true)
            rightAxis.setDrawLabels(true)
        }
    }

    /**
     * 初始化数据
     * @param count  曲线图点的个数
     * @param range  y轴范围
     */
    private func generateScatterData(dataSets: Int64, range: Float64, count: Int64): ScatterData {
        let sets: ArrayList<IScatterDataSet> = ArrayList<IScatterDataSet>()
        let shapes = [ChartShape.SQUARE, ChartShape.CIRCLE, ChartShape.TRIANGLE, ChartShape.CROSS, ChartShape.X,
        ChartShape.CHEVRON_UP, ChartShape.CHEVRON_DOWN]

        for (i in 0..dataSets) {
            let entries: ArrayList<EntryOhos> = ArrayList<EntryOhos>()

            for (j in 0..count) {
                entries.add(EntryOhos(Float64(j), Random().nextFloat64() * range + range / 5.0))
            }
            let ds: ScatterDataSet = ScatterDataSet(entries, this.mLabels[i])
            ds.setScatterShape(shapes[i % shapes.size])
            ds.setColorsByArr([0xc12552, 0xff6600, 0xf5c700, 0x6a961f, 0xb36435])
            ds.setScatterShapeSize(9.0)
            ds.setDrawValues(false)
            ds.setIconsOffset(MPPointF(0.0, 0.0))
            sets.add(ds)
        }
        return ScatterData(sets)
    }

    private var mLabels: Array<String> = ["Company A", "Company B", "Company C", "Company D", "Company E", "Company F"]
}
