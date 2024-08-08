/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package mpchart.bar

public abstract class BarLineChartBaseModel<D, S, E> <: ChartModel<D, S, E> & BarLineScatterCandleBubbleDataProvider<D, S, E> where D <: BarLineScatterCandleBubbleData<S,
    E>, S <: IBarLineScatterCandleBubbleDataSet<E>, E <: EntryOhos {
    protected var mMaxVisibleCount: Int64 = 100
    /**
     * flag that indicates if auto scaling on the y axis is enabled
     */
    protected var mAutoScaleMinMaxEnabled: Bool = false
    /**
     * flag that indicates if pinch-zoom is enabled. if true, both x and y axis
     * can be scaled with 2 fingers, if false, x and y axis can be scaled
     * separately
     */
    protected var mPinchZoomEnabled: Bool = false
    /**
     * flag that indicates if double tap zoom is enabled or not
     */
    protected var mDoubleTapToZoomEnabled: Bool = true
    /**
     * flag that indicates if highlighting per dragging over a fully zoomed out
     * chart is enabled
     */
    protected var mHighlightPerDragEnabled: Bool = true
    /**
     * if true, dragging is enabled for the chart
     */
    private var mDragXEnabled: Bool = true
    private var mDragYEnabled: Bool = true
    private var mScaleXEnabled: Bool = true
    private var mScaleYEnabled: Bool = true
    /**
     * paint object for the (by default) lightgrey background of the grid
     */
    protected var mGridBackgroundPaint: ?Paint = Option<Paint>.None
    protected var mBorderPaint: ?Paint = Option<Paint>.None
    /**
     * flag indicating if the grid background should be drawn or not
     */
    protected var mDrawGridBackground: Bool = false
    protected var mDrawBorders: Bool = false
    protected var mClipValuesToContent: Bool = false
    protected var mClipDataToContent: Bool = true
    /**
     * Sets the minimum offset (padding) around the chart, defaults to 15
     */
    protected var mMinOffset: Float64 = 15.0
    /**
     * flag indicating if the chart should stay at the same position after a rotation. Default is false.
     */
    protected var mKeepPositionOnRotation: Bool = false
    /**
     * the listener for user drawing on the chart
     */
    protected var mDrawListener: ?OnDrawListener = Option<OnDrawListener>.None
    /**
     * the object representing the labels on the left y-axis
     */
    protected var mAxisLeft: ?YAxis = Option<YAxis>.None
    /**
     * the object representing the labels on the right y-axis
     */
    protected var mAxisRight: ?YAxis = Option<YAxis>.None
    protected var mLeftAxisTransformer: ?Transformer = Option<Transformer>.None
    protected var mRightAxisTransformer: ?Transformer = Option<Transformer>.None
    protected var mAxisRendererLeft: ?YAxisRenderer = Option<YAxisRenderer>.None
    protected var mAxisRendererRight: ?YAxisRenderer = Option<YAxisRenderer>.None
    protected var mXAxisRenderer: ?XAxisRenderer = Option<XAxisRenderer>.None
    private var mEventControl: EventControl = EventControl()

    /**
     * long press cursor response capability
     */
    protected var mLongPressCursorEnabled: Bool = false
    protected var mLongPressDuration: Int64 = 500

    public init() {
        super()
        this.mAxisLeft = YAxis(AxisDependency.LEFT)
        this.mAxisRight = YAxis(AxisDependency.RIGHT)

        this.mLeftAxisTransformer = Transformer(this.mViewPortHandler)
        this.mRightAxisTransformer = Transformer(this.mViewPortHandler)

        this.mAxisRendererLeft = YAxisRenderer(this.mViewPortHandler, this.mAxisLeft(), this.mLeftAxisTransformer())
        this.mAxisRendererRight = YAxisRenderer(this.mViewPortHandler, this.mAxisRight(), this.mRightAxisTransformer())

        if (let Some(xaxis) <- this.mXAxis) {
            this.mXAxisRenderer = XAxisRenderer(this.mViewPortHandler, xaxis, this.mLeftAxisTransformer())
        }
        //子类去实现
        //this.setHighlighter((ChartHighlighter(this) as ChartHighlighter<BarLineScatterCandleBubbleDataProvider<IDataSet<EntryOhos>, EntryOhos>, IDataSet<EntryOhos>, EntryOhos>)())

        this.mGridBackgroundPaint = Paint()
        this.mGridBackgroundPaint().setStyle(Style.FILL)
        this.mGridBackgroundPaint().setColor(Color(0xf0f0f0))
        // grey
        this.mBorderPaint = Paint()
        this.mBorderPaint().setStyle(Style.STROKE)
        this.mBorderPaint().setColor(Color.BLACK)
        this.mBorderPaint().setStrokeWidth(Utils.handleDataValues(1.0))
    }

    // for performance tracking
    private var totalTime: Int64 = 0
    private var drawCycles: Int64 = 0

    public func setLongPressCursorEnabled(enabled: Bool): Unit {
        this.mLongPressCursorEnabled = enabled
    }

    public func getLongPressCursorEnabled(): Bool {
        return this.mLongPressCursorEnabled
    }

    public func setLongPressDuration(duration: Int64): Unit {
        this.mLongPressDuration = duration
    }

    public func getLongPressDuration(): Int64 {
        return this.mLongPressDuration
    }

    public func getEventControl() {
        return this.mEventControl
    }

    protected var mYAxisExtensionLine: Bool = false

    public func setYAxisExtensionLine(opt: Bool) {
        this.mYAxisExtensionLine = opt
    }

    public func yAxisExtensionLineIsEnable() {
        return this.mYAxisExtensionLine
    }

    public open func onDraw(context2D: CanvasRenderingContext2D): Unit {
        super.onDraw(context2D)
        if (this.mData.isNone() || this.mRenderer.isNone() || !this.mChartSizeCorrected) {
            return
        }
        // 清空画布，防止图表堆叠
        context2D.clearRect(0.0, 0.0, this.mViewPortHandler.getChartWidth(), this.mViewPortHandler.getChartHeight())

        // execute all drawing commands
        this.drawGridBackground(context2D)

        if (this.mAutoScaleMinMaxEnabled) {
            this.autoScale()
        }

        if (this.mAxisRendererLeft.isSome() && this.mAxisLeft.isSome() && this.mAxisLeft().isEnabled()) {
            this.mAxisRendererLeft().computeAxis(this.mAxisLeft().mAxisMinimum, this.mAxisLeft().mAxisMaximum,
                this.mAxisLeft().isInverted())
        }

        if (this.mAxisRendererRight.isSome() && this.mAxisRight.isSome() && this.mAxisRight().isEnabled()) {
            this.mAxisRendererRight().computeAxis(this.mAxisRight().mAxisMinimum, this.mAxisRight().mAxisMaximum,
                this.mAxisRight().isInverted())
        }
        if (this.mXAxisRenderer.isSome() && this.mXAxis.isSome() && this.mXAxis().isEnabled()) {
            this.mXAxisRenderer().computeAxis(this.mXAxis().mAxisMinimum, this.mXAxis().mAxisMaximum, false)
        }
        // y轴延长线计算
        var extraLength = 0
        if (this.yAxisExtensionLineIsEnable()) {
            extraLength = if (this.mAxisLeft.isSome() && this.mAxisLeft().isEnabled()) {
                this.calcExtensionLine(this.mAxisRendererLeft)
            } else {
                0
            }
            if (extraLength != 0) {
                extraLength = if (this.mAxisRight.isSome() && this.mAxisRight().isEnabled()) {
                    this.calcExtensionLine(this.mAxisRendererRight)
                } else {
                    0
                }
            }
        }
        if (let Some(xAxisRenderer) <- this.mXAxisRenderer) {
            xAxisRenderer.renderAxisLine(context2D, extraLine: 0.0)
        }
        if (let Some(axisRendererLeft) <- this.mAxisRendererLeft) {
            axisRendererLeft.renderAxisLine(context2D, extraLine: Float64(extraLength))
        }
        if (let Some(axisRendererRight) <- this.mAxisRendererRight) {
            axisRendererRight.renderAxisLine(context2D, extraLine: Float64(extraLength))
        }

        if (this.mXAxisRenderer.isSome() && this.mXAxis.isSome() && this.mXAxis().isDrawGridLinesBehindDataEnabled()) {
            this.mXAxisRenderer().renderGridLines(context2D)
        }

        if (this.mAxisRendererLeft.isSome() && this.mAxisLeft.isSome() &&
            this.mAxisLeft().isDrawGridLinesBehindDataEnabled()) {
            this.mAxisRendererLeft().renderGridLines(context2D)
        }

        if (this.mAxisRendererRight.isSome() && this.mAxisRight.isSome() &&
            this.mAxisRight().isDrawGridLinesBehindDataEnabled()) {
            this.mAxisRendererRight().renderGridLines(context2D)
        }

        if (this.mXAxisRenderer.isSome() && this.mXAxis.isSome() && this.mXAxis().isEnabled()) {
            this.mXAxisRenderer().renderCustomGridLines(context2D)
            this.mXAxis().isDrawLimitLinesBehindDataEnabled()
            this.mXAxisRenderer().renderLimitLines(context2D)
        }

        if (this.mAxisRendererLeft.isSome() && this.mAxisLeft.isSome() && this.mAxisLeft().isEnabled()) {
            this.mAxisRendererLeft().renderCustomGridLines(context2D)
            this.mAxisLeft().isDrawLimitLinesBehindDataEnabled()
            this.mAxisRendererLeft().renderLimitLines(context2D)
        }

        if (this.mAxisRendererRight.isSome() && this.mAxisRight.isSome() && this.mAxisRight().isEnabled()) {
            this.mAxisRendererRight().renderCustomGridLines(context2D)
            this.mAxisRight().isDrawLimitLinesBehindDataEnabled()
            this.mAxisRendererRight().renderLimitLines(context2D)
        }

        context2D.save()

        if (this.isClipDataToContentEnabled()) {
            // make sure the data cannot be drawn outside the content-rect
            let rect = this.mViewPortHandler.getContentRect()
            context2D.beginPath()
            context2D.rect(rect.left, rect.top, rect.width(), rect.height())
            context2D.closePath()
            context2D.clip()
        }
        this.mRenderer().drawData(context2D)

        if (this.mXAxisRenderer.isSome() && this.mXAxis.isSome() && !this.mXAxis().isDrawGridLinesBehindDataEnabled()) {
            this.mXAxisRenderer().renderGridLines(context2D)
        }

        if (this.mAxisRendererLeft.isSome() && this.mAxisLeft.isSome() &&
            !this.mAxisLeft().isDrawGridLinesBehindDataEnabled()) {
            this.mAxisRendererLeft().renderGridLines(context2D)
        }

        if (this.mAxisRendererRight.isSome() && this.mAxisRight.isSome() &&
            !this.mAxisRight().isDrawGridLinesBehindDataEnabled()) {
            this.mAxisRendererRight().renderGridLines(context2D)
        }
        // if highlighting is enabled
        if (this.valuesToHighlight() && this.mIndicesToHighlight.isSome()) {
            this.mRenderer().drawHighlighted(context2D, this.mIndicesToHighlight())
        }

        // Removes clipping rectangle
        context2D.restore()
        if (this.mRenderer.isSome()) {
            this.mRenderer().drawExtras(context2D)
        }

        if (this.mXAxisRenderer.isSome() && this.mXAxis.isSome() && this.mXAxis().isEnabled() &&
            !this.mXAxis().isDrawLimitLinesBehindDataEnabled()) {
            this.mXAxisRenderer().renderLimitLines(context2D)
        }

        if (this.mAxisRendererLeft.isSome() && this.mAxisLeft.isSome() && this.mAxisLeft().isEnabled() &&
            !this.mAxisLeft().isDrawLimitLinesBehindDataEnabled()) {
            this.mAxisRendererLeft().renderLimitLines(context2D)
        }

        if (this.mAxisRendererRight.isSome() && this.mAxisRight.isSome() && this.mAxisRight().isEnabled() &&
            !this.mAxisRight().isDrawLimitLinesBehindDataEnabled()) {
            this.mAxisRendererRight().renderLimitLines(context2D)
        }
        if (this.mXAxisRenderer.isSome()) {
            this.mXAxisRenderer().renderAxisLabels(context2D)
        }
        if (this.mAxisRendererLeft.isSome()) {
            this.mAxisRendererLeft().renderAxisLabels(context2D)
        }
        if (this.mAxisRendererRight.isSome()) {
            this.mAxisRendererRight().renderAxisLabels(context2D)
        }
        if (this.isClipValuesToContentEnabled()) {
            context2D.save()
            let rect = this.mViewPortHandler.getContentRect()
            context2D.rect(rect.left, rect.right, rect.width(), rect.height())
            context2D.clip()
            this.mRenderer().drawValues(context2D, isHorizontalFlip: false)
            context2D.restore()
        } else {
            this.mRenderer().drawValues(context2D, isHorizontalFlip: false)
        }

        if (this.mLegendRenderer.isSome()) {
            this.mLegendRenderer().renderLegend(context2D)
        }
        this.drawDescription(context2D)

        this.drawMarkers(context2D)

        this.drawLongPressMarkers(context2D)
    }

    // y轴计算延长线
    private func calcExtensionLine(render: ?YAxisRenderer) {
        var extensionLength: Int64 = 0
        if (render.isSome()) {
            if (this.mXAxis.isSome()) {
                extensionLength = Int64(this.mXAxis().getYOffset()) + this.mXAxis().mLabelRotatedHeight / 2 + Int64(Utils.
                        calcTextHeight(CanvasRenderingContext2D(RenderingContextSettings(antialias: true)), render().getPaintAxisLine(), "0"))
            }
        }
        return extensionLength
    }

    public func resetTracking(): Unit {
        this.totalTime = 0
        this.drawCycles = 0
    }

    protected open func prepareValuePxMatrix(): Unit {
        if (this.mLogEnabled && this.mXAxis.isSome()) {
            AppLog.info(
                "mpchart: Preparing Value-Px Matrix, xmin: ${this.mXAxis().mAxisMinimum}, xmax: ${this.mXAxis().mAxisMaximum}, xdelta: ${this.mXAxis().mAxisRange}"
            )
        }

        if (this.mRightAxisTransformer.isSome() && this.mXAxis.isSome() && this.mAxisRight.isSome()) {
            this.mRightAxisTransformer().prepareMatrixValuePx(
                this.mXAxis().mAxisMinimum,
                this.mXAxis().mAxisRange,
                this.mAxisRight().mAxisRange,
                this.mAxisRight().mAxisMinimum
            )
        }
        if (this.mLeftAxisTransformer.isSome() && this.mXAxis.isSome() && this.mAxisLeft.isSome()) {
            this.mLeftAxisTransformer().prepareMatrixValuePx(
                this.mXAxis().mAxisMinimum,
                this.mXAxis().mAxisRange,
                this.mAxisLeft().mAxisRange,
                this.mAxisLeft().mAxisMinimum
            )
        }
    }

    protected func prepareOffsetMatrix(): Unit {
        if (this.mRightAxisTransformer.isSome() && this.mAxisRight.isSome()) {
            this.mRightAxisTransformer().prepareMatrixOffset(this.mAxisRight().isInverted())
        }
        if (this.mLeftAxisTransformer.isSome() && this.mAxisLeft.isSome()) {
            this.mLeftAxisTransformer().prepareMatrixOffset(this.mAxisLeft().isInverted())
        }
    }

    public func notifyDataSetChanged(): Unit {
        if (this.mData.isNone()) {
            if (this.mLogEnabled) {
                AppLog.info("mpchart: Preparing... DATA NOT SET.")
            }
            return
        } else {
            if (this.mLogEnabled) {
                AppLog.info("mpchart: Preparing...")
            }
        }

        if (this.mRenderer.isSome()) {
            this.mRenderer().initBuffers()
        }
        this.calcMinMax()
        if (this.mAxisRendererLeft.isSome() && this.mAxisLeft.isSome()) {
            this.mAxisRendererLeft().computeAxis(this.mAxisLeft().mAxisMinimum, this.mAxisLeft().mAxisMaximum,
                this.mAxisLeft().isInverted())
        }
        if (this.mAxisRendererRight.isSome() && this.mAxisRight.isSome()) {
            this.mAxisRendererRight().computeAxis(this.mAxisRight().mAxisMinimum, this.mAxisRight().mAxisMaximum,
                this.mAxisRight().isInverted())
        }
        if (this.mXAxisRenderer.isSome() && this.mXAxis.isSome()) {
            this.mXAxisRenderer().computeAxis(this.mXAxis().mAxisMinimum, this.mXAxis().mAxisMaximum, false)
        }

        if (this.mLegendRenderer.isSome()) {
            this.mLegendRenderer().computeLegend(this.mData())
        }

        this.calculateOffsets()
    }

    /**
     * Performs auto scaling of the axis by recalculating the minimum and maximum y-values based on the entries currently in view.
     */
    protected func autoScale(): Unit {
        if (this.mData.isNone()) {
            return
        }
        var fromX: Float64 = this.getLowestVisibleX()
        var toX: Float64 = this.getHighestVisibleX()

        this.mData().calcMinMaxY(fromX, toX)
        if (this.mXAxis.isSome()) {
            this.mXAxis().calculate(this.mData().getXMin(), this.mData().getXMax())
        }

        // calculate axis range (min / max) according to provided data

        if (this.mAxisLeft.isSome() && this.mAxisLeft().isEnabled()) {
            this.mAxisLeft().calculate(
                this.mData().getYMin(AxisDependency.LEFT),
                this.mData().getYMax(AxisDependency.LEFT)
            )
        }

        if (this.mAxisRight.isSome() && this.mAxisRight().isEnabled()) {
            this.mAxisRight().calculate(
                this.mData().getYMin(AxisDependency.RIGHT),
                this.mData().getYMax(AxisDependency.RIGHT)
            )
        }

        this.calculateOffsets()
    }

    protected open func calcMinMax(): Unit {
        if (this.mData.isNone()) {
            return
        }
        if (let Some(axis) <- this.mXAxis) {
            axis.calculate(this.mData().getXMin(), this.mData().getXMax())
        }

        // calculate axis range (min / max) according to provided data
        if (let Some(axis) <- this.mAxisLeft) {
            axis.calculate(
                this.mData().getYMin(AxisDependency.LEFT),
                this.mData().getYMax(AxisDependency.LEFT)
            )
        }
        if (let Some(axis) <- this.mAxisRight) {
            axis.calculate(
                this.mData().getYMin(AxisDependency.RIGHT),
                this.mData().getYMax(AxisDependency.RIGHT)
            )
        }
    }
    protected open func calculateLegendOffsets(offsets: MyRect): Unit {
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
            case _ => ()
        }
    }

    protected var mOffsetsBuffer: MyRect = MyRect()

    public open func calculateOffsets(): Unit {
        if (!this.mCustomViewPortEnabled) {
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
            if (this.mAxisLeft.isSome() && this.mAxisRendererLeft.isSome() && this.mAxisLeft().needsOffset()) {

                // Y轴边距：最长的Y轴标签宽度 + 2倍的 XOffset
                offsetLeft += this.mAxisLeft().getRequiredWidthSpace(this.mAxisRendererLeft().getPaintAxisLabels())
            }

            if (this.mAxisRight.isSome() && this.mAxisRendererRight.isSome() && this.mAxisRight().needsOffset()) {
                offsetRight += this.mAxisRight().getRequiredWidthSpace(this.mAxisRendererRight().getPaintAxisLabels())
            }

            if (this.mXAxis.isSome() && this.mXAxis().isEnabled() && this.mXAxis().isDrawLabelsEnabled()) {

                // 标签旋转的高度 + yOffset
                let xLabelHeight: Float64 = Float64(this.mXAxis().mLabelRotatedHeight) + this.mXAxis().getYOffset()

                // offsets for x-labels
                if (this.mXAxis().getPosition() == XAxisPosition.BOTTOM) {
                    offsetBottom += xLabelHeight
                } else if (this.mXAxis().getPosition() == XAxisPosition.TOP) {
                    offsetTop += xLabelHeight
                } else if (this.mXAxis().getPosition() == XAxisPosition.BOTH_SIDED) {
                    offsetBottom += xLabelHeight
                    offsetTop += xLabelHeight
                }
            }

            offsetTop += this.getExtraTopOffset()
            offsetRight += this.getExtraRightOffset()
            offsetBottom += this.getExtraBottomOffset()
            offsetLeft += this.getExtraLeftOffset()

            let minOffset: Float64 = Utils.handleDataValues(this.mMinOffset)

            this.mViewPortHandler.restrainViewPort(
                max(minOffset, offsetLeft),
                max(minOffset, offsetTop),
                max(minOffset, offsetRight),
                max(minOffset, offsetBottom)
            )

            if (this.mLogEnabled) {
                AppLog.info(
                    "offsetLeft: ${offsetLeft}, offsetTop: ${offsetTop}, offsetRight: ${offsetRight}, offsetBottom: ${offsetBottom}"
                )
                AppLog.info("Content: " + this.mViewPortHandler.getContentRect().toString())
            }
        }

        this.prepareOffsetMatrix()
        this.prepareValuePxMatrix()
    }

    protected func drawGridBackground(c: CanvasRenderingContext2D): Unit {
        if (this.mDrawGridBackground) {
            if (this.mGridBackgroundPaint.isSome()) {
                Utils.resetContext2DStyle(c, this.mGridBackgroundPaint())
            }

            c.beginPath()
            let rect = this.mViewPortHandler.getContentRect()
            c.rect(rect.left, rect.top, rect.width(), rect.height())
            c.fill()
            c.closePath()
        }
        if (this.mDrawBorders) {
            if (this.mBorderPaint.isSome()) {
                Utils.resetContext2DStyle(c, this.mBorderPaint())
            }

            c.beginPath()
            let rect = this.mViewPortHandler.getContentRect()
            c.rect(rect.left, rect.top, rect.width(), rect.height())
            c.stroke()
            c.closePath()
        }
    }

    /**
     * Returns the Transformer class that contains all matrices and is
     * responsible for transforming values into pixels on the screen and
     * backwards.
     *
     * @return
     */
    public func getTransformer(which: AxisDependency): ?Transformer {
        if (which == AxisDependency.LEFT) {
            return this.mLeftAxisTransformer
        } else {
            return this.mRightAxisTransformer
        }
    }

    public func onTouchEvent(event: TouchEvent): Unit {
        // check if touch gestures are enabled
        if (!this.mTouchEnabled) {
            return
        }
        if (this.mEventControl.eventIsDisable(EventType.SingleTap)) {
            return
        }
        if (this.mChartTouchListener.isNone() || this.mData.isNone()) {
            return
        }

        match (event.eventType) {
            case TouchType.Down => this.mChartTouchListener().actionDown(true, event)

            case TouchType.Move => this.mChartTouchListener().actionMove(true, event)

            case TouchType.Up => this.mChartTouchListener().actionUp(true, event)

            case _ => ()
        }
    }

    public func onSingleTapUp(isTouchEvent: Bool, event: Any): Unit {
        if (!this.mTouchEnabled) {
            return
        }
        if (this.mEventControl.eventIsDisable(EventType.SingleTap)) {
            return
        }
        if (this.mChartTouchListener.isSome()) {
            this.mChartTouchListener().onSingleTapUp(isTouchEvent, event)
        }
    }

    public func onDoubleTap(isTouchEvent: Bool, event: Any): Unit {
        if (!this.mTouchEnabled) {
            return
        }
        if (this.mEventControl.eventIsDisable(EventType.DoubleTap)) {
            return
        }
        if (this.mChartTouchListener.isSome()) {
            this.mChartTouchListener().onDoubleTap(isTouchEvent, event)
        }
    }

    public func onLongPress(isTouchEvent: Bool, actionType: LongPressType, event: Any): Unit {
        if (!this.mTouchEnabled) {
            return
        }
        if (this.mEventControl.eventIsDisable(EventType.LongPress)) {
            return
        }
        if (let Some(mChartTouchL) <- this.mChartTouchListener) {
            match (actionType) {
                case DOWN => mChartTouchL.onLongPressed(isTouchEvent, event)
                case UP => mChartTouchL.onLongPressUp(isTouchEvent, event)
                case CANCEL => mChartTouchL.onLongPressCancel(isTouchEvent, event)
                case _ => mChartTouchL.onLongPressed(isTouchEvent, event)
            }
        }
    }

    public func calcPos(isTouchEvent: Bool, event: Any): (Float64, Float64) {
        return (this.mChartTouchListener as BarLineChartTouchListener<D, S, E>)().getXyByEvent(isTouchEvent, event)
    }

    public func onPinch(isTouchEvent: Bool, actionType: PinchActionType, event: Any): Unit {
        if (!this.mTouchEnabled) {
            return
        }
        if (let Some(mChartTouchL) <- this.mChartTouchListener) {
            match (actionType) {
                case START => mChartTouchL.actionPinchDown(isTouchEvent, event)
                case UPDATE => mChartTouchL.actionMove(isTouchEvent, event)
                case END => mChartTouchL.actionPinchUp(isTouchEvent, event)
                case CANCEL => ()
                case _ => mChartTouchL.actionCancel(isTouchEvent, event)
            }
        }
    }
    public func computeScroll(): Unit {
        if (let Some(listener: BarLineChartTouchListener<D, S, E>) <- this.mChartTouchListener) {
            listener.computeScroll()
        }
    }

    protected var mZoomMatrixBuffer: Matrix = Matrix()

    /**
     * Zooms in by 1.4f, into the charts center.
     */
    public func zoomIn(): Unit {
        let center: MPPointF = this.mViewPortHandler.getContentCenter()

        this.mViewPortHandler.zoomIn(center.x, -center.y, this.mZoomMatrixBuffer)
        this.mViewPortHandler.refresh(this.mZoomMatrixBuffer, this, false)

        MPPointF.recycleInstance(center)

        // Range might have changed, which means that Y-axis labels
        // could have changed in size, affecting Y-axis size.
        // So we need to recalculate offsets.
        this.calculateOffsets()
        this.invalidate()
    }

    /**
     * Zooms out by 0.7f, from the charts center.
     */
    public func zoomOut(): Unit {
        let center: MPPointF = this.mViewPortHandler.getContentCenter()

        this.mViewPortHandler.zoomOut(center.x, -center.y, this.mZoomMatrixBuffer)
        this.mViewPortHandler.refresh(this.mZoomMatrixBuffer, this, false)

        MPPointF.recycleInstance(center)

        this.calculateOffsets()
        this.invalidate()
    }

    /**
     * Zooms out to original size.
     */
    public func resetZoom(): Unit {
        this.mViewPortHandler.resetZoom(this.mZoomMatrixBuffer)
        this.mViewPortHandler.refresh(this.mZoomMatrixBuffer, this, false)

        this.calculateOffsets()
        this.invalidate()
    }

    /**
     * Zooms in or out by the given scale factor.
     * x and y are the values (NOT PIXELS) of the zoom center..
     *
     * @param scaleX
     * @param scaleY
     * @param xValue
     * @param yValue
     * @param axis   the axis relative to which the zoom should take place
     */
    public func zoom(scaleX: Float64, scaleY: Float64, xValue: Float64, yValue: Float64, axis: ?AxisDependency): Unit {
        if (axis.isNone()) {
            this.mViewPortHandler.zoom(scaleX, scaleY, xValue, -yValue, this.mZoomMatrixBuffer)
            this.mViewPortHandler.refresh(this.mZoomMatrixBuffer, this, false
            )

            this.calculateOffsets()
            this.invalidate()
        }
    }

    /**
     * Zooms to the center of the chart with the given scale factor.
     *
     * @param scaleX
     * @param scaleY
     */
    public func zoomToCenter(scaleX: Float64, scaleY: Float64): Unit {
        let center: ?MPPointF = this.getCenterOffsets()
        let save: Matrix = this.mZoomMatrixBuffer
        if (center.isSome()) {
            this.mViewPortHandler.zoom(scaleX, scaleY, center().x, -center().y, save)
            this.mViewPortHandler.refresh(save, this, false
            )
        }
    }

    /**
     * Zooms by the specified scale factor to the specified values on the specified axis.
     *
     * @param scaleX
     * @param scaleY
     * @param xValue
     * @param yValue
     * @param axis
     * @param duration
     */
    public func zoomAndCenterAnimated(scaleX: Float64, scaleY: Float64, xValue: Float64, yValue: Float64,
        axis: AxisDependency, duration: Float64): Unit {
        let origin: MPPointD = this.getValuesByTouchPoint(this.mViewPortHandler.contentLeft(),
            this.mViewPortHandler.contentTop(), axis, Option<MPPointD>.None)

        MPPointD.recycleInstance(origin)
    }

    protected var mFitScreenMatrixBuffer: Matrix = Matrix()

    /**
     * Resets all zooming and dragging and makes the chart fit exactly it's
     * bounds.
     */
    public func fitScreen(): Unit {
        let save: Matrix = this.mFitScreenMatrixBuffer
        this.mViewPortHandler.fitScreen(save)
        this.mViewPortHandler.refresh(save, this, false)
        this.calculateOffsets()
        this.invalidate()
    }

    /**
     * Sets the minimum scale factor value to which can be zoomed out. 1f =
     * fitScreen
     *
     * @param scaleX
     * @param scaleY
     */
    public func setScaleMinima(scaleX: Float64, scaleY: Float64): Unit {
        this.mViewPortHandler.setMinimumScaleX(scaleX)
        this.mViewPortHandler.setMinimumScaleY(scaleY)
    }

    /**
     * Sets the size of the area (range on the x-axis) that should be maximum
     * visible at once (no further zooming out allowed). If this is e.g. set to
     * 10, no more than a range of 10 on the x-axis can be viewed at once without
     * scrolling.
     *
     * @param maxXRange The maximum visible range of x-values.
     */
    public open func setVisibleXRangeMaximum(maxXRange: Float64): Unit {
        var xScale: Float64 = 1.0
        if (this.mXAxis.isSome()) {
            xScale = this.mXAxis().mAxisRange / (maxXRange)
        }
        this.mViewPortHandler.setMinimumScaleX(xScale)
    }

    /**
     * Sets the size of the area (range on the x-axis) that should be minimum
     * visible at once (no further zooming in allowed). If this is e.g. set to
     * 10, no less than a range of 10 on the x-axis can be viewed at once without
     * scrolling.
     *
     * @param minXRange The minimum visible range of x-values.
     */
    public func setVisibleXRangeMinimum(minXRange: Float64): Unit {
        var xScale: Float64 = 1.0
        if (this.mXAxis.isSome()) {
            xScale = this.mXAxis().mAxisRange / (minXRange)
        }
        this.mViewPortHandler.setMaximumScaleX(xScale)
    }

    /**
     * Limits the maximum and minimum x range that can be visible by pinching and zooming. e.g. minRange=10, maxRange=100 the
     * smallest range to be displayed at once is 10, and no more than a range of 100 values can be viewed at once without
     * scrolling
     *
     * @param minXRange
     * @param maxXRange
     */
    public open func setVisibleXRange(minXRange: Float64, maxXRange: Float64): Unit {
        var minScale: Float64 = 1.0
        if (this.mXAxis.isSome()) {
            minScale = this.mXAxis().mAxisRange / minXRange
        }
        var maxScale: Float64 = 1.0
        if (this.mXAxis.isSome()) {
            maxScale = this.mXAxis().mAxisRange / maxXRange
        }
        this.mViewPortHandler.setMinMaxScaleX(minScale, maxScale)
    }

    /**
     * Sets the size of the area (range on the y-axis) that should be maximum
     * visible at once.
     *
     * @param maxYRange the maximum visible range on the y-axis
     * @param axis      the axis for which this limit should apply
     */
    public open func setVisibleYRangeMaximum(maxYRange: Float64, axis: AxisDependency): Unit {
        let yScale: Float64 = this.getAxisRange(axis) / maxYRange
        this.mViewPortHandler.setMinimumScaleY(yScale)
    }

    /**
     * Sets the size of the area (range on the y-axis) that should be minimum visible at once, no further zooming in possible.
     *
     * @param minYRange
     * @param axis      the axis for which this limit should apply
     */
    public open func setVisibleYRangeMinimum(minYRange: Float64, axis: AxisDependency): Unit {
        let yScale: Float64 = this.getAxisRange(axis) / minYRange
        this.mViewPortHandler.setMaximumScaleY(yScale)
    }

    /**
     * Limits the maximum and minimum y range that can be visible by pinching and zooming.
     *
     * @param minYRange
     * @param maxYRange
     * @param axis
     */
    public open func setVisibleYRange(minYRange: Float64, maxYRange: Float64, axis: AxisDependency): Unit {
        let minScale: Float64 = this.getAxisRange(axis) / minYRange
        let maxScale: Float64 = this.getAxisRange(axis) / maxYRange
        this.mViewPortHandler.setMinMaxScaleY(minScale, maxScale)
    }

    /**
     * Moves the left side of the current viewport to the specified x-position.
     * This also refreshes the chart by calling invalidate().
     *
     * @param xValue
     */
    public func moveViewToX(xValue: Float64): Unit {
        let transformer: ?Transformer = this.getTransformer(AxisDependency.LEFT)
        if (transformer.isSome()) {
            let job: MoveViewJob = MoveViewJob.getInstance(this.mViewPortHandler, xValue, 0.0, transformer(),
                (this as ChartModel<ChartData<IDataSet<EntryOhos>, EntryOhos>, IDataSet<EntryOhos>, EntryOhos>)())
            this.addViewportJob(job)
        }
    }

    /**
     * This will move the left side of the current viewport to the specified
     * x-value on the x-axis, and center the viewport to the specified y value on the y-axis.
     * This also refreshes the chart by calling invalidate().
     *
     * @param xValue
     * @param yValue
     * @param axis   - which axis should be used as a reference for the y-axis
     */
    public func moveViewTo(xValue: Float64, yValue: Float64, axis: AxisDependency): Unit {
        let yInView: Float64 = this.getAxisRange(axis) / this.mViewPortHandler.getScaleY()
    }

    /**
     * This will move the left side of the current viewport to the specified x-value
     * and center the viewport to the y value animated.
     * This also refreshes the chart by calling invalidate().
     *
     * @param xValue
     * @param yValue
     * @param axis
     * @param duration the duration of the animation in milliseconds
     */
    public func moveViewToAnimated(xValue: Float64, yValue: Float64, axis: AxisDependency, duration: Float64): Unit {
        let bounds: MPPointD = this.getValuesByTouchPoint(this.mViewPortHandler.contentLeft(),
            this.mViewPortHandler.contentTop(), axis, Option<MPPointD>.None)

        let yInView: Float64 = this.getAxisRange(axis) / this.mViewPortHandler.getScaleY()

        MPPointD.recycleInstance(bounds)
    }

    /**
     * Centers the viewport to the specified y value on the y-axis.
     * This also refreshes the chart by calling invalidate().
     *
     * @param yValue
     * @param axis   - which axis should be used as a reference for the y-axis
     */
    public func centerViewToY(yValue: Float64, axis: AxisDependency): Unit {
        let valsInView: Float64 = this.getAxisRange(axis) / this.mViewPortHandler.getScaleY()
    }

    /**
     * This will move the center of the current viewport to the specified
     * x and y value.
     * This also refreshes the chart by calling invalidate().
     *
     * @param xValue
     * @param yValue
     * @param axis   - which axis should be used as a reference for the y axis
     */
    public func centerViewTo(xValue: Float64, yValue: Float64, axis: AxisDependency): Unit {
    }

    /**
     * This will move the center of the current viewport to the specified
     * x and y value animated.
     *
     * @param xValue
     * @param yValue
     * @param axis
     * @param duration the duration of the animation in milliseconds
     */
    public func centerViewToAnimated(xValue: Float64, yValue: Float64, axis: AxisDependency, duration: Float64): Unit {
        let bounds: MPPointD = this.getValuesByTouchPoint(this.mViewPortHandler.contentLeft(),
            this.mViewPortHandler.contentTop(), axis, Option<MPPointD>.None)

        MPPointD.recycleInstance(bounds)
    }

    /**
     * flag that indicates if a custom viewport offset has been set
     */
    private var mCustomViewPortEnabled: Bool = false

    /**
     * Sets custom offsets for the current ViewPort (the offsets on the sides of
     * the actual chart window). Setting this will prevent the chart from
     * automatically calculating it's offsets. Use resetViewPortOffsets() to
     * undo this. ONLY USE THIS WHEN YOU KNOW WHAT YOU ARE DOING, else use
     * setExtraOffsets(...).
     *
     * @param left
     * @param top
     * @param right
     * @param bottom
     */
    public func setViewPortOffsets(left: Float64, top: Float64, right: Float64, bottom: Float64): Unit {
        this.mCustomViewPortEnabled = true
        this.mViewPortHandler.restrainViewPort(left, top, right, bottom)
        this.prepareOffsetMatrix()
        this.prepareValuePxMatrix()
    }

    /**
     * Resets all custom offsets set via setViewPortOffsets(...) method. Allows
     * the chart to again calculate all offsets automatically.
     */
    public func resetViewPortOffsets(): Unit {
        this.mCustomViewPortEnabled = false
        this.calculateOffsets()
    }

    protected func getAxisRange(axis: AxisDependency): Float64 {
        if (axis == AxisDependency.LEFT) {
            if (this.mAxisLeft.isSome()) {
                return this.mAxisLeft().mAxisRange
            } else {
                return 0.0
            }
        } else {
            if (this.mAxisRight.isSome()) {
                return this.mAxisRight().mAxisRange
            } else {
                return 0.0
            }
        }
    }

    /**
     * Sets the OnDrawListener
     *
     * @param drawListener
     */
    public func setOnDrawListener(drawListener: OnDrawListener): Unit {
        this.mDrawListener = drawListener
    }

    /**
     * Gets the OnDrawListener. May be null.
     *
     * @return
     */
    public func getDrawListener(): ?OnDrawListener {
        return this.mDrawListener
    }

    private var mGetPositionBuffer: Array<Float64> = Array<Float64>(2, item: 0.0)

    /**
     * Returns a recyclable MPPointF instance.
     * Returns the position (in pixels) the provided Entry has inside the chart
     * view or null, if the provided Entry is null.
     *
     * @param e
     * @return
     */
    public open func getPosition(e: EntryOhos, axis: AxisDependency): MPPointF {
        this.mGetPositionBuffer[0] = e.getX()
        this.mGetPositionBuffer[1] = e.getY()

        let transformer: ?Transformer = this.getTransformer(axis)
        if (transformer.isSome()) {
            transformer().pointValuesToPixel(this.mGetPositionBuffer)
        }
        return MPPointF.getInstance(this.mGetPositionBuffer[0], this.mGetPositionBuffer[1])
    }

    /**
     * sets the number of maximum visible drawn values on the chart only active
     * when setDrawValues() is enabled
     *
     * @param count
     */
    public func setMaxVisibleValueCount(count: Int64): Unit {
        this.mMaxVisibleCount = count
    }

    public func getMaxVisibleCount(): Int64 {
        return this.mMaxVisibleCount
    }

    /**
     * Set this to true to allow highlighting per dragging over the chart
     * surface when it is fully zoomed out. Default: true
     *
     * @param enabled
     */
    public func setHighlightPerDragEnabled(enabled: Bool): Unit {
        this.mHighlightPerDragEnabled = enabled
    }

    public func isHighlightPerDragEnabled(): Bool {
        return this.mHighlightPerDragEnabled
    }

    /**
     * Sets the color for the background of the chart-drawing area (everything
     * behind the grid lines).
     *
     * @param color
     */
      public func setGridBackgroundColor(color: UInt32 ): Unit  {
        if (let Some(paint) <- this.mGridBackgroundPaint) {
          paint.setColor(Color(color))
        }
      }

    /**
     * Set this to true to enable dragging (moving the chart with the finger)
     * for the chart (this does not effect scaling).
     *
     * @param enabled
     */
    public func setDragEnabled(enabled: Bool): Unit {
        this.mDragXEnabled = enabled
        this.mDragYEnabled = enabled
    }

    /**
     * Returns true if dragging is enabled for the chart, false if not.
     *
     * @return
     */
    public func isDragEnabled(): Bool {
        return this.mDragXEnabled || this.mDragYEnabled
    }

    /**
     * Set this to true to enable dragging on the X axis
     *
     * @param enabled
     */
    public func setDragXEnabled(enabled: Bool): Unit {
        this.mDragXEnabled = enabled
    }

    /**
     * Returns true if dragging on the X axis is enabled for the chart, false if not.
     *
     * @return
     */
    public func isDragXEnabled(): Bool {
        return this.mDragXEnabled
    }

    /**
     * Set this to true to enable dragging on the Y axis
     *
     * @param enabled
     */
    public func setDragYEnabled(enabled: Bool): Unit {
        this.mDragYEnabled = enabled
    }

    /**
     * Returns true if dragging on the Y axis is enabled for the chart, false if not.
     *
     * @return
     */
    public func isDragYEnabled(): Bool {
        return this.mDragYEnabled
    }

    /**
     * Set this to true to enable scaling (zooming in and out by gesture) for
     * the chart (this does not effect dragging) on both X- and Y-Axis.
     *
     * @param enabled
     */
    public func setScaleEnabled(enabled: Bool): Unit {
        this.mScaleXEnabled = enabled
        this.mScaleYEnabled = enabled
    }

    public func setScaleXEnabled(enabled: Bool): Unit {
        this.mScaleXEnabled = enabled
    }

    public func setScaleYEnabled(enabled: Bool): Unit {
        this.mScaleYEnabled = enabled
    }

    public func isScaleXEnabled(): Bool {
        return this.mScaleXEnabled
    }

    public func isScaleYEnabled(): Bool {
        return this.mScaleYEnabled
    }

    /**
     * Set this to true to enable zooming in by double-tap on the chart.
     * Default: enabled
     *
     * @param enabled
     */
    public func setDoubleTapToZoomEnabled(enabled: Bool): Unit {
        this.mDoubleTapToZoomEnabled = enabled
    }

    /**
     * Returns true if zooming via double-tap is enabled false if not.
     *
     * @return
     */
    public func isDoubleTapToZoomEnabled(): Bool {
        return this.mDoubleTapToZoomEnabled
    }

    /**
     * set this to true to draw the grid background, false if not
     *
     * @param enabled
     */
    public func setDrawGridBackground(enabled: Bool): Unit {
        this.mDrawGridBackground = enabled
    }

    /**
     * When enabled, the borders rectangle will be rendered.
     * If this is enabled, there is no point drawing the axis-lines of x- and y-axis.
     *
     * @param enabled
     */
    public func setDrawBorders(enabled: Bool): Unit {
        this.mDrawBorders = enabled
    }

    /**
     * When enabled, the borders rectangle will be rendered.
     * If this is enabled, there is no point drawing the axis-lines of x- and y-axis.
     *
     * @return
     */
    public func isDrawBordersEnabled(): Bool {
        return this.mDrawBorders
    }

    /**
     * When enabled, the values will be clipped to contentRect,
     * otherwise they can bleed outside the content rect.
     *
     * @param enabled
     */
    public func setClipValuesToContent(enabled: Bool): Unit {
        this.mClipValuesToContent = enabled
    }

    /**
     * When disabled, the data and/or highlights will not be clipped to contentRect. Disabling this option can
     *   be useful, when the data lies fully within the content rect, but is drawn in such a way (such as thick lines)
     *   that there is unwanted clipping.
     *
     * @param enabled
     */
    public func setClipDataToContent(enabled: Bool): Unit {
        this.mClipDataToContent = enabled
    }

    /**
     * When enabled, the values will be clipped to contentRect,
     * otherwise they can bleed outside the content rect.
     *
     * @return
     */
    public func isClipValuesToContentEnabled(): Bool {
        return this.mClipValuesToContent
    }

    /**
     * When disabled, the data and/or highlights will not be clipped to contentRect. Disabling this option can
     *   be useful, when the data lies fully within the content rect, but is drawn in such a way (such as thick lines)
     *   that there is unwanted clipping.
     *
     * @return
     */
    public func isClipDataToContentEnabled(): Bool {
        return this.mClipDataToContent
    }

    /**
     * Sets the width of the border lines in vp.
     *
     * @param width
     */
    public func setBorderWidth(width: Float64): Unit {
        if (this.mBorderPaint.isSome()) {
            this.mBorderPaint().setStrokeWidth(Utils.handleDataValues(width))
        }
    }

    /**
     * Sets the color of the chart border lines.
     *
     * @param color
     */
    public func setBorderColor(color: UInt32): Unit {
        if (this.mBorderPaint.isSome()) {
            this.mBorderPaint().setColor(Color(color))
        }
    }

    /**
     * Gets the minimum offset (padding) around the chart, defaults to 15.f
     */
    public func getMinOffset(): Float64 {
        return this.mMinOffset
    }

    /**
     * Sets the minimum offset (padding) around the chart, defaults to 15.f
     */
    public func setMinOffset(minOffset: Float64): Unit {
        this.mMinOffset = minOffset
    }

    /**
     * Returns true if keeping the position on rotation is enabled and false if not.
     */
    public func isKeepPositionOnRotation(): Bool {
        return this.mKeepPositionOnRotation
    }

    /**
     * Sets whether the chart should keep its position (zoom / scroll) after a rotation (orientation change)
     */
    public func setKeepPositionOnRotation(keepPositionOnRotation: Bool): Unit {
        this.mKeepPositionOnRotation = keepPositionOnRotation
    }

    /**
     * Returns a recyclable MPPointD instance
     * Returns the x and y values in the chart at the given touch point
     * (encapsulated in a MPPointD). This method transforms pixel coordinates to
     * coordinates / values in the chart. This is the opposite method to
     * getPixelForValues(...).
     *
     * @param x
     * @param y
     * @return
     */
    public func getValuesByTouchPoint(x: Float64, y: Float64, axis: AxisDependency, outputPoint: ?MPPointD): MPPointD {
        var transformer: ?Transformer = this.getTransformer(axis)
        if (transformer.isNone()) {
            transformer = Transformer(ViewPortHandler())
        }
        return transformer().getValuesByTouchPoint(x, y,
            if (outputPoint.isNone()) {
            MPPointD.getInstance(0.0, 0.0)
        } else {
            outputPoint
        })
    }

    /**
     * Returns a recyclable MPPointD instance
     * Transforms the given chart values into pixels. This is the opposite
     * method to getValuesByTouchPoint(...).
     *
     * @param x
     * @param y
     * @return
     */
    public func getPixelForValues(x: Float64, y: Float64, axis: AxisDependency): MPPointD {
        var transformer: ?Transformer = this.getTransformer(axis)
        if (transformer.isNone()) {
            transformer = Transformer(ViewPortHandler())
        }
        return transformer().getPixelForValues(x, y)
    }

    /**
     * returns the Entry object displayed at the touched position of the chart
     *
     * @param x
     * @param y
     * @return
     */
    public func getEntryByTouchPoint(x: Float64, y: Float64): ?EntryOhos {
        let h: ?Highlight = this.getHighlightByTouchPoint(x, y)
        if (h.isSome() && this.mData.isSome()) {
            return this.mData().getEntryForHighlight(h())
        }
        return None
    }

    /**
     * returns the DataSet object displayed at the touched position of the chart
     *
     * @param x
     * @param y
     * @return
     */
    public func getDataSetByTouchPoint(x: Float64, y: Float64): ?IBarLineScatterCandleBubbleDataSet<EntryOhos> {
        let h: ?Highlight = this.getHighlightByTouchPoint(x, y)
        if (h.isSome() && this.mData.isSome()) {
            return this.mData().getDataSetByIndex(h().getDataSetIndex()) as IBarLineScatterCandleBubbleDataSet<EntryOhos>
        }
        return None
    }

    /**
     * buffer for storing lowest visible x point
     */
    protected var posForGetLowestVisibleX: MPPointD = MPPointD.getInstance(0.0, 0.0)

    /**
     * Returns the lowest x-index (value on the x-axis) that is still visible on
     * the chart.
     *
     * @return
     */
    public open func getLowestVisibleX(): Float64 {
        let transformer: ?Transformer = this.getTransformer(AxisDependency.LEFT)
        if (transformer.isSome()) {
            transformer().getValuesByTouchPoint(this.mViewPortHandler.contentLeft(),
                this.mViewPortHandler.contentBottom(), this.posForGetLowestVisibleX)
        }
        var result: Float64 = this.posForGetLowestVisibleX.x
        if (this.mXAxis.isSome()) {
            result = max(this.mXAxis().mAxisMinimum, this.posForGetLowestVisibleX.x)
        }
        return result
    }

    /**
     * buffer for storing highest visible x point
     */
    protected var posForGetHighestVisibleX: MPPointD = MPPointD.getInstance(0.0, 0.0)

    /**
     * Returns the highest x-index (value on the x-axis) that is still visible
     * on the chart.
     *
     * @return
     */
    public open func getHighestVisibleX(): Float64 {
        let transformer: ?Transformer = this.getTransformer(AxisDependency.LEFT)
        if (transformer.isSome()) {
            transformer().getValuesByTouchPoint(this.mViewPortHandler.contentRight(),
                this.mViewPortHandler.contentBottom(), this.posForGetHighestVisibleX)
        }

        var result: Float64 = this.posForGetHighestVisibleX.x
        if (this.mXAxis.isSome()) {
            result = min(this.mXAxis().mAxisMaximum, this.posForGetHighestVisibleX.x)
        }
        return result
    }

    /**
     * Returns the range visible on the x-axis.
     *
     * @return
     */
    public func getVisibleXRange(): Float64 {
        return abs(this.getHighestVisibleX() - this.getLowestVisibleX())
    }

    /**
     * returns the current x-scale factor
     */
    public func getScaleX(): Float64 {
        return this.mViewPortHandler.getScaleX()
    }

    /**
     * returns the current y-scale factor
     */
    public func getScaleY(): Float64 {
        return this.mViewPortHandler.getScaleY()
    }

    /**
     * if the chart is fully zoomed out, return true
     *
     * @return
     */
    public func isFullyZoomedOut(): Bool {
        return this.mViewPortHandler.isFullyZoomedOut()
    }

    /**
     * Returns the left y-axis object. In the horizontal bar-chart, this is the
     * top axis.
     *
     * @return
     */
    public func getAxisLeft(): ?YAxis {
        return this.mAxisLeft
    }

    /**
     * Returns the right y-axis object. In the horizontal bar-chart, this is the
     * bottom axis.
     *
     * @return
     */
    public func getAxisRight(): ?YAxis {
        return this.mAxisRight
    }

    /**
     * Returns the y-axis object to the corresponding AxisDependency. In the
     * horizontal bar-chart, LEFT == top, RIGHT == BOTTOM
     *
     * @param axis
     * @return
     */
    public func getAxis(axis: AxisDependency): ?YAxis {
        if (axis == AxisDependency.LEFT) {
            return this.mAxisLeft
        } else {
            return this.mAxisRight
        }
    }

    public func isInverted(axis: AxisDependency): Bool {
        let axisObj = this.getAxis(axis)
        return axisObj().isInverted()
    }

    /**
     * If set to true, both x and y axis can be scaled simultaneously with 2 fingers, if false,
     * x and y axis can be scaled separately. default: false
     *
     * @param enabled
     */
    public func setPinchZoom(enabled: Bool): Unit {
        this.mPinchZoomEnabled = enabled
    }

    /**
     * returns true if pinch-zoom is enabled, false if not
     *
     * @return
     */
    public func isPinchZoomEnabled(): Bool {
        return this.mPinchZoomEnabled
    }

    /**
     * Set an offset in vp that allows the user to drag the chart over it's
     * bounds on the x-axis.
     *
     * @param offset
     */
    public func setDragOffsetX(offset: Float64): Unit {
        this.mViewPortHandler.setDragOffsetX(offset)
    }

    /**
     * Set an offset in vp that allows the user to drag the chart over it's
     * bounds on the y-axis.
     *
     * @param offset
     */
    public func setDragOffsetY(offset: Float64): Unit {
        this.mViewPortHandler.setDragOffsetY(offset)
    }

    /**
     * Returns true if both drag offsets (x and y) are zero or smaller.
     *
     * @return
     */
    public func hasNoDragOffset(): Bool {
        return this.mViewPortHandler.hasNoDragOffset()
    }

    public func getRendererXAxis(): ?XAxisRenderer {
        return this.mXAxisRenderer
    }

    /**
     * Sets a custom XAxisRenderer and overrides the existing (default) one.
     *
     * @param xAxisRenderer
     */
    public func setXAxisRenderer(xAxisRenderer: XAxisRenderer): Unit {
        this.mXAxisRenderer = xAxisRenderer
    }

    public func getRendererLeftYAxis(): ?YAxisRenderer {
        return this.mAxisRendererLeft
    }

    /**
     * Sets a custom axis renderer for the left axis and overwrites the existing one.
     *
     * @param rendererLeftYAxis
     */
    public func setRendererLeftYAxis(rendererLeftYAxis: YAxisRenderer): Unit {
        this.mAxisRendererLeft = rendererLeftYAxis
    }

    public func getRendererRightYAxis(): ?YAxisRenderer {
        return this.mAxisRendererRight
    }

    /**
     * Sets a custom axis renderer for the right acis and overwrites the existing one.
     *
     * @param rendererRightYAxis
     */
    public func setRendererRightYAxis(rendererRightYAxis: YAxisRenderer): Unit {
        this.mAxisRendererRight = rendererRightYAxis
    }

    public func getYChartMax(): Float64 {
        if (this.mAxisLeft.isSome() && this.mAxisRight.isSome()) {
            return max(this.mAxisLeft().mAxisMaximum, this.mAxisRight().mAxisMaximum)
        }
        return 0.0
    }

    public func getYChartMin(): Float64 {
        if (this.mAxisLeft.isSome() && this.mAxisRight.isSome()) {
            return min(this.mAxisLeft().mAxisMinimum, this.mAxisRight().mAxisMinimum)
        }
        return 0.0
    }

    /**
     * Returns true if either the left or the right or both axes are inverted.
     *
     * @return
     */
    public func isAnyAxisInverted(): Bool {
        if (this.mAxisLeft.isSome() && this.mAxisLeft().isInverted()) {
            return true
        }
        if (this.mAxisRight.isSome() && this.mAxisRight().isInverted()) {
            return true
        }
        return false
    }

    /**
     * Flag that indicates if auto scaling on the y axis is enabled. This is
     * especially interesting for charts displaying financial data.
     *
     * @param enabled the y axis automatically adjusts to the min and max y
     *                values of the current x axis range whenever the viewport
     *                changes
     */
    public func setAutoScaleMinMaxEnabled(enabled: Bool): Unit {
        this.mAutoScaleMinMaxEnabled = enabled
    }

    /**
     * @return true if auto scaling on the y axis is enabled.
     * @default false
     */
    public func isAutoScaleMinMaxEnabled(): Bool {
        return this.mAutoScaleMinMaxEnabled
    }

    public func setPaint(p: Paint, which: Float64): Unit {
        super.setPaint(p, Int64(which))
        if (which == 4.0) {
            this.mGridBackgroundPaint = p
        }
    }

    public func getPaint(which: Float64): ?Paint {
        let p: ?Paint = super.getPaint(Int64(which))
        if (p.isSome()) {
            return p
        }

        if (which == 4.0) {
            return this.mGridBackgroundPaint
        }

        return None
    }

    public var mOnSizeChangedBuffer: Array<Float64> = Array<Float64>(2, item: 0.0)

    public func onSizeChanged(w: Float64, h: Float64, oldw: Float64, oldh: Float64): Unit {

        // Saving current position of chart.
        this.mOnSizeChangedBuffer[0] = 0.0
        this.mOnSizeChangedBuffer[1] = 0.0

        if (this.mKeepPositionOnRotation) {
            this.mOnSizeChangedBuffer[0] = this.mViewPortHandler.contentLeft()
            this.mOnSizeChangedBuffer[1] = this.mViewPortHandler.contentTop()
            let transformer: ?Transformer = this.getTransformer(AxisDependency.LEFT)
            if (transformer.isSome()) {
                transformer().pixelsToValue(this.mOnSizeChangedBuffer)
            }
        }

        //Superclass transforms chart.
        super.onSizeChanged(w, h, oldw, oldh)

        if (this.mKeepPositionOnRotation) {

            //Restoring old position of chart.
            let transformer: ?Transformer = this.getTransformer(AxisDependency.LEFT)
            if (let Some(t) <- transformer) {
                t.pointValuesToPixel(this.mOnSizeChangedBuffer)
            }
            this.mViewPortHandler.centerViewPort(
                this.mOnSizeChangedBuffer,
                (this as ChartModel<ChartData<IDataSet<EntryOhos>, EntryOhos>, IDataSet<EntryOhos>, EntryOhos>)()
            )
        } else {
            this.mViewPortHandler.refresh(this.mViewPortHandler.getMatrixTouch(), this, true)
        }
    }

    public func getWidth(): Float64 {
        return this.width
    }

    public func getHeight(): Float64 {
        return this.height
    }
}
