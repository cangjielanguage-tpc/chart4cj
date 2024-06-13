/**
 * Created on 2024/5/31
 */
package core.bar

public class BarHighlighter <: ChartHighlighter<BarDataProvider, IBarDataSet, BarEntry> {
    public init(chart: BarDataProvider) {
        super(chart)
    }

    public func getHighlight(x: Float64, y: Float64): ?Highlight {
        let high: ?Highlight = super.getHighlight(x, y)
        if (let Some(light) <- high) {
            let pos: MPPointD = super.getValsForTouch(x, y)
            let barData: ?BarData = this.mChart.getBarData()
            if (let Some(bar) <- barData) {
                let set: ?IBarDataSet = bar.getDataSetByIndex(light.getDataSetIndex())
                if (let Some(s) <- set) {
                    if (s.isStacked()) {
                        return this.getStackedHighlight(light, s, pos.x, pos.y)
                    }
                }

                MPPointD.recycleInstance(pos)

                return high
            } else {
                return None
            }
        } else {
            None
        }
    }

    /**
     * This method creates the Highlight object that also indicates which value of a stacked BarEntry has been
     * selected.
     *
     * @param high the Highlight to work with looking for stacked values
     * @param set
     * @param xVal
     * @param yVal
     * @return
     */
    public func getStackedHighlight(high: Highlight, set: IBarDataSet, xVal: Float64, yVal: Float64): ?Highlight {
        let entry: ?BarEntry = set.getEntryForXValue(xVal, yVal, rounding: Rounding.CLOSEST)
        if (let Some(e) <- entry) {
            if (e.getYVals().isNone()) {
                return high
            } else {
                let ranges: ?Array<RangeChart> = e.getRanges()
                if (let Some(range) <- ranges) {
                    if (range.size > 0) {
                        let stackIndex: Int64 = this.getClosestStackIndex(range, yVal)

                        var pixels: MPPointD = MPPointD.getInstance(0.0, 0.0)
                        let transformer: ?Transformer = this.mChart.getTransformer(set.getAxisDependency())
                        if (let Some(t) <- transformer) {
                            pixels = t.getPixelForValues(high.getX(), range[stackIndex].to)
                        }

                        let stackedHigh: Highlight = Highlight(e.getX(), e.getY(), high.getDataSetIndex(), 0, stackIndex,
                            pixels.x, pixels.y, high.getAxis())

                        MPPointD.recycleInstance(pixels)

                        return stackedHigh
                    }
                    return None
                } else {
                    return None
                }
            }
        } else {
            return None
        }
    }

    /**
     * Returns the index of the closest value inside the values array / ranges (stacked barchart) to the value
     * given as
     * a parameter.
     *
     * @param ranges
     * @param value
     * @return
     */
    protected func getClosestStackIndex(ranges: Array<RangeChart>, value: Float64): Int64 {
        if (ranges.size == 0) {
            return 0
        }

        var stackIndex: Int64 = 0

        for (range in ranges) {
            if (range.contains(value)) {
                return stackIndex
            } else {
                stackIndex++
            }
        }

        let length: Int64 = max(ranges.size - 1, 0)

        return if (value > ranges[length].to) {
            length
        } else {
            0
        }
    }

    protected func getDistance(x1: Float64, y1: Float64, x2: Float64, y2: Float64): Float64 {
        return abs(x1 - x2)
    }

    protected func getData(): ?BarLineScatterCandleBubbleData<IBarLineScatterCandleBubbleDataSet<EntryOhos>, EntryOhos> {
        return this.mChart.getBarData() as BarLineScatterCandleBubbleData<IBarLineScatterCandleBubbleDataSet<EntryOhos>,
            EntryOhos>
    }
}
