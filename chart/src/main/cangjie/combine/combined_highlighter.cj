/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.combine

public open class CombinedHighlighter <: IHighlighter {
    protected var mChart: CombinedDataProvider
    protected var mHighlightBuffer: ArrayList<Highlight> = ArrayList<Highlight>()

    public init(chart: CombinedDataProvider) {
         this.mChart = chart
    }

    public open func getHighlight(x: Float64, y: Float64): ?Highlight {
        var pos: MPPointD = this.getValsForTouch(x, y)
        let xVal: Float64 = pos.x
        MPPointD.recycleInstance(pos)
        let high: ?Highlight = this.getHighlightForX(xVal, x, y)
        return high
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

        let detail: ?Highlight = this.getClosestHighlightByPixel(closestValues, x, y, axis, this.mChart.getMaxHighlightDistance())

        return detail
    }


    protected open func getDistance(x1: Float64, y1: Float64, x2: Float64, y2: Float64): Float64 {
        let sum: Float64 = pow(x1-x2,2) + pow(y1-y2,2)
        return sqrt(sum)
    }

    protected func getData(): ?CombinedData {
        return this.mChart.getCombinedData()
    }



    protected func getHighlightsAtXValue(xVal: Float64, x: Float64, y: Float64): ArrayList<Highlight> {
        this.mHighlightBuffer.clear()

        let combinedData: ?CombinedData = this.mChart.getCombinedData()
        if (let Some(d) <- combinedData) {
            let dataObjects: ArrayList<ChartDataWrapper> = d.getAllData()
            for(i in 0..dataObjects.size) {
                let dataObject: ?ChartDataWrapper = dataObjects.get(i)
                match(dataObject) {
                    case Some(bubbledata: CombinedChartDataWrapper<IBubbleDataSet, BubblesEntry>) =>
                        let data = bubbledata.inner
                        let dataSetCount = data.getDataSetCount()
                        for(j in 0..dataSetCount) {
                            let dataSet: ?IBubbleDataSet = data.getDataSetByIndex(j)
                            if(dataSet.isNone() || !dataSet().isHighlightEnabled()) {
                                continue
                            }
                            let highs: ArrayList<Highlight> = this.buildHighlights(dataSet(), j, xVal, Rounding.CLOSEST)
                            for(j in 0..highs.size) {
                                let high: ?Highlight = highs.get(j)
                                if(let Some(h) <- high) {
                                    h.setDataIndex(i)
                                    this.mHighlightBuffer.add(h)
                                }

                            }

                      }
                    case Some(scatterdata: CombinedChartDataWrapper<IScatterDataSet, EntryOhos>) =>
                        let data = scatterdata.inner
                        let dataSetCount = data.getDataSetCount()
                        for(j in 0..dataSetCount) {
                            let dataSet: ?IScatterDataSet = data.getDataSetByIndex(j)
                            if(dataSet.isNone() || !dataSet().isHighlightEnabled()) {
                                continue
                            }
                            let highs: ArrayList<Highlight> = this.buildHighlights(dataSet(), j, xVal, Rounding.CLOSEST)
                            for(j in 0..highs.size) {
                                let high: ?Highlight = highs.get(j)
                                if(let Some(h) <- high) {
                                    h.setDataIndex(i)
                                    this.mHighlightBuffer.add(h)
                                }

                            }
                      }
                    case Some(linedata: CombinedChartDataWrapper<ILineDataSet, EntryOhos>) =>
                        let data = linedata.inner
                        let dataSetCount = data.getDataSetCount()
                        for(j in 0..dataSetCount) {
                            let dataSet: ?ILineDataSet = data.getDataSetByIndex(j)
                            if(dataSet.isNone() || !dataSet().isHighlightEnabled()) {
                                continue
                            }
                            let highs: ArrayList<Highlight> = this.buildHighlights(dataSet(), j, xVal, Rounding.CLOSEST)
                            for(j in 0..highs.size) {
                                let high: ?Highlight = highs.get(j)
                                if(let Some(h) <- high) {
                                    h.setDataIndex(i)
                                    this.mHighlightBuffer.add(h)
                                }

                            }
                      }
                    case Some(waterfalldata: CombinedChartDataWrapper<IWaterfallDataSet, WaterfallEntry>) =>
                        let data = waterfalldata.inner
                        let dataSetCount = data.getDataSetCount()
                        for(j in 0..dataSetCount) {
                            let dataSet: ?IWaterfallDataSet = data.getDataSetByIndex(j)
                            if(dataSet.isNone() || !dataSet().isHighlightEnabled()) {
                                continue
                            }
                            let highs: ArrayList<Highlight> = this.buildHighlights(dataSet(), j, xVal, Rounding.CLOSEST)
                            for(j in 0..highs.size) {
                                let high: ?Highlight = highs.get(j)
                                if(let Some(h) <- high) {
                                    h.setDataIndex(i)
                                    this.mHighlightBuffer.add(h)
                                }

                            }
                      }
                    case Some(candledata: CombinedChartDataWrapper<ICandleDataSet, CandleEntry>) =>
                        let data = candledata.inner
                        let dataSetCount = data.getDataSetCount()
                        for(j in 0..dataSetCount) {
                            let dataSet: ?ICandleDataSet = data.getDataSetByIndex(j)
                            if(dataSet.isNone() || !dataSet().isHighlightEnabled()) {
                                continue
                            }
                            let highs: ArrayList<Highlight> = this.buildHighlights(dataSet(), j, xVal, Rounding.CLOSEST)
                            for(j in 0..highs.size) {
                                let high: ?Highlight = highs.get(j)
                                if(let Some(h) <- high) {
                                    h.setDataIndex(i)
                                    this.mHighlightBuffer.add(h)
                                }

                            }
                      }
                    case Some(bardata: CombinedChartDataWrapper<IBarDataSet, BarEntry>) =>
                        let data = bardata.inner
                        let dataSetCount = data.getDataSetCount()
                        for(j in 0..dataSetCount) {
                            let dataSet: ?IBarDataSet = data.getDataSetByIndex(j)
                            if(dataSet.isNone() || !dataSet().isHighlightEnabled()) {
                                continue
                            }
                            let highs: ArrayList<Highlight> = this.buildHighlights(dataSet(), j, xVal, Rounding.CLOSEST)
                            for(j in 0..highs.size) {
                                let high: ?Highlight = highs.get(j)
                                if(let Some(h) <- high) {
                                    h.setDataIndex(i)
                                    this.mHighlightBuffer.add(h)
                                }

                            }
                      }

                    case _=> return this.mHighlightBuffer
                }
            }
        } else {
            return ArrayList<Highlight>()
        }

        return this.mHighlightBuffer
    }

