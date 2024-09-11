/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package chart.bar

public class HorizontalBarChartModel <: BarChartModel {
    protected  init() {
        super()
        this.mLeftAxisTransformer = TransformerHorizontalBarChart(this.mViewPortHandler)
        this.mRightAxisTransformer = TransformerHorizontalBarChart(this.mViewPortHandler)
        this.mAnimator = ChartAnimator(this)
        if (let Some(animator) <- this.mAnimator) {
            this.mRenderer = HorizontalBarChartRenderer(this, animator, this.mViewPortHandler)
        }

//        this.setHighlighter(HorizontalBarHighlighter(this))

        if (let Some(axisLeft) <- this.mAxisLeft) {
            this.mAxisRendererLeft = YAxisRendererHorizontalBarChart(this.mViewPortHandler, axisLeft,
                this.mLeftAxisTransformer())
        }
        if (let Some(axisRight) <- this.mAxisRight) {
            this.mAxisRendererRight = YAxisRendererHorizontalBarChart(this.mViewPortHandler, axisRight,
                this.mRightAxisTransformer())
        }
        if (let Some(xaxis) <- this.mXAxis) {
            this.mXAxisRenderer = XAxisRendererHorizontalBarChart(this.mViewPortHandler, xaxis,
                this.mLeftAxisTransformer(), this)
        }
    }

    public static func build(): HorizontalBarChartModel {
        let model: HorizontalBarChartModel = HorizontalBarChartModel()
        return model
    }

    protected func calculateLegendOffsets(offsets: ChartRect): Unit {
        offsets.left = 0.0
        offsets.right = 0.0
        offsets.top = 0.0
        offsets.bottom = 0.0

        if (!this.mLegend.isEnabled() || this.mLegend.isDrawInsideEnabled()) {
            return
        }

        match (this.mLegend.getOrientation()) {
            case LegendOrientation.VERTICAL => match (this.mLegend.getHorizontalAlignment()) {
                case LegendHorizontalAlignment.LEFT => offsets.left += min(
                    this.mLegend.mNeededWidth,
                    this.mViewPortHandler.getChartWidth() * this.mLegend.getMaxSizePercent()
                )
                    + this.mLegend.getXOffset()

                case LegendHorizontalAlignment.RIGHT => offsets.right += min(
                    this.mLegend.mNeededWidth,
                    this.mViewPortHandler.getChartWidth() * this.mLegend.getMaxSizePercent()
                )
                    + this.mLegend.getXOffset()

                case LegendHorizontalAlignment.CENTER => match (this.mLegend.getVerticalAlignment()) {
                    case LegendVerticalAlignment.TOP => offsets.top += min(
                        this.mLegend.mNeededHeight,
                        this.mViewPortHandler.getChartHeight() * this.mLegend.getMaxSizePercent()
                    )
                        + this.mLegend.getYOffset()

                    case LegendVerticalAlignment.BOTTOM => offsets.bottom += min(
                        this.mLegend.mNeededHeight,
                        this.mViewPortHandler.getChartHeight() * this.mLegend.getMaxSizePercent()
                    )
                        + this.mLegend.getYOffset()

                    case _ => ()
                }
            }

            case LegendOrientation.HORIZONTAL => match (this.mLegend.getVerticalAlignment()) {
                case LegendVerticalAlignment.TOP =>
                    offsets.top += min(
                        this.mLegend.mNeededHeight,
                        this.mViewPortHandler.getChartHeight() * this.mLegend.getMaxSizePercent()
                    )
                        + this.mLegend.getYOffset()

                    if (this.mAxisLeft.isSome() && this.mAxisLeft().isEnabled() && this.mAxisLeft().isDrawLabelsEnabled(
                    ) && this.mAxisRendererLeft.isSome()) {
                        offsets.top += this.mAxisLeft().getRequiredHeightSpace(
                            this.mAxisRendererLeft().getPaintAxisLabels())
                    }

                case LegendVerticalAlignment.BOTTOM =>
                    offsets.bottom += min(
                        this.mLegend.mNeededHeight,
                        this.mViewPortHandler.getChartHeight() * this.mLegend.getMaxSizePercent()
                    )
                        + this.mLegend.getYOffset()

                    if (this.mAxisRight.isSome() && this.mAxisRight().isEnabled() &&
                        this.mAxisRight().isDrawLabelsEnabled() && this.mAxisRendererRight.isSome()) {
                        offsets.bottom += this.mAxisRight().getRequiredHeightSpace(
                            this.mAxisRendererRight().getPaintAxisLabels())
                    }

                case _ => ()
            }
        }
    }

    public open func calculateOffsets(): Unit {
        var offsetLeft: Float64 = 0.0
        var offsetRight: Float64 = 0.0
        var offsetTop: Float64 = 0.0
        var offsetBottom: Float64 = 0.0

        this.calculateLegendOffsets(this.mOffsetsBuffer)

        offsetLeft += this.mOffsetsBuffer.left
        offsetTop += this.mOffsetsBuffer.top
        offsetRight += this.mOffsetsBuffer.right
        offsetBottom += this.mOffsetsBuffer.bottom

        // offsets for y-labels
        if (this.mAxisLeft.isSome() && this.mAxisLeft().needsOffset() && this.mAxisRendererLeft.isSome()) {
            offsetTop += this.mAxisLeft().getRequiredHeightSpace(this.mAxisRendererLeft().getPaintAxisLabels())
        }

        if (this.mAxisRight.isSome() && this.mAxisRight().needsOffset() && this.mAxisRendererRight.isSome()) {
            offsetBottom += this.mAxisRight().getRequiredHeightSpace(this.mAxisRendererRight().getPaintAxisLabels())
        }

        if (this.mXAxis.isNone()) {
            return
        }

        let xlabelwidth: Float64 = Float64(this.mXAxis().mLabelRotatedWidth)

        if (this.mXAxis.isSome() && this.mXAxis().isEnabled()) {

            // offsets for x-labels
            if (this.mXAxis().getPosition() == XAxisPosition.BOTTOM) {
                offsetLeft += xlabelwidth
            } else if (this.mXAxis().getPosition() == XAxisPosition.TOP) {
                offsetRight += xlabelwidth
            } else if (this.mXAxis().getPosition() == XAxisPosition.BOTH_SIDED) {
                offsetLeft += xlabelwidth
                offsetRight += xlabelwidth
            }
        }

        offsetTop += this.getExtraTopOffset()
        offsetRight += this.getExtraRightOffset()
        offsetBottom += this.getExtraBottomOffset()
        offsetLeft += this.getExtraLeftOffset()

        let minOffset = Utils.handleDataValues(this.mMinOffset)

        this.mViewPortHandler.restrainViewPort(
            max(minOffset, offsetLeft),
            max(minOffset, offsetTop),
            max(minOffset, offsetRight),
            max(minOffset, offsetBottom)
        )

        if (this.mLogEnabled) {
            AppLog.info(
                "ChartModel.LOG_TAG: offsetLeft: ${offsetLeft}, offsetTop: ${offsetTop}, offsetRight: ${offsetRight}, offsetBottom: ${offsetBottom}"
            )
            AppLog.info("ChartModel.LOG_TAG: Content: ${this.mViewPortHandler.getContentRect().toString()}")
        }

        this.prepareOffsetMatrix()
        this.prepareValuePxMatrix()
    }

    public func prepareValuePxMatrix(): Unit {
        if (this.mRightAxisTransformer.isSome() && this.mAxisRight.isSome() && this.mXAxis.isSome()) {
            this.mRightAxisTransformer().prepareMatrixValuePx(this.mAxisRight().mAxisMinimum,
                this.mAxisRight().mAxisRange, this.mXAxis().mAxisRange, this.mXAxis().mAxisMinimum)
        }
        if (this.mLeftAxisTransformer.isSome() && this.mAxisLeft.isSome() && this.mXAxis.isSome()) {
            this.mLeftAxisTransformer().prepareMatrixValuePx(this.mAxisLeft().mAxisMinimum, this.mAxisLeft().mAxisRange,
                this.mXAxis().mAxisRange, this.mXAxis().mAxisMinimum)
        }
    }

    public func getMarkerPosition(high: Highlight): Array<Float64> {
        return [high.getDrawY(), high.getDrawX()]
    }

    public func getBarBounds(e: BarEntry, outputRect: ChartRect): Unit {
        if (let Some(data: BarData) <- this.mData) {
            let bounds: ChartRect = outputRect
            let set: ?IBarDataSet = data.getDataSetForEntry(e)

            if (set.isNone()) {
                outputRect.set(Float64.Min, Float64.Min, Float64.Min, Float64.Min)
                return
            }
            let y: Float64 = e.getY()
            let x: Float64 = e.getX()

            let barWidth = data.getBarWidth()

            let top = x - barWidth / 2.0
            let bottom = x + barWidth / 2.0
            let left = if (y >= 0.0) {
                y
            } else {
                0.0
            }
            let right = if (y <= 0.0) {
                y
            } else {
                0.0
            }

            bounds.set(left, top, right, bottom)

            this.getTransformer(set().getAxisDependency())?.rectValueToPixel(bounds)
        } else {
            return
        }
    }

    protected var mGetPositionBuffer: Array<Float64> = Array<Float64>(2, item: 0.0)

    /**
     * Returns a recyclable MPPointF instance.
     *
     * @param e
     * @param axis
     * @return
     */
    public open func getPosition(e: EntryOhos, axis: AxisDependency): MPPointF {
        let vals: Array<Float64> = this.mGetPositionBuffer
        vals[0] = e.getY()
        vals[1] = e.getX()

        this.getTransformer(axis)?.pointValuesToPixel(vals)

        return MPPointF.getInstance(vals[0], vals[1])
    }

    /**
     * Returns the Highlight object (contains x-index and DataSet index) of the selected value at the given touch point
     * inside the BarChart.
     *
     * @param x
     * @param y
     * @return
     */
    public open func getHighlightByTouchPoint(x: Float64, y: Float64): ?Highlight {
        if (this.mData.isNone()) {
            if (this.mLogEnabled) {
                AppLog.info("ChartModel.LOG_TAG: Can't select by touch. No data set.")
            }
            return Option<Highlight>.None
        } else {
            let highLighter: ?IHighlighter = this.getHighlighter()
            if (let Some(lighter) <- highLighter) {
                return lighter.getHighlight(y, x) // switch x and y
            } else {
                return Option<Highlight>.None
            }
        }
    }

    public func getLowestVisibleX(): Float64 {
        this.getTransformer(AxisDependency.LEFT)?.getValuesByTouchPoint(this.mViewPortHandler.contentLeft(),
            this.mViewPortHandler.contentBottom(), this.posForGetLowestVisibleX)

        let xAxis: ?XAxis = this.mXAxis
        if (let Some(axis) <- xAxis) {
            return max(axis.mAxisMinimum, this.posForGetLowestVisibleX.y)
        } else {
            return -1.0
        }
    }

    public open func getHighestVisibleX(): Float64 {
        this.getTransformer(AxisDependency.LEFT)?.getValuesByTouchPoint(this.mViewPortHandler.contentLeft(),
            this.mViewPortHandler.contentTop(), this.posForGetHighestVisibleX)
        let xAxis: ?XAxis = this.mXAxis
        if (let Some(axis) <- xAxis) {
            return min(axis.mAxisMaximum, this.posForGetHighestVisibleX.y)
        } else {
            return -1.0
        }
    }

    /**
     * ###### VIEWPORT METHODS BELOW THIS ######
     */
    public open func setVisibleXRangeMaximum(maxXRange: Float64): Unit {
        if (let Some(axis) <- this.mXAxis) {
            let xScale = axis.mAxisRange / (maxXRange)
            this.mViewPortHandler.setMinimumScaleY(xScale)
        }
    }

    public func setVisibleXRange(minXRange: Float64, maxXRange: Float64): Unit {
        if (let Some(axis) <- this.mXAxis) {
            let minScale = axis.mAxisRange / minXRange
            let maxScale = axis.mAxisRange / maxXRange
            this.mViewPortHandler.setMinMaxScaleY(minScale, maxScale)
        }
    }

    public func setVisibleYRangeMaximum(maxYRange: Float64, axis: AxisDependency): Unit {
        let yScale = this.getAxisRange(axis) / maxYRange
        this.mViewPortHandler.setMinimumScaleX(yScale)
    }

    public func setVisibleYRangeMinimum(minYRange: Float64, axis: AxisDependency): Unit {
        let yScale = this.getAxisRange(axis) / minYRange
        this.mViewPortHandler.setMaximumScaleX(yScale)
    }

    public func setVisibleYRange(minYRange: Float64, maxYRange: Float64, axis: AxisDependency): Unit {
        let minScale = this.getAxisRange(axis) / minYRange
        let maxScale = this.getAxisRange(axis) / maxYRange
        this.mViewPortHandler.setMinMaxScaleX(minScale, maxScale)
    }
}
