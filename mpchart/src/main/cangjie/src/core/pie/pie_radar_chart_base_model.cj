/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package core.pie

public abstract class PieRadarChartBaseModel<D, S, E> <: ChartModel<D, S, E> where D <: ChartData<S, E>,
    S <: IDataSet<E>, E <: EntryOhos {
    // holds the normalized version of the current rotation angle of the chart
    private var mRotationAngle: Float64 = 270.0
    // holds the raw version of the current rotation angle of the chart
    private var mRawRotationAngle: Float64 = 270.0
    // flag that indicates if rotation is enabled or not
    protected var mRotateEnabled: Bool = true
    // Sets the minimum offset (padding) around the chart, defaults to 0
    protected var mMinOffset: Float64 = 0.0

    public init() {
        super()
        // 子类去实现
        //this.mChartTouchListener = PieRadarChartTouchListener<D, S, E>(this)
    }

    public func getMaxVisibleCount(): Int64 {
        if (let Some(data) <- this.mData) {
            return data.getEntryCount()
        } else {
            return 0
        }
    }

    public func onTouchEvent(event: TouchEvent): Unit {
        // check if touch gestures are enabled
        if (!this.mTouchEnabled) {
            return
        }
        if (this.mData.isNone()) {
            return
        }

        match (event.eventType) {
            case TouchType.Down => this.mChartTouchListener().actionDown(true, event)
            case TouchType.Move => this.mChartTouchListener().actionMove(true, event)
            case TouchType.Up => this.mChartTouchListener().actionUp(true, event)
            case _ => ()
        }
    }

    public func onSingleTapUp(isTouchEvent: Bool, event: TouchEvent): Unit {
        if (!this.mTouchEnabled) {
            return
        }

        this.mChartTouchListener().onSingleTapUp(isTouchEvent, event)
    }

    public func onSingleTapUp(isTouchEvent: Bool, event: GestureEvent): Unit {
        if (!this.mTouchEnabled) {
            return
        }

        this.mChartTouchListener().onSingleTapUp(isTouchEvent, event)
    }

    public func onDoubleTap(isTouchEvent: Bool, event: TouchEvent): Unit {
        if (!this.mTouchEnabled) {
            return
        }
        this.mChartTouchListener().onDoubleTap(isTouchEvent, event)
    }

    public func onDoubleTap(isTouchEvent: Bool, event: GestureEvent): Unit {
        if (!this.mTouchEnabled) {
            return
        }
        this.mChartTouchListener().onDoubleTap(isTouchEvent, event)
    }

    public func computeScroll(): Unit {
        if (this.mChartTouchListener is PieRadarChartTouchListener<D, S, E>) {
            (this.mChartTouchListener as PieRadarChartTouchListener<D, S, E>)().computeScroll()
        }
    }

    public func notifyDataSetChanged() {
        if (let Some(md: ChartData<IPieDataSet, PiEntry>) <- this.mData) {
            this.calcMinMax()

            this.mLegendRenderer?.computeLegend(md as ChartData<IDataSet<EntryOhos>, EntryOhos>)

            this.calculateOffsets()
        } else {
            return
        }
    }

    public open func calculateOffsets(): Unit {
        var legendLeft: Float64 = 0.0
        var legendRight: Float64 = 0.0
        var legendBottom: Float64 = 0.0
        var legendTop: Float64 = 0.0

        if (this.mLegend.isEnabled() && !this.mLegend.isDrawInsideEnabled()) {
            let fullLegendWidth: Float64 = min(
                this.mLegend.mNeededWidth,
                this.mViewPortHandler.getChartWidth() * this.mLegend.getMaxSizePercent()
            )

            match (this.mLegend.getOrientation()) {
                case LegendOrientation.VERTICAL =>
                    var xLegendOffset: Float64 = 0.0

                    if (this.mLegend.getHorizontalAlignment() == LegendHorizontalAlignment.LEFT ||
                        this.mLegend.getHorizontalAlignment() == LegendHorizontalAlignment.RIGHT) {
                        if (this.mLegend.getVerticalAlignment() == LegendVerticalAlignment.CENTER) {
                            let spacing: Float64 = Utils.handleDataValues(13.0)
                            xLegendOffset = fullLegendWidth + spacing
                        } else {
                            let spacing: Float64 = Utils.handleDataValues(8.0)
                            let legendWidth: Float64 = fullLegendWidth + spacing
                            let legendHeight: Float64 = this.mLegend.mNeededHeight + this.mLegend.mTextHeightMax
                            let center: MPPointF = this.getCenter()
                            let bottomX: Float64 = if (this.mLegend.getHorizontalAlignment() == LegendHorizontalAlignment.
                                RIGHT) {
                                this.getWidth() - legendWidth + 15.0
                            } else {
                                legendWidth - 15.0
                            }
                            let bottomY: Float64 = legendHeight + 15.0
                            let distLegend: Float64 = this.distanceToCenter(bottomX, bottomY)
                            let reference: MPPointF = this.getPosition(center, this.getRadius(),
                                this.getAngleForPoint(bottomX, bottomY))
                            let distReference: Float64 = this.distanceToCenter(reference.x, reference.y)
                            let minOffset: Float64 = Utils.handleDataValues(5.0)

                            if (bottomY >= center.y && this.getHeight() - legendWidth > this.getWidth()) {
                                xLegendOffset = legendWidth
                            } else if (distLegend < distReference) {
                                let diff: Float64 = distReference - distLegend
                                xLegendOffset = minOffset + diff
                            }

                            MPPointF.recycleInstance(center)
                            MPPointF.recycleInstance(reference)
                        }
                    }

                    match (this.mLegend.getHorizontalAlignment()) {
                        case LegendHorizontalAlignment.LEFT => legendLeft = xLegendOffset

                        case LegendHorizontalAlignment.RIGHT => legendRight = xLegendOffset

                        case LegendHorizontalAlignment.CENTER => match (this.mLegend.getVerticalAlignment()) {
                            case LegendVerticalAlignment.TOP => legendTop = min(
                                this.mLegend.mNeededHeight,
                                this.mViewPortHandler.getChartHeight() * this.mLegend.getMaxSizePercent()
                            )

                            case LegendVerticalAlignment.BOTTOM => legendBottom = min(
                                this.mLegend.mNeededHeight,
                                this.mViewPortHandler.getChartHeight() * this.mLegend.getMaxSizePercent()
                            )
                            case _ => ()
                        }
                    }

                case LegendOrientation.HORIZONTAL =>
                    var yLegendOffset: Float64 = 0.0

                    if (this.mLegend.getVerticalAlignment() == LegendVerticalAlignment.TOP ||
                        this.mLegend.getVerticalAlignment() == LegendVerticalAlignment.BOTTOM) {
                        let yOffset: Float64 = this.getRequiredLegendOffset()
                        yLegendOffset = min(
                            this.mLegend.mNeededHeight + yOffset,
                            this.mViewPortHandler.getChartHeight() * this.mLegend.getMaxSizePercent()
                        )
                        match (this.mLegend.getVerticalAlignment()) {
                            case LegendVerticalAlignment.TOP => legendTop = yLegendOffset

                            case LegendVerticalAlignment.BOTTOM => legendBottom = yLegendOffset
                            case _ => ()
                        }
                    }
            }

            legendLeft += this.getRequiredBaseOffset()
            legendRight += this.getRequiredBaseOffset()
            legendTop += this.getRequiredBaseOffset()
            legendBottom += this.getRequiredBaseOffset()
        }

        let minOffset: Float64 = Utils.handleDataValues(this.mMinOffset)

        //    if (this is RadarChartModel) {
        //      const x: XAxis = this.getXAxis()
        //      if (x.isEnabled() && x.isDrawLabelsEnabled()) {
        //        minOffset = Math.max(minOffset, x.mLabelRotatedWidth)
        //      }
        //    }

        legendTop += this.getExtraTopOffset()
        legendRight += this.getExtraRightOffset()
        legendBottom += this.getExtraBottomOffset()
        legendLeft += this.getExtraLeftOffset()

        let offsetLeft: Float64 = max(minOffset, legendLeft)
        let offsetTop: Float64 = max(minOffset, legendTop)
        let offsetRight: Float64 = max(minOffset, legendRight)
        let offsetBottom: Float64 = max(minOffset, max(this.getRequiredBaseOffset(), legendBottom))

        this.mViewPortHandler.restrainViewPort(offsetLeft, offsetTop, offsetRight, offsetBottom)

        if (this.mLogEnabled) {
            AppLog.info(
                "offsetLeft: ${offsetLeft}, offsetTop: ${offsetTop}, offsetRight: ${offsetRight}, offsetBottom: ${offsetBottom}"
            )
        }
    }

    /**
     * returns the angle relative to the chart center for the given point on the
     * chart in degrees. The angle is always between 0 and 360°, 0° is NORTH,
     * 90° is EAST, ...
     *
     * @param x
     * @param y
     * @return
     */
    public func getAngleForPoint(x: Float64, y: Float64): Float64 {
        let c: ?MPPointF = this.getCenterOffsets()
        if (c.isNone()) {
            return 0.0
        }

        let tx: Float64 = x - c().x
        let ty: Float64 = y - c().y
        let length: Float64 = sqrt(tx * tx + ty * ty)
        let r: Float64 = acos(ty / length)

        var angle: Float64 = this.toDegrees(r)

        if (x > c().x) {
            angle = 360.0 - angle
        }

        angle = angle + 90.0 // add 90° because chart starts EAST

        if (angle > 360.0) {
            angle = angle - 360.0 // neutralize overflow
        }

        MPPointF.recycleInstance(c())

        return angle
    }

    public func getPosition(center: MPPointF, dist: Float64, angle: Float64): MPPointF {
        let p: MPPointF = MPPointF.getInstance(0.0, 0.0)
        this.getPositionWithOutputPoint(center, dist, angle, p)
        return p
    }

    public func getPositionWithOutputPoint(center: MPPointF, dist: Float64, angle: Float64, outputPoint: MPPointF): Unit {
        outputPoint.x = center.x + dist * cos(this.toRadians(angle))
        outputPoint.y = center.y + dist * sin(this.toRadians(angle))
    }

    /**
     * returns the angle relative to the chart center for the given point on the
     * chart in degrees. The angle is always between 0 and 360°, 0° is NORTH,
     * 90° is EAST, ...
     *
     * @param x
     * @param y
     * @return
     */
    public func distanceToCenter(x: Float64, y: Float64): Float64 {
        let c: ?MPPointF = this.getCenterOffsets()
        if (c.isNone()) {
            return 0.0
        }
        var dist: Float64 = 0.0
        var xDist: Float64 = 0.0
        var yDist: Float64 = 0.0

        if (x > c().x) {
            xDist = x - c().x
        } else {
            xDist = c().x - x
        }

        if (y > c().y) {
            yDist = y - c().y
        } else {
            yDist = c().y - y
        }

        // pythagoras
        dist = sqrt(pow(xDist, 2.0) + pow(yDist, 2.0))

        MPPointF.recycleInstance(c())

        return dist
    }

    /**
     * Returns the xIndex for the given angle around the center of the chart.
     * Returns -1 if not found / outofbounds.
     *
     * @param angle
     * @return
     */
    public func getIndexForAngle(angle: Float64): Int64

    /**
     * Set an offset for the rotation of the RadarChart in degrees. Default 270f
     * --> top (NORTH)
     *
     * @param angle
     */
    public func setRotationAngle(angle: Float64): Unit {
        this.mRawRotationAngle = angle
        this.mRotationAngle = Utils.getNormalizedAngle(this.mRawRotationAngle)
    }

    /**
     * gets the raw version of the current rotation angle of the pie chart the
     * returned value could be any value, negative or positive, outside of the
     * 360 degrees. this is used when working with rotation direction, mainly by
     * gestures and animations.
     *
     * @return
     */
    public func getRawRotationAngle(): Float64 {
        return this.mRawRotationAngle
    }

    /**
     * gets a normalized version of the current rotation angle of the pie chart,
     * which will always be between 0.0 < 360.0
     *
     * @return
     */
    public func getRotationAngle(): Float64 {
        return this.mRotationAngle
    }

    /**
     * Set this to true to enable the rotation / spinning of the chart by touch.
     * Set it to false to disable it. Default: true
     *
     * @param enabled
     */
    public func setRotationEnabled(enabled: Bool): Unit {
        this.mRotateEnabled = enabled
    }

    /**
     * Returns true if rotation of the chart by touch is enabled, false if not.
     *
     * @return
     */
    public func isRotationEnabled(): Bool {
        return this.mRotateEnabled
    }

    /**
     * Gets the minimum offset (padding) around the chart, defaults to 0.f
     */
    public func getMinOffset(): Float64 {
        return this.mMinOffset
    }

    /**
     * Sets the minimum offset (padding) around the chart, defaults to 0.f
     */
    public func setMinOffset(minOffset: Float64): Unit {
        this.mMinOffset = minOffset
    }

    /**
     * returns the diameter of the pie- or radar-chart
     *
     * @return
     */
    public func getDiameter(): Float64 {
        let content: MyRect = this.mViewPortHandler.getContentRect()
        content.left += this.getExtraLeftOffset()
        content.top += this.getExtraTopOffset()
        content.right -= this.getExtraRightOffset()
        content.bottom -= this.getExtraBottomOffset()
        return min(content.width(), content.height())
    }

    /**
     * Returns the radius of the chart in pixels.
     *
     * @return
     */
    public func getRadius(): Float64

    /**
     * Returns the required offset for the chart legend.
     *
     * @return
     */
    protected func getRequiredLegendOffset(): Float64

    /**
     * Returns the base offset needed for the chart without calculating the
     * legend size.
     *
     * @return
     */
    protected func getRequiredBaseOffset(): Float64

    public func getYChartMin(): Float64 {
        return 0.0
    }

    public func getYChartMax(): Float64 {
        return 0.0
    }

    private func toDegrees(radians: Float64): Float64 {
        return radians * (180.0 / Float64.PI)
    }

    private func toRadians(degrees: Float64): Float64 {
        return degrees * (Float64.PI / 180.0)
    }
}
