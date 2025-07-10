/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.bar

public class HorizontalBarHighlighter <: BarHighlighter {
    public init(chart: BarDataProvider) {
        super(chart)
    }

    public func getHighlight(x: Float64, y: Float64): ?Highlight {
        let barData: ?BarData = this.mChart.getBarData()
        if (barData.isNone()) {
            return Option<Highlight>.None
        }

        let pos: MPPointD = this.getValsForTouch(y, x)

        let high: ?Highlight = this.getHighlightForX(pos.y, y, x)
        if (high.isNone()) {
            return Option<Highlight>.None
        }

        let set: ?IBarDataSet = barData().getDataSetByIndex(high().getDataSetIndex())
        if (set.isSome() && set().isStacked()) {
            return this.getStackedHighlight(high(),set(),pos.y,pos.x)
        }

        MPPointD.recycleInstance(pos)

        return high
    }

    protected func buildHighlights(set: IDataSet<EntryOhos>, dataSetIndex: Int64, xVal: Float64, rounding: Rounding): ArrayList<Highlight> {
        let highlights: ArrayList<Highlight> = ArrayList<Highlight>()

        var entries: ArrayList<EntryOhos> = set.getEntriesForXValue(xVal)
        if (entries.size == 0) {
            let closest: ?EntryOhos = set.getEntryForXValue(xVal, Float64.NaN, rounding: rounding)
            if (closest.isSome()) {
                entries = set.getEntriesForXValue(closest().getX())
            }
        }

        if (entries.size == 0) {
            return highlights
        }

        for (i in 0..entries.size) {
            let e = entries[i]

            let trans = this.mChart.getTransformer(set.getAxisDependency())
            if (trans.isNone()) {
                continue
            }
            let pixels: MPPointD = trans().getPixelForValues(e.getY(), e.getX())

            highlights.add(Highlight(e.getX(), y: e.getY(), dataSetIndex: dataSetIndex, dataIndex: 0, xPx: pixels.x, yPx: pixels.y,
                axis: set.getAxisDependency()))
        }

        return highlights
    }

    public func getDistance(x1: Float64, y1: Float64, x2: Float64, y2: Float64): Float64 {
        return abs(y1 - y2)
    }
}
