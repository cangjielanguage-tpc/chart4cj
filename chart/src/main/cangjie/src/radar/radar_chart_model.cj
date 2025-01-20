/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.radar

public class RadarChartModel <: PieRadarChartBaseModel<RadarData, IRadarDataSet, RadarEntry> {
    public var context2d: ?CanvasRenderingContext2D = None

    /**
     * width of the main web lines
     */
    private var mWebLineWidth: Float64 = 2.5
    /**
     * width of the inner web lines
     */
    private var mInnerWebLineWidth: Float64 = 1.5
    /**
     * color for the main web lines
     */
    private var mWebColor: UInt32 = UInt32(ChartColor.rgb(122, 122, 122))
    /**
     * color for the inner web
     */
    private var mWebColorInner: UInt32 = UInt32(ChartColor.rgb(122, 122, 122))
    /**
     * transparency the grid is drawn with (0-255)
     */
    private var mWebAlpha: Float64 = 150.0
    /**
     * flag indicating if the web lines should be drawn or not
     */
    private var mDrawWeb: Bool = true
    /**
     * modulus that determines how many labels and web-lines are skipped before the next is drawn
     */
    private var mSkipWebLineCount: Int64 = 0
    /**
     * the object representing the y-axis labels
     */
    private var mYAxis: YAxis = YAxis(AxisDependency.LEFT)
    protected var mYAxisRenderer: ?YAxisRendererRadarChart = None
    protected var mXAxisRenderer: ?XAxisRendererRadarChart = None

    init() {
        super()
        this.mYAxis = YAxis(AxisDependency.LEFT)
        this.mYAxis.setLabelXOffset(10.0)

        this.mWebLineWidth = Utils.handleDataValues(1.5)
        this.mInnerWebLineWidth = Utils.handleDataValues(0.75)
    }
    public static func build(): RadarChartModel {
        let model: RadarChartModel = RadarChartModel()
        let lister: ChartTouchListener<RadarData, IRadarDataSet, RadarEntry> = PieRadarChartTouchListener<RadarData, IRadarDataSet, RadarEntry>(
            model)
        model.mChartTouchListener = lister
        model.mAnimator = ChartAnimator(model)
        model.mRenderer = RadarChartRenderer(model, model.mAnimator(), model.mViewPortHandler)
        model.mYAxisRenderer = YAxisRendererRadarChart(model.mViewPortHandler, model.mYAxis, model,
            Option<Transformer>.None)
        if (let Some(mXAxis) <- model.mXAxis) {
            model.mXAxisRenderer = XAxisRendererRadarChart(model.mViewPortHandler, mXAxis, model,
                Option<Transformer>.None)
        }

        model.mHighlighter = RadarHighlighter(model)
        return model
    }

    public func invalidate() {
        if (let Some(context2d) <- this.context2d) {
            this.onDraw(context2d)
        }
    }

    public func setContext2D(context2d: CanvasRenderingContext2D) {
        this.context2d = context2d
    }

    public func onChartSizeChanged(newWidth: Float64, newHeight: Float64, oldWidth: Float64, oldHeight: Float64) {
        super.onSizeChanged(newWidth, newHeight, oldWidth, oldHeight)
    }

    public func calcMinMax(): Unit {
        if (let Some(mdata) <- this.mData) {
            if (mdata.getMaxEntryCountSet().isNone()) {
                return
            }
            this.mYAxis.calculate(mdata.getYMin(AxisDependency.LEFT), mdata.getYMax(AxisDependency.LEFT))
            this.mYAxis.calculate(0.0, Float64(mdata.getMaxEntryCountSet()().getEntryCount()))
        } else {
            return
        }
    }

    public func notifyDataSetChanged() {
        if (this.mData.isNone()) {
            return
        }

        this.calcMinMax()

        this.mYAxisRenderer?.computeAxis(this.mYAxis.mAxisMinimum, this.mYAxis.mAxisMaximum, this.mYAxis.isInverted())

        if (let Some(mXAxis) <- this.mXAxis) {
            this.mXAxisRenderer?.computeAxis(mXAxis.mAxisMinimum, mXAxis.mAxisMaximum, false)
        }

        if (!this.mLegend.isLegendCustom()) {
            this.mLegendRenderer?.computeLegend(this.mData)
        }

        this.calculateOffsets()
    }

    public func onDraw(canvas: CanvasRenderingContext2D) {
        super.onDraw(canvas)

        if (this.mData.isNone()) {
            return
        }

        //TODO canvas.width canvas.height
        canvas.clearRect(0.0, 0.0, this.mViewPortHandler.getChartWidth(), this.mViewPortHandler.getChartHeight())
        if (this.mXAxis.isSome() && this.mXAxis().isEnabled() && this.mXAxisRenderer.isSome()) {
            this.mXAxisRenderer().computeAxis(this.mXAxis().mAxisMinimum, this.mXAxis().mAxisMaximum, false)
        }

        this.mXAxisRenderer?.renderAxisLabels(canvas)

        if (this.mDrawWeb) {
            this.mRenderer?.drawExtras(canvas)
        }

        if (this.mYAxis.isEnabled() && this.mYAxis.isDrawLimitLinesBehindDataEnabled()) {
            this.mYAxisRenderer().renderLimitLines(canvas)
        }

        this.mRenderer?.drawData(canvas)

        if (this.valuesToHighlight() && this.mIndicesToHighlight.isSome()) {
            this.mRenderer?.drawHighlighted(canvas, this.mIndicesToHighlight())
        }

        if (this.mYAxis.isEnabled() && !this.mYAxis.isDrawLimitLinesBehindDataEnabled()) {
            this.mYAxisRenderer().renderLimitLines(canvas)
        }

        this.mYAxisRenderer().renderAxisLabels(canvas)

        this.mRenderer?.drawValues(canvas, isHorizontalFlip: false)

        this.mLegendRenderer?.renderLegend(canvas)

        this.drawDescription(canvas)

        this.drawMarkers(canvas)
    }

    /**
     * Returns the factor that is needed to transform values into pixels.
     *
     * @return
     */
    public func getFactor(): Float64 {
        let content: ChartRect = this.mViewPortHandler.getContentRect()
        return min(content.width() / 2.0, content.height() / 2.0) / this.mYAxis.mAxisRange * 0.7
    }

    public func getSliceAngle(): Float64 {
        if (this.mData.isNone() || this.mData().getMaxEntryCountSet().isNone()) {
            return 0.0
        }
        return 360.0 / Float64(this.mData().getMaxEntryCountSet()().getEntryCount())
    }

    public func getIndexForAngle(angle: Float64): Int64 {
        if (this.mData.isNone() || this.mData().getMaxEntryCountSet().isNone()) {
            return 0
        }
        // take the current angle of the chart into consideration
        let a: Float64 = Utils.getNormalizedAngle(angle - this.getRotationAngle())

        let sliceangle: Float64 = this.getSliceAngle()

        let maxs: Int64 = this.mData().getMaxEntryCountSet()().getEntryCount()

        var index = 0

        for (i in 0..maxs) {
            let referenceAngle: Float64 = sliceangle * Float64(i + 1) - sliceangle / 2.0

            if (referenceAngle > a) {
                index = i
                break
            }
        }
        return index
    }

    /**
     * Returns the object that represents all y-labels of the RadarChart.
     *
     * @return
     */
    public func getYAxis(): YAxis {
        return this.mYAxis
    }

    /**
     * Sets the width of the web lines that come from the center.
     *
     * @param width
     */
    public func setWebLineWidth(width: Float64): Unit {
        this.mWebLineWidth = Utils.handleDataValues(width)
    }

    public func getWebLineWidth(): Float64 {
        return this.mWebLineWidth
    }

    /**
     * Sets the width of the web lines that are in between the lines coming from
     * the center.
     *
     * @param width
     */
    public func setWebLineWidthInner(width: Float64): Unit {
        this.mInnerWebLineWidth = Utils.handleDataValues(width)
    }

    public func getWebLineWidthInner(): Float64 {
        return this.mInnerWebLineWidth
    }

    /**
     * Sets the transparency (alpha) value for all web lines, default: 150, 255
     * = 100% opaque, 0 = 100% transparent
     *
     * @param alpha
     */
    public func setWebAlpha(alpha: Float64): Unit {
        this.mWebAlpha = alpha
    }

    /**
     * Returns the alpha value for all web lines.
     *
     * @return
     */
    public func getWebAlpha(): Float64 {
        return this.mWebAlpha
    }

    /**
     * Sets the color for the web lines that come from the center. Don't forget
     * to use getResources().getColor(...) when loading a color from the
     * resources. Default: Color.rgb(122, 122, 122)
     *
     * @param color
     */
    public func setWebColor(color: UInt32) {
        this.mWebColor = color
    }

    public func getWebColor() {
        return this.mWebColor
    }

    /**
     * Sets the color for the web lines in between the lines that come from the
     * center. Don't forget to use getResources().getColor(...) when loading a
     * color from the resources. Default: Color.rgb(122, 122, 122)
     *
     * @param color
     */
    public func setWebColorInner(color: UInt32) {
        this.mWebColorInner = color
    }

    public func getWebColorInner(): UInt32 {
        return this.mWebColorInner
    }

    /**
     * If set to true, drawing the web is enabled, if set to false, drawing the
     * whole web is disabled. Default: true
     *
     * @param enabled
     */
    public func setDrawWeb(enabled: Bool) {
        this.mDrawWeb = enabled
    }

    /**
     * Sets the Float64 of web-lines that should be skipped on chart web before the
     * next one is drawn. This targets the lines that come from the center of the RadarChart.
     *
     * @param count if count = 1 -> 1 line is skipped in between
     */
    public func setSkipWebLineCount(count: Int64) {
        this.mSkipWebLineCount = max(0, count)
    }

    /**
     * Returns the modulus that is used for skipping web-lines.
     *
     * @return
     */
    public func getSkipWebLineCount() {
        return this.mSkipWebLineCount
    }

    protected func getRequiredLegendOffset(): Float64 {
        if (let Some(mLegendRenderer) <- this.mLegendRenderer) {
            return mLegendRenderer.getLabelPaint().getTextSize() * 4.0
        }
        return 0.0
    }

    protected func getRequiredBaseOffset(): Float64 {
        if (let Some(mXAxis) <- this.mXAxis) {
            return if (mXAxis.isEnabled() && mXAxis.isDrawLabelsEnabled()) {
                Float64(mXAxis.mLabelRotatedWidth)
            } else {
                Utils.handleDataValues(10.0)
            }
        } else {
            return Utils.handleDataValues(10.0)
        }
    }

    public func getRadius(): Float64 {
        let content: ChartRect = this.mViewPortHandler.getContentRect()
        return min(content.width() / 2.0, content.height() / 2.0)
    }

    /**
     * Returns the maximum value this chart can display on it's y-axis.
     */
    public func getYChartMax(): Float64 {
        return this.mYAxis.mAxisMaximum
    }

    /**
     * Returns the minimum value this chart can display on it's y-axis.
     */
    public func getYChartMin(): Float64 {
        return this.mYAxis.mAxisMinimum
    }

    /**
     * Returns the range of y-values this chart can display.
     *
     * @return
     */
    public func getYRange(): Float64 {
        return this.mYAxis.mAxisRange
    }

    public func getRadarData():?RadarData {
        return this.mData
    }
}
