/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package mpchart.bar

public open class BarChartModel <: BarLineChartBaseModel<BarData, IBarDataSet, BarEntry> & BarDataProvider {
    public var context2d: ?CanvasRenderingContext2D = None

    /**
     * flag that indicates whether the highlight should be full-bar oriented, or single-value?
     */
    protected var mHighlightFullBarEnabled: Bool = false
    /**
     * if set to true, all values are drawn above their bars, instead of below their top
     */
    private var mDrawValueAboveBar: Bool = true
    /**
     * if set to true, a grey area is drawn behind each bar that indicates the maximum value
     */
    private var mDrawBarShadow: Bool = false
    private var mFitBars: Bool = false

    private var mMinAngleForSlices: Float64 = 0.0

    init() {
        super()
    }

    public static func build(): BarChartModel {
        let model: BarChartModel = BarChartModel()
        model.mAnimator = ChartAnimator(model)
        model.mRenderer = BarChartRenderer(model, model.mAnimator(), model.mViewPortHandler)

        model.setHighlighter(BarHighlighter(model))

        let xAxis: ?XAxis = model.getXAxis()
        if (let Some(xaxis) <- xAxis) {
            xaxis.setSpaceMin(0.5)
            xaxis.setSpaceMax(0.5)
        }

        return model
    }

    public func invalidate(): Unit {
        if (let Some(context2d) <- this.context2d) {
            super.onDraw(context2d)
        }
    }

    public func setContext2D(context2d: CanvasRenderingContext2D) {
        this.context2d = context2d
    }

    public func onChartSizeChanged(newWidth: Float64, newHeight: Float64, oldWidth: Float64, oldHeight: Float64) {
        super.onSizeChanged(newWidth, newHeight, oldWidth, oldHeight)
    }

    public func onDraw(c: CanvasRenderingContext2D): Unit {
        super.onDraw(c)
    }
    protected func calcMinMax(): Unit {
        match (this.mData) {
            case Some(data: BarData) =>
                if (let Some(xaxis) <- this.mXAxis) {
                    if (this.mFitBars) {
                        xaxis.calculate(
                            data.getXMin() - data.getBarWidth() / 2.0,
                            data.getXMax() + data.getBarWidth() / 2.0
                        )
                    } else {
                        xaxis.calculate(data.getXMin(), data.getXMax())
                    }
                }
                // calculate axis range (min / max) according to provided data
                if (let Some(axisLeft) <- this.mAxisLeft) {
                    axisLeft.calculate(data.getYMin(AxisDependency.LEFT), data.getYMax(AxisDependency.LEFT))
                }
                if (let Some(axisReft) <- this.mAxisRight) {
                    axisReft.calculate(data.getYMin(AxisDependency.RIGHT), data.getYMax(AxisDependency.RIGHT))
                }
            case _ => return
        }
    }

    /**
     * Returns the Highlight object (contains x-index and DataSet index) of the selected value at the given touch
     * point
     * inside the BarChart.
     *
     * @param x
     * @param y
     * @return
     */
    public open func getHighlightByTouchPoint(x: Float64, y: Float64): ?Highlight {
        if (this.mData.isNone()) {
            AppLog.error("mpchart: Can't select by touch. No data set.")
            return None
        } else {
            let highLighter: ?IHighlighter = this.getHighlighter()
            if (let Some(lighter) <- highLighter) {
                let h: ?Highlight = lighter.getHighlight(x, y)
                if (let Some(hh) <- h) {
                    if (!this.isHighlightFullBarEnabled()) {
                        return None
                    }
                    return Highlight(hh.getX(), y: hh.getY(), dataSetIndex: hh.getDataSetIndex(), dataIndex: 0,
                        stackIndex: -1, xPx: hh.getXPx(), yPx: hh.getYPx(), axis: hh.getAxis())
                } else {
                    return None
                }
            } else {
                return None
            }
        }
    }

    /**
     * Returns the bounding box of the specified Entry in the specified DataSet. Returns null if the Entry could not be
     * found in the charts data.  Performance-intensive code should use void getBarBounds(BarEntry, RectF) instead.
     *
     * @param e
     * @return
     */
    public func getBarBoundsByEntry(e: BarEntry): MyRect {
        let bounds: MyRect = MyRect()
        this.getBarBounds(e, bounds)

        return bounds
    }