    protected func buildHighlights(set: IBubbleDataSet, dataSetIndex: Int64, xVal: Float64, rounding: Rounding): ArrayList<Highlight> {
        let highlights: ArrayList<Highlight> = ArrayList<Highlight>()

        var entries: ArrayList<BubblesEntry> = set.getEntriesForXValue(xVal)

        if (entries.size == 0) {
            let closest: ?BubblesEntry = set.getEntryForXValue(xVal, Float64.NaN, rounding: rounding)
            if ( let Some(c) <- closest) {
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
        }

        return highlights
    }

    protected open func buildHighlights(set: IBarDataSet, dataSetIndex: Int64, xVal: Float64, rounding: Rounding): ArrayList<Highlight> {
        let highlights: ArrayList<Highlight> = ArrayList<Highlight>()

        var entries: ArrayList<BarEntry> = set.getEntriesForXValue(xVal)
        if (entries.size == 0) {
            let closest: ?BarEntry = set.getEntryForXValue(xVal, Float64.NaN, rounding: rounding)
            if ( let Some(c) <- closest) {
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

    protected open func buildHighlights(set: ICandleDataSet, dataSetIndex: Int64, xVal: Float64, rounding: Rounding): ArrayList<Highlight> {
        let highlights: ArrayList<Highlight> = ArrayList<Highlight>()

        //noinspection unchecked
        var entries: ArrayList<CandleEntry> = set.getEntriesForXValue(xVal)

        if (entries.size == 0) {
            // Try to find closest x-value and take all entries for that x-value
            let closest: ?CandleEntry = set.getEntryForXValue(xVal, Float64.NaN, rounding: rounding)
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
        }

        return highlights
    }

    protected open func buildHighlights(set: ILineDataSet, dataSetIndex: Int64, xVal: Float64, rounding: Rounding): ArrayList<Highlight> {
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

            highlights.add(Highlight(e.getX(), y: e.getY(), dataSetIndex: dataSetIndex, dataIndex: 0, stackIndex: 0, xPx: pixels.x, yPx: pixels.y, axis: axisObj))
        }

        return highlights
    }
    protected open func buildHighlights(set: IScatterDataSet, dataSetIndex: Int64, xVal: Float64, rounding: Rounding): ArrayList<Highlight> {
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

            highlights.add(Highlight(e.getX(), y: e.getY(), dataSetIndex: dataSetIndex, dataIndex: 0, stackIndex: 0, xPx: pixels.x, yPx: pixels.y, axis: axisObj))
        }

        return highlights
    }

    protected open func buildHighlights(set: IWaterfallDataSet, dataSetIndex: Int64, xVal: Float64, rounding: Rounding): ArrayList<Highlight> {
        let highlights: ArrayList<Highlight> = ArrayList<Highlight>()

        //noinspection unchecked
        var entries: ArrayList<WaterfallEntry> = set.getEntriesForXValue(xVal)
        if (entries.size == 0) {
            // Try to find closest x-value and take all entries for that x-value
            let closest: ?WaterfallEntry = set.getEntryForXValue(xVal, Float64.NaN, rounding: rounding)
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
                if ((this.mChart.getCombinedData())().isHighlightByXDistance()) {
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