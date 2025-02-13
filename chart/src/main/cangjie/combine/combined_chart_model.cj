/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.combine

public class CombinedChartModel <: BarLineChartBaseModel<CombinedData, IBarLineScatterCandleBubbleDataSet<EntryOhos>,
    EntryOhos> & CombinedDataProvider {
    public var context2d: ?CanvasRenderingContext2D = None

    /**
     * if set to true, all values are drawn above their bars, instead of below
     * their top
     */
    private var mDrawValueAboveBar: Bool = true
    /**
     * flag that indicates whether the highlight should be full-bar oriented, or single-value?
     */
    protected var mHighlightFullBarEnabled: Bool = false
    /**
     * if set to true, a grey area is drawn behind each bar that indicates the
     * maximum value
     */
    private var mDrawBarShadow: Bool = false
    protected var mDrawOrder: Array<DrawOrder> = []

    init() {
        super()
        this.mDrawOrder = [DrawOrder.WATERFALL, DrawOrder.BAR, DrawOrder.BUBBLE, DrawOrder.LINE, DrawOrder.CANDLE,
            DrawOrder.SCATTER]
        //this.setHighlighter(CombinedHighlighter(this, this, this))
        //this.setHighlightFullBarEnabled(true)
    }

    public static func build(): CombinedChartModel {
        let model: CombinedChartModel = CombinedChartModel()

        model.mAnimator = ChartAnimator(model)
        if (let Some(mAnimator) <- model.mAnimator) {
            model.mRenderer = CombinedChartRenderer(model, mAnimator, model.mViewPortHandler)
        }

        return model
    }

    public func invalidate(): Unit {
        if (let Some(context2d) <- this.context2d) {
            super.onDraw(context2d)
        }
    }

    public func onChartSizeChanged(newWidth: Float64, newHeight: Float64, oldWidth: Float64, oldHeight: Float64) {
        super.onSizeChanged(newWidth, newHeight, oldWidth, oldHeight)
    }

    public func setContext2D(context2d: CanvasRenderingContext2D) {
        this.context2d = context2d
    }

    public func getCombinedData(): ?CombinedData {
        return this.mData
    }

    public func setData(data: ?CombinedData): Unit {
        super.setData(data)
        // this.setHighlighter(CombinedHighlighter(this, this, this))
        if (let Some(mRenderer: CombinedChartRenderer) <- this.mRenderer) {
            mRenderer.createRenderers()
            mRenderer.initBuffers()
        }
    }

    /**
     * Returns the Highlight object (contains x-index and DataSet index) of the selected value at the given touch
     * point
     * inside the CombinedChart.
     *
     * @param x
     * @param y
     * @return
     */
    public override func getHighlightByTouchPoint(x: Float64, y: Float64): ?Highlight {
        if (this.mData.isNone()) {
            AppLog.info("Can't select by touch. No data set.")
            return None
        } else {
            let highlighter = this.getHighlighter()
            if (highlighter.isNone()) {
                return None
            }
            let h: ?Highlight = highlighter().getHighlight(x, y)
            if (h.isNone() || !this.isHighlightFullBarEnabled()) {
                return h
            }

            // For isHighlightFullBarEnabled, remove stackIndex
            return Highlight(h().getX(), y: h().getY(), dataSetIndex: h().getDataSetIndex(),
                dataIndex: h().getDataIndex(), stackIndex: -1, xPx: h().getXPx(), yPx: h().getYPx(), axis: h().getAxis()
            )
        }
    }

    public func getLineData(): ?LineData {
        if (let Some(mData: CombinedData) <- this.mData) {
            return mData.getLineData()
        }
        return Option<LineData>.None
    }

    public func getBarData(): ?BarData {
        if (let Some(mData: CombinedData) <- this.mData) {
            return mData.getBarData()
        }
        return Option<BarData>.None
    }

    public func getScatterData(): ?ScatterData {
        if (let Some(mData: CombinedData) <- this.mData) {
            return mData.getScatterData()
        }
        return Option<ScatterData>.None
    }

    public func getCandleData(): ?CandleData {
        if (let Some(mData: CombinedData) <- this.mData) {
            return mData.getCandleData()
        }
        return Option<CandleData>.None
    }

    public func getBubbleData(): ?BubbleData {
        if (let Some(mData: CombinedData) <- this.mData) {
            return mData.getBubbleData()
        }
        return Option<BubbleData>.None
    }

    public func getWaterfallData(): ?WaterfallData {
        if (let Some(mData: CombinedData) <- this.mData) {
            return mData.getWaterfallData()
        }
        return Option<WaterfallData>.None
    }

    public func isDrawBarShadowEnabled(): Bool {
        return this.mDrawBarShadow
    }

    public func isDrawValueAboveBarEnabled(): Bool {
        return this.mDrawValueAboveBar
    }

    /**
     * If set to true, all values are drawn above their bars, instead of below
     * their top.
     *
     * @param enabled
     */
    public func setDrawValueAboveBar(enabled: Bool): Unit {
        this.mDrawValueAboveBar = enabled
    }

    /**
     * If set to true, a grey area is drawn behind each bar that indicates the
     * maximum value. Enabling his will reduce performance by about 50%.
     *
     * @param enabled
     */
    public func setDrawBarShadow(enabled: Bool): Unit {
        this.mDrawBarShadow = enabled
    }

    /**
     * Set this to true to make the highlight operation full-bar oriented,
     * false to make it highlight single values (relevant only for stacked).
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
     * Returns the currently set draw order.
     *
     * @return
     */
    public func getDrawOrder(): Array<DrawOrder> {
        return this.mDrawOrder
    }

    /**
     * Sets the order in which the provided data objects should be drawn. The
     * earlier you place them in the provided array, the further they will be in
     * the background. e.g. if you provide new DrawOrer[] { DrawOrder.BAR,
     * DrawOrder.LINE }, the bars will be drawn behind the lines.
     *
     * @param order
     */
    public func setDrawOrder(order: Array<DrawOrder>): Unit {
        if (order.size <= 0) {
            return
        }

        this.mDrawOrder = order
    }

    /**
     * draws all MarkerViews on the highlighted positions
     */
    protected func drawMarkers(canvas: CanvasRenderingContext2D): Unit {

        // if there is no marker view or drawing marker is disabled
        if (this.mMarker.isNone() || !this.isDrawMarkersEnabled() || !this.valuesToHighlight() ||
            this.mIndicesToHighlight.isNone()) {
            return
        }

        //TODO i: Float64 = 0
        for (i in 0..this.mIndicesToHighlight().size) {
            let highlight: ?Highlight = this.mIndicesToHighlight()[i]

            if (let Some(mData: CombinedData) <- this.mData) {
                let set: ?IBarLineScatterCandleBubbleDataSet<EntryOhos> = mData.getDataSetByHighlight(highlight())
                if (set.isNone()) {
                    continue
                }

                let e: ?EntryOhos = mData.getEntryForHighlight(highlight())
                if (e.isNone()) {
                    continue
                }

                let entryIndex: Float64 = Float64(set().getEntryIndexByEntry(e()))

                if (this.mAnimator.isNone()) {
                    continue
                }
                // make sure entry not null
                if (entryIndex > Float64(set().getEntryCount()) * this.mAnimator().getPhaseX()) {
                    continue
                }

                let pos: Array<Float64> = this.getMarkerPosition(highlight())

                // check bounds
                if (!this.mViewPortHandler.isInBounds(pos[0], pos[1])) {
                    continue
                }
                // draw the marker
                this.mMarker().draw(canvas, pos[0], pos[1], e(), highlight())
            } else {
                continue
            }
        }
    }
}
