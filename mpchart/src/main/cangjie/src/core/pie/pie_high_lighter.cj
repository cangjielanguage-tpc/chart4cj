/**
 * Created on 2024/5/13
 */
package core.pie

public class PieHighlighter <: PieRadarHighlighter<PieChartModel, PieData, IPieDataSet, PiEntry> {
    var pieChartModel: PieChartModel
    public init(chart: PieChartModel) {
        super(chart)
        this.pieChartModel = chart
    }

    public func getClosestHighlight(index: Int64, x: Float64, y: Float64): Highlight {
        let chartData: ChartData<IPieDataSet, PiEntry> = this.pieChartModel.getData()()

        let set: PieDataSet = ((chartData as PieData)().getDataSet() as PieDataSet)()

        let entry: EntryOhos = set.getEntryForIndex(index)

        return Highlight(Float64(index), entry.getY(), 0, -1, 0, x, y, set.getAxisDependency())

        return Highlight(0.0, 0.0, 0, 0, 0, 0.0, 0.0, Option<AxisDependency>.None)
    }
}
