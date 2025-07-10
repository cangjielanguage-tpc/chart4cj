/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.bar

public open class BarHighlighter <: IHighlighter {
    protected var mChart: BarDataProvider
    protected var mHighlightBuffer: ArrayList<Highlight> = ArrayList<Highlight>()

    public init(chart: BarDataProvider) {
         this.mChart = chart
    }

    public open func getHighlight(x: Float64, y: Float64): ?Highlight {
        var pos: MPPointD = this.getValsForTouch(x, y)
        let xVal: Float64 = pos.x
        MPPointD.recycleInstance(pos)
        let high: ?Highlight = this.getHighlightForX(xVal, x, y)
        if (let Some(light) <- high) {
            pos = this.getValsForTouch(x, y)
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
            if (e.getYVals().size < 0) {
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

                        let stackedHigh: Highlight = Highlight(e.getX(), y: e.getY(), dataSetIndex: high.getDataSetIndex(), stackIndex: stackIndex,
                            xPx: pixels.x, yPx: pixels.y, axis: high.getAxis())

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

    protected open func getDistance(x1: Float64, y1: Float64, x2: Float64, y2: Float64): Float64 {
        let sum: Float64 = pow(x1-x2,2) + pow(y1-y2,2)
        return sqrt(sum)
    }

    protected func getData(): ?BarData {
        return this.mChart.getBarData()
    }

    protected func getValsForTouch(x: Float64, y: Float64): MPPointD {
        let transformer: ?Transformer = this.mChart.getTransformer(AxisDependency.LEFT)
        var pos: MPPointD = MPPointD.getInstance(0.0, 0.0)
        match (transformer) {
            case None => ()
            case Some(t) => pos = t.getValuesByTouchPoint(x, y, Option<MPPointD>.None)
        }

        return pos
    }

    protected func getHighlightForX(xVal: Float64, x: Float64, y: Float64): ?Highlight {
        let closestValues: ArrayList<Highlight> = this.getHighlightsAtXValue(xVal, x, y)

        if (closestValues.isEmpty()) {
            return None
        }

        let leftAxisMinDist: Float64 = this.getMinimumDistance(closestValues, y, AxisDependency.LEFT)
        let rightAxisMinDist: Float64 = this.getMinimumDistance(closestValues, y, AxisDependency.RIGHT)

        var axis: AxisDependency = AxisDependency.LEFT
        if (leftAxisMinDist == Float64.Max) {
            axis = AxisDependency.RIGHT
        } else if (rightAxisMinDist == Float64.Max) {
            axis = AxisDependency.LEFT
        } else {
            axis = if (leftAxisMinDist < rightAxisMinDist) {
                AxisDependency.LEFT
            } else {
                AxisDependency.RIGHT
            }
        }

        let detail: ?Highlight = this.getClosestHighlightByPixel(closestValues, x, y, axis,
            this.mChart.getMaxHighlightDistance())

        return detail
    }

    protected func getHighlightsAtXValue(xVal: Float64, x: Float64, y: Float64): ArrayList<Highlight> {
        this.mHighlightBuffer.clear()

        let data: ?BarData = this.mChart.getBarData()
        if (let Some(d) <- data) {
            let dataSetCount: Int64 = d.getDataSetCount()
            for (i in 0..dataSetCount) {
                let dataSet: ?IBarDataSet = d.getDataSetByIndex(i)
                if(let Some(s) <- dataSet) {
                    if(!dataSet().isHighlightEnabled()) {
                       continue
                    }
                }
                this.mHighlightBuffer.add(all: this.buildHighlights(dataSet(), i, xVal, Rounding.CLOSEST))
            }
        }

        return this.mHighlightBuffer
    }

    protected open func buildHighlights(set: IBarDataSet, dataSetIndex: Int64, xVal: Float64, rounding: Rounding): ArrayList<Highlight> {
        let highlights: ArrayList<Highlight> = ArrayList<Highlight>()

        //noinspection unchecked
        var entries: ArrayList<BarEntry> = set.getEntriesForXValue(xVal)

        if (entries.size == 0) {
            // Try to find closest x-value and take all entries for that x-value
            let closest: ?BarEntry = set.getEntryForXValue(xVal, Float64.NaN, rounding: rounding)
            if ( let Some(c) <- closest) {
                //noinspection unchecked
                entries = set.getEntriesForXValue(c.getX())
            }
        }

        if (entries.size == 0) {
            return highlights
        }

        for (e in entries) {
            let axisObj: AxisDependency = set.getAxisDependency()

            let transformer: ?Transformer = this.mChart.getTransformer(axisObj)
            var pixels: MPPointD = MPPointD.getInstance(0.0, 0.0)
            if (let Some(t) <- transformer) {
                pixels = t.getPixelForValues(e.getX(), e.getY())
            }

            highlights.add(Highlight(e.getX(), y: e.getY(), dataSetIndex: dataSetIndex, dataIndex: 0, stackIndex: 0, xPx: pixels.x, yPx: pixels.y, axis: axisObj))
            MPPointD.recycleInstance(pixels)
        }

        return highlights
    }

    public func getClosestHighlightByPixel(closestValues: ArrayList<Highlight>, x: Float64, y: Float64,
        axis: ?AxisDependency, minSelectionDistance: Float64): ?Highlight {
        var closest: ?Highlight = None
        var distance: Float64 = minSelectionDistance

        for (i in 0..closestValues.size) {
            let high: Highlight = closestValues[i]

            if (axis.isNone() || high.getAxis()() == axis()) {
                var cDistance: Float64 = 0.0
                if ((this.mChart.getBarData())().isHighlightByXDistance()) {
                    cDistance = abs(x - high.getXPx())
                } else {
                    cDistance = this.getDistance(x, y, high.getXPx(), high.getYPx())
                }

                if (cDistance < distance) {
                    closest = high
                    distance = cDistance
                }
            }
        }

        return closest
    }

    protected func getMinimumDistance(closestValues: ArrayList<Highlight>, pos: Float64, axis: AxisDependency): Float64 {
        var distance: Float64 = Float64.Max

        for (i in 0..closestValues.size) {
            let high: ?Highlight = closestValues.get(i)
            match (high) {
                case None => ()
                case Some(h) => if (h.getAxis()() == axis) {
                    let tempDistance: Float64 = abs(this.getHighlightPos(h) - pos)
                    if (tempDistance < distance) {
                        distance = tempDistance
                    }
                }
            }
        }

        return distance
    }

    protected func getHighlightPos(h: Highlight): Float64 {
        return h.getYPx()
    }

}
