/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.pie

public class PieHighlighter <: PieRadarHighlighter<PieChartModel, PieData, IPieDataSet, PiEntry> {
    var pieChartModel: PieChartModel
    public init(chart: PieChartModel) {
        super(chart)
        this.pieChartModel = chart
    }

    public func getClosestHighlight(index: Int64, x: Float64, y: Float64): Highlight {
        let chartData: ChartData<IPieDataSet, PiEntry> = (this.pieChartModel.getData() as ChartData<IPieDataSet, PiEntry>)()

        let set: PieDataSet = ((chartData as PieData)().getDataSet() as PieDataSet)()

        let entry: EntryOhos = set.getEntryForIndex(index)()

        return Highlight(Float64(index), y: entry.getY(), xPx: x, yPx: y, axis: set.getAxisDependency())

    }
}
