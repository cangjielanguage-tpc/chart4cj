/**
 * Created on 2024/5/10
 */
package core.pie

public open class ChartHighlighter<P, S, E> <: IHighlighter where P <: BarLineScatterCandleBubbleDataProvider<S, E>,
    S <: IDataSet<E>, E <: EntryOhos {
    /**
     * instance of the data-provider
     */
    protected var mChart: P
    /**
     * buffer for storing previously highlighted values
     */
    protected var mHighlightBuffer: ArrayList<Highlight> = ArrayList<Highlight>()

    public init(chart: P) {
        this.mChart = chart
    }

    public open func getHighlight(x: Float64, y: Float64): ?Highlight {
        let pos: MPPointD = this.getValsForTouch(x, y)
        let xVal: Float64 = pos.x
        MPPointD.recycleInstance(pos)

        let high: Highlight = this.getHighlightForX(xVal, x, y)()
        return high
    }

    /**
     * Returns a recyclable MPPointD instance.
     * Returns the corresponding xPos for a given touch-position in pixels.
     *
     * @param x
     * @param y
     * @return
     */
    protected func getValsForTouch(x: Float64, y: Float64): MPPointD {

        // take any transformer to determine the x-axis value
        let transformer: ?Transformer = this.mChart.getTransformer(AxisDependency.LEFT)
        var pos: MPPointD = MPPointD.getInstance(0.0, 0.0)
        match (transformer) {
            case None => ()
            case Some(t) => pos = t.getValuesByTouchPoint(x, y, Option<MPPointD>.None)
        }

        return pos
    }

    /**
     * Returns the corresponding Highlight for a given xVal and x- and y-touch position in pixels.
     *
     * @param xVal
     * @param x
     * @param y
     * @return
     */
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

    /**
     * Returns the minimum distance from a touch value (in pixels) to the
     * closest value (in pixels) that is displayed in the chart.
     *
     * @param closestValues
     * @param pos
     * @param axis
     * @return
     */
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

    /**
     * Returns a list of Highlight objects representing the entries closest to the given xVal.
     * The returned list contains two objects per DataSet (closest rounding up, closest rounding down).
     *
     * @param xVal the transformed x-value of the x-touch position
     * @param x    touch position
     * @param y    touch position
     * @return
     */
    protected func getHighlightsAtXValue(xVal: Float64, x: Float64, y: Float64): ArrayList<Highlight> {
        this.mHighlightBuffer.clear()

        let data: ?BarLineScatterCandleBubbleData<IBarLineScatterCandleBubbleDataSet<EntryOhos>, EntryOhos> = this.
            getDatas()
        if (let Some(d) <- data) {
            let dataSetCount: Int64 = d.getDataSetCount()
            for (i in 0..dataSetCount) {
                let dataSet: ?IBarLineScatterCandleBubbleDataSet<EntryOhos> = d.getDataSetByIndex(i)
                if(let Some(s) <- dataSet) {
                    if(!dataSet().isHighlightEnabled()) {
                       continue
                    }
                }
                this.mHighlightBuffer.appendAll(this.buildHighlights(dataSet(), i, xVal, Rounding.CLOSEST))
            }
        }

        return this.mHighlightBuffer
    }

    /**
     * An array of `Highlight` objects corresponding to the selected xValue and dataSetIndex.
     *
     * @param set
     * @param dataSetIndex
     * @param xVal
     * @param rounding
     * @return
     */
    protected func buildHighlights(set: IDataSet<EntryOhos>, dataSetIndex: Int64, xVal: Float64, rounding: Rounding): ArrayList<Highlight> {
        let highlights: ArrayList<Highlight> = ArrayList<Highlight>()

        //noinspection unchecked
        var entries: ArrayList<EntryOhos> = set.getEntriesForXValue(xVal)

        if (entries.size == 0) {
            // Try to find closest x-value and take all entries for that x-value
            let closest: ?EntryOhos = set.getEntryForXValue(xVal, Float64.NaN, rounding: rounding)
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

            highlights.append(Highlight(e.getX(), e.getY(), dataSetIndex, 0, 0, pixels.x, pixels.y, axisObj))
        }

        return highlights
    }

    /**
     * Returns the Highlight of the DataSet that contains the closest value on the
     * y-axis.
     *
     * @param closestValues        contains two Highlight objects per DataSet closest to the selected x-position (determined by
     *                             rounding up an down)
     * @param x
     * @param y
     * @param axis                 the closest axis
     * @param minSelectionDistance
     * @return
     */
    public func getClosestHighlightByPixel(closestValues: ArrayList<Highlight>, x: Float64, y: Float64,
        axis: ?AxisDependency, minSelectionDistance: Float64): ?Highlight {
        var closest: ?Highlight = None
        var distance: Float64 = minSelectionDistance

        for (i in 0..closestValues.size) {
            let high: Highlight = closestValues[i]

            if (axis.isNone() || high.getAxis()() == axis()) {
                var cDistance: Float64 = 0.0
                if (this.mChart.getData()().isHighlightByXDistance()) {
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

    /**
     * Calculates the distance between the two given points.
     *
     * @param x1
     * @param y1
     * @param x2
     * @param y2
     * @return
     */
    protected open func getDistance(x1: Float64, y1: Float64, x2: Float64, y2: Float64): Float64 {
        let sun: Float64 = pow(x1 - x2, 2) + pow(y1 - y2, 2)
        return sqrt(sun)
    }

    protected func getDatas(): ?BarLineScatterCandleBubbleData<IBarLineScatterCandleBubbleDataSet<EntryOhos>,
                                           EntryOhos> {
        if(let Some(d: BarLineScatterCandleBubbleData<IBarLineScatterCandleBubbleDataSet<EntryOhos>,EntryOhos>) <- this.mChart.getData()) {
            return  d
        }
       return None
    }
}