    /**
     * The passed outputRect will be assigned the values of the bounding box of the specified Entry in the specified DataSet.
     * The rect will be assigned Float.MIN_VALUE in all locations if the Entry could not be found in the charts data.
     *
     * @param e
     * @return
     */
    public open func getBarBounds(e: BarEntry, outputRect: MyRect): Unit {
        match (this.mData) {
            case Some(data: BarData) =>
                let bounds: MyRect = outputRect

                match (data.getDataSetForEntry(e)) {
                    case Some(set: IBarDataSet) =>
                        let y: Float64 = e.getY()
                        let x: Float64 = e.getX()

                        let barWidth: Float64 = data.getBarWidth()

                        let left: Float64 = x - barWidth / 2.0
                        let right: Float64 = x + barWidth / 2.0
                        let top: Float64 = if (y >= 0.0) {
                            y
                        } else {
                            0.0
                        }
                        let bottom: Float64 = if (y <= 0.0) {
                            y
                        } else {
                            0.0
                        }

                        bounds.set(left, top, right, bottom)

                        let transformer: ?Transformer = this.getTransformer(set.getAxisDependency())
                        if (let Some(t) <- transformer) {
                            t.rectValueToPixel(outputRect)
                        }
                    case None =>
                        bounds.set(Float64.Min, Float64.Min, Float64.Min, Float64.Min)
                        return
                }
            case _ => return
        }
    }

    /**
     * If set to true, all values are drawn above their bars, instead of below their top.
     *
     * @param enabled
     */
    public func setDrawValueAboveBar(enabled: Bool): Unit {
        this.mDrawValueAboveBar = enabled
    }

    /**
     * returns true if drawing values above bars is enabled, false if not
     *
     * @return
     */
    public func isDrawValueAboveBarEnabled(): Bool {
        return this.mDrawValueAboveBar
    }

    /**
     * If set to true, a grey area is drawn behind each bar that indicates the maximum value. Enabling his will reduce
     * performance by about 50%.
     *
     * @param enabled
     */
    public func setDrawBarShadow(enabled: Bool): Unit {
        this.mDrawBarShadow = enabled
    }

    /**
     * returns true if drawing shadows (maxvalue) for each bar is enabled, false if not
     *
     * @return
     */
    public func isDrawBarShadowEnabled(): Bool {
        return this.mDrawBarShadow
    }

    /**
     * Set this to true to make the highlight operation full-bar oriented, false to make it highlight single values (relevant
     * only for stacked). If enabled, highlighting operations will highlight the whole bar, even if only a single stack entry
     * was tapped.
     * Default: false
     *
     * @param enabled
     */
    public func setHighlightFullBarEnabled(enabled: Bool): Unit {
        this.mHighlightFullBarEnabled = enabled
    }

    /**
     * @return true the highlight operation is be full-bar oriented, false if single-value
     */
    public func isHighlightFullBarEnabled(): Bool {
        return this.mHighlightFullBarEnabled
    }

    /**
     * Highlights the value at the given x-value in the given DataSet. Provide
     * -1 as the dataSetIndex to undo all highlighting.
     *
     * @param x
     * @param dataSetIndex
     * @param stackIndex   the index inside the stack - only relevant for stacked entries
     */
    public func highlightValue(x: Float64, dataSetIndex: Int64, stackIndex: Int64): Unit {
        this.highlightValueForObject(
            Highlight(x, y: 0.0, dataSetIndex: dataSetIndex, stackIndex: stackIndex, axis: Option<AxisDependency>.None),
            false
        )
    }

    public func getBarData(): ?BarData {
        return match (this.mData) {
            case Some(d: BarData) => d
            case _ => None
        }
    }

    /**
     * Adds half of the bar width to each side of the x-axis range in order to allow the bars of the barchart to be
     * fully displayed.
     * Default: false
     *
     * @param enabled
     */
    public func setFitBars(enabled: Bool): Unit {
        this.mFitBars = enabled
    }

    /**
     * Groups all BarDataSet objects this data object holds together by modifying the x-value of their entries.
     * Previously set x-values of entries will be overwritten. Leaves space between bars and groups as specified
     * by the parameters.
     * Calls notifyDataSetChanged() afterwards.
     *
     * @param fromX      the starting point on the x-axis where the grouping should begin
     * @param groupSpace the space between groups of bars in values (not pixels) e.g. 0.8f for bar width 1f
     * @param barSpace   the space between individual bars in values (not pixels) e.g. 0.1f for bar width 1f
     */
    public func groupBars(fromX: Float64, groupSpace: Float64, barSpace: Float64): Unit {
        if (this.getBarData().isNone()) {
            throw Exception("You need to set data for the chart before grouping bars.")
        } else {
            let barData: ?BarData = this.getBarData()
            if (let Some(data) <- barData) {
                data.groupBars(fromX, groupSpace, barSpace)
            }
            this.notifyDataSetChanged()
        }
    }
}
