/**
 * Created on 2024/4/25
 */
package core.pie

/**
 * Created on 2024/4/22
 */
public open class XAxisRenderer <: AxisRenderer {
    protected var mXAxis: XAxis

    public init(viewPortHandler: ViewPortHandler, xAxis: XAxis, trans: Transformer) {
        super(viewPortHandler, xAxis, trans)
        this.mXAxis = xAxis
        this.mAxisLabelPaint.setColor(Color.BLACK)
        this.mAxisLabelPaint.setTextAlign(TextAlignStyle.Center)
        this.mAxisLabelPaint.setTextSize(10.0)
    }
    protected func setupGridPaint() {
        this.mGridPaint.setColor(this.mXAxis.getGridColor())
        this.mGridPaint.setStrokeWidth(this.mXAxis.getGridLineWidth())
        let dashPathEffect = this.mAxis.getGridDashPathEffect()
        this.mGridPaint.setDashPathEffect(dashPathEffect)
    }

    public open func computeAxis(min: Float64, max: Float64, inverted: Bool) {
        var mins: Float64 = min
        var maxs: Float64 = max
        if (this.mViewPortHandler().contentWidth() > 10.0 && !this.mViewPortHandler().isFullyZoomedOutX()) {
            let p1: MPPointD = this.mTrans.getValuesByTouchPoint(
                this.mViewPortHandler().contentLeft(),
                this.mViewPortHandler().contentTop(),
                Option<MPPointD>.None
            )
            let p2: MPPointD = this.mTrans.getValuesByTouchPoint(
                this.mViewPortHandler().contentRight(),
                this.mViewPortHandler().contentTop(),
                Option<MPPointD>.None
            )

            if (inverted) {
                mins = p2.x
                maxs = p1.x
            } else {
                mins = p1.x
                maxs = p2.x
            }

            MPPointD.recycleInstance(p1)
            MPPointD.recycleInstance(p2)
        }

        this.computeAxisValues(min, max)
    }

    //     @Override
    protected func computeAxisValues(min: Float64, max: Float64) {
        if (this.mXAxis.isDrawCustomLabels()) {
            let labels = (this.mXAxis as XAxis)().getCustomLabels()
            this.mXAxis.mEntries = ArrayList<Float64>(labels)
            this.mXAxis.mCenteredEntries = ArrayList<Float64>(labels)
            this.mXAxis.mEntryCount = Float64(labels.size)
        } else {
            super.computeAxisValues(min, max)
        }
        this.computeSize()
    }

    protected open func computeSize() {
        let longest: String = this.mXAxis.getLongestLabel()

        this.mAxisLabelPaint.setFontFamily(this.mXAxis.getTypeface())
        this.mAxisLabelPaint.setTextSize(this.mXAxis.getTextSize())

        let labelSize: FSize = Utils.calcTextSize(this.mAxisLabelPaint, longest)

        let labelWidth = labelSize.width
        let labelHeight = Utils.calcTextHeight(this.mAxisLabelPaint, "Q")

        let labelRotatedSize: FSize = Utils.getSizeOfRotatedRectangleByDegrees(
            labelWidth,
            labelHeight,
            Float64(this.mXAxis.getLabelRotationAngle())
        )

        this.mXAxis.mLabelWidth = Int64(round(labelWidth))
        this.mXAxis.mLabelHeight = Int64(round(labelHeight))
        this.mXAxis.mLabelRotatedWidth = Int64(round(labelRotatedSize.width))
        this.mXAxis.mLabelRotatedHeight = Int64(round(labelRotatedSize.height))

        FSize.recycleInstance(labelRotatedSize)
        FSize.recycleInstance(labelSize)
    }

    public open func renderAxisLabels(c: CanvasRenderingContext2D): Unit {
        if (!this.mXAxis.isEnabled() || !this.mXAxis.isDrawLabelsEnabled()) {
            return
        }

        let yoffset = this.mXAxis.getYOffset()

        this.mAxisLabelPaint.setFontFamily(this.mXAxis.getTypeface())
        this.mAxisLabelPaint.setTextSize(this.mXAxis.getTextSize())
        this.mAxisLabelPaint.setColor(this.mXAxis.getTextColor())

        let pointF: MPPointF = MPPointF.getInstance(0.0, 0.0)
        if (this.mXAxis.getPosition() == XAxisPosition.TOP) {
            pointF.x = 0.5
            pointF.y = 1.0
            this.drawLabels(c, this.mViewPortHandler().contentTop() - yoffset, pointF)
        } else if (this.mXAxis.getPosition() == XAxisPosition.TOP_INSIDE) {
            pointF.x = 0.5
            pointF.y = 1.0
            this.drawLabels(c, this.mViewPortHandler().contentTop() + yoffset + Float64(this.mXAxis.mLabelRotatedHeight),
                pointF)
        } else if (this.mXAxis.getPosition() == XAxisPosition.BOTTOM) {
            pointF.x = 0.5
            pointF.y = 0.0
            this.drawLabels(c, this.mViewPortHandler().contentBottom() + yoffset, pointF)
        } else if (this.mXAxis.getPosition() == XAxisPosition.BOTTOM_INSIDE) {
            pointF.x = 0.5
            pointF.y = 0.0
            this.drawLabels(c,
                this.mViewPortHandler().contentBottom() - yoffset - Float64(this.mXAxis.mLabelRotatedHeight), pointF)
        } else { // BOTH SIDED

            pointF.x = 0.5
            pointF.y = 1.0
            this.drawLabels(c, this.mViewPortHandler().contentTop() - yoffset, pointF)
            pointF.x = 0.5
            pointF.y = 0.0
            this.drawLabels(c, this.mViewPortHandler().contentBottom() + yoffset, pointF)
        }
        MPPointF.recycleInstance(pointF)
    }

    public func renderAxisLine(c: CanvasRenderingContext2D, extraLine!: Float64): Unit {
        this.mAxisLinePaint.setColor(this.mXAxis.getAxisLineColor())
        this.mAxisLinePaint.setStrokeWidth(this.mXAxis.getAxisLineWidth())
        this.mAxisLinePaint.setDashPathEffect(this.mXAxis.getAxisLineDashPathEffect())

        // 重置更新Context上下文样式
        Utils.resetContext2DStyle(c, this.mAxisLinePaint)
        let left = this.mViewPortHandler().contentLeft()
        let top = this.mViewPortHandler().contentTop()
        let right = this.mViewPortHandler().contentRight()
        let bottom = this.mViewPortHandler().contentBottom()

        if (this.mXAxis.getPosition() == XAxisPosition.TOP || this.mXAxis.getPosition() == XAxisPosition.TOP_INSIDE ||
            this.mXAxis.getPosition() == XAxisPosition.BOTH_SIDED) {
            c.beginPath()
            c.moveTo(left, top)
            c.lineTo(right, top)
            c.stroke()
            c.closePath()
        }

        if (this.mXAxis.getPosition() == XAxisPosition.BOTTOM || this.mXAxis.getPosition() == XAxisPosition.
            BOTTOM_INSIDE || this.mXAxis.getPosition() == XAxisPosition.BOTH_SIDED) {
            c.beginPath()
            c.moveTo(left, bottom)
            c.lineTo(right, bottom)
            c.stroke()
            c.closePath()
        }
    }

    /**
     * draws the x-labels on the specified y-position
     *
     * @param pos
     */
    protected open func drawLabels(c: CanvasRenderingContext2D, pos: Float64, anchor: MPPointF): Unit {
        let labelRotationAngleDegrees = this.mXAxis.getLabelRotationAngle()
        let centeringEnabled = this.mXAxis.isCenterAxisLabelsEnabled()

        let positions: Array<Float64> = Array<Float64>(Int64(this.mXAxis.mEntryCount) * 2, item: 0.0)

        let labelPosition: XAxisLabelPosition = this.mXAxis.getXAxisLabelPosition()
        var i: Int64 = 0
        while (i < positions.size) {
            // only fill x values
            if (centeringEnabled) {
                positions[i] = this.mXAxis.mCenteredEntries[i / 2]
            } else {
                positions[i] = this.mXAxis.mEntries[i / 2]
            }
            i += 2
        }

        this.mTrans.pointValuesToPixel(positions)

        let xOffset: Float64 = Float64(this.mXAxis.getLabelXOffset())
        i = 0
        while (i < positions.size) {
            var x = positions[i] + xOffset

            // if (this.mViewPortHandler && this.mViewPortHandler.isInBoundsX(this.getXRelativeValue(x)/this.getAxisPercent())) {
            if (this.mViewPortHandler().isInBoundsX(x)) {
                let label = this.mXAxis.getValueFormatter()().getFormattedValue(this.mXAxis.mEntries[i / 2], this.mXAxis)

                if (this.mXAxis.isAvoidFirstLastClippingEnabled()) {

                    // avoid clipping of the last
                    if (Float64(i / 2) == this.mXAxis.mEntryCount - 1.0 && this.mXAxis.mEntryCount > 1.0) {
                        let width = Utils.calcTextWidth(this.mAxisLabelPaint, label)

                        if (width > this.mViewPortHandler().offsetRight() * 2.0 && x + width >
                            this.mViewPortHandler().getChartWidth()) {
                            x -= width / 2.0
                        }

                    // avoid clipping of the first
                    } else if (i == 0) {
                        let width = Utils.calcTextWidth(this.mAxisLabelPaint, label)
                        x += width / 2.0
                    }
                }

                this.drawLabel(c, label, x, pos, anchor, Float64(labelRotationAngleDegrees),
                    labelPosition: labelPosition)
            }
            i += 2
        }
    }

    protected func drawLabel(c: CanvasRenderingContext2D, formattedLabel: String, x: Float64, y: Float64,
        anchor: MPPointF, angleDegrees: Float64, labelPosition!: XAxisLabelPosition = XAxisLabelPosition.CENTER): Unit {
        Utils.drawXAxisValue(c, formattedLabel, x, y, this.mAxisLabelPaint, anchor, angleDegrees, labelPosition)
    }

    protected var mRenderGridLinesBuffer: Array<Float64> = Array<Float64>(2, item: 0.0)

    public func renderGridLines(c: CanvasRenderingContext2D): Unit {
        if (!this.mXAxis.isDrawGridLinesEnabled() || !this.mXAxis.isEnabled()) {
            return
        }
        c.save()
        c.beginPath()
        let clippingRect = this.getGridClippingRect()
        c.rect(clippingRect.left, clippingRect.top, clippingRect.width(), clippingRect.height())
        c.closePath()
        c.clip()

        if (this.mRenderGridLinesBuffer.size != Int64(this.mAxis.mEntryCount * 2.0)) {
            this.mRenderGridLinesBuffer = Array<Float64>(Int64(this.mXAxis.mEntryCount * 2.0), item: 0.0)
        }
        let positions: Array<Float64> = this.mRenderGridLinesBuffer

        var i: Int64 = 0
        while (i < positions.size) {
            positions[i] = this.mXAxis.mEntries[i / 2]
            positions[i + 1] = this.mXAxis.mEntries[i / 2]
            i += 2
        }

        this.mTrans.pointValuesToPixel(positions)

        this.setupGridPaint()

        i = 0
        while (i < positions.size) {
            this.drawGridLine(c, positions[i], positions[i + 1])
            i += 2
        }

        c.restore()
    }

    protected var mGridClippingRect: MyRect = MyRect()

    public open func getGridClippingRect(): MyRect {
        match (this.mViewPortHandler) {
            case Some(m) => this.mGridClippingRect.set(m.getContentRect().left, m.getContentRect().top,
                m.getContentRect().right, m.getContentRect().bottom)
            case _ => ()
        }

        this.mGridClippingRect.inset(-this.mAxis.getGridLineWidth(), 0.0, -this.mAxis.getGridLineWidth(), 0.0)

        return this.mGridClippingRect
    }

    /**
     * Draws the grid line at the specified position using the provided path.
     *
     * @param c
     * @param x
     * @param y
     * @param gridLinePath
     */
    protected open func drawGridLine(c: CanvasRenderingContext2D, x: Float64, y: Float64): Unit {
        Utils.resetContext2DStyle(c, this.mGridPaint)
        c.beginPath()
        let moveToY: Float64 = match (this.mViewPortHandler) {
            case Some(m) => m.contentBottom()
            case None => 0.0
        }
        c.moveTo(x, moveToY)
        let lineToY: Float64 = match (this.mViewPortHandler) {
            case Some(m) => m.contentTop()
            case None => 0.0
        }

        c.lineTo(x, lineToY)
        c.stroke()
        c.closePath()
    }

    protected var mRenderLimitLinesBuffer = Array<Float64>(2, item: 0.0)
    protected var mLimitLineClippingRect = MyRect()

    private func renderLinesInner(c: CanvasRenderingContext2D, lines: ?ArrayList<LimitLine>) {
        if (lines.isNone() || lines().size <= 0) {
            return
        }

        let position = this.mRenderLimitLinesBuffer
        position[0] = 0.0
        position[1] = 0.0

        for (i in 0..lines().size) {
            let l: LimitLine = lines().get(i)()
            if (!l.isEnabled()) {
                continue
            }
            c.save()
            if (this.mViewPortHandler.isSome()) {
                this.mLimitLineClippingRect.set(this.mViewPortHandler().getContentRect().left,
                    this.mViewPortHandler().getContentRect().top, this.mViewPortHandler().getContentRect().right,
                    this.mViewPortHandler().getContentRect().bottom)
            }

            this.mGridClippingRect.inset(-this.mAxis.getGridLineWidth(), 0.0, -this.mAxis.getGridLineWidth(), 0.0)

            position[0] = l.getLimit()
            position[1] = 0.0

            this.mTrans.pointValuesToPixel(position)

            this.renderLimitLineLine(c, l, position)
            this.renderLimitLineLabel(c, l, position, 2.0 + l.getYOffset())
            c.restore()
        }
    }

    /**
     * render custom grid lines.
     *
     * @param c
     */
    public func renderCustomGridLines(c: CanvasRenderingContext2D) {
        let gridLines = this.mXAxis.getGridLines()

        // && this.renderLinesInner(c, gridLines)
    }

    /**
     * return the LimitLines draw data.
     *
     * @param c
     */
    public open func renderLimitLines(c: CanvasRenderingContext2D): Unit {
        let limitLines = this.mXAxis.getLimitLines()

        //limitLines && this.renderLinesInner(c, limitLines)
    }

    public var mLimitLineSegmentsBuffer: ArrayList<Float64> = ArrayList<Float64>(4)

    public func renderLimitLineLine(c: CanvasRenderingContext2D, limitLine: LimitLine, position: Array<Float64>): Unit {
        this.mLimitLineSegmentsBuffer[0] = position[0]
        this.mLimitLineSegmentsBuffer[1] = if (this.mViewPortHandler.isSome()) {
            this.mViewPortHandler().contentTop()
        } else {
            0.0
        }
        this.mLimitLineSegmentsBuffer[2] = position[0]
        this.mLimitLineSegmentsBuffer[3] = if (this.mViewPortHandler.isSome()) {
            this.mViewPortHandler().contentBottom()
        } else {
            0.0
        }

        this.mLimitLinePaint.setStyle(Style.STROKE)
        this.mLimitLinePaint.setColor(Color(UInt32(limitLine.getLineColor())))
        this.mLimitLinePaint.setStrokeWidth(limitLine.getLineWidth())
        let dashPathEffect = limitLine.getDashPathEffect()
        if (dashPathEffect.isSome()) {
            this.mLimitLinePaint.setDashPathEffect(dashPathEffect)
        }

        Utils.resetContext2DStyle(c, this.mLimitLinePaint)
        c.beginPath()
        c.moveTo(this.mLimitLineSegmentsBuffer[0], this.mLimitLineSegmentsBuffer[1])
        c.lineTo(this.mLimitLineSegmentsBuffer[2], this.mLimitLineSegmentsBuffer[3])
        c.stroke()
        c.closePath()
    }

    public func renderLimitLineLabel(c: CanvasRenderingContext2D, limitLine: LimitLine, position: Array<Float64>,
        yOffset: Float64): Unit {
        let label: String = limitLine.getLabel()

        // if drawing the limit-value label is enabled
        if (label.size > 0) {
            this.mLimitLinePaint.setStyle(limitLine.getTextStyle())
            this.mLimitLinePaint.setDashPathEffect(Option<DashPathEffect>.None)
            this.mLimitLinePaint.setColor(limitLine.getTextColor())
            this.mLimitLinePaint.setStrokeWidth(0.5)
            this.mLimitLinePaint.setTextSize(limitLine.getTextSize())

            let xOffset = limitLine.getLineWidth() + limitLine.getXOffset()

            let labelPosition: LimitLabelPosition = limitLine.getLabelPosition()
            let paintStyle = this.mLimitLinePaint.getStyle()

            if (labelPosition == LimitLabelPosition.RIGHT_TOP) {
                let labelLineHeight = Utils.calcTextHeight(this.mLimitLinePaint, label)
                this.mLimitLinePaint.setTextAlign(TextAlignStyle.Left)

                Utils.resetContext2DStyle(c, this.mLimitLinePaint)
                match (paintStyle) {
                    case Style.STROKE =>
                        c.beginPath()
                        c.strokeText(label, position[0] + xOffset,
                            if (this.mViewPortHandler.isSome()) {
                            this.mViewPortHandler().contentTop()
                        } else {
                            0.0
                        } + yOffset + labelLineHeight)
                        c.closePath()

                    case Style.FILL => ()
                    case Style.FILL_AND_STROKE => ()
                    case _ =>
                        c.beginPath()
                        c.fillText(label, position[0] + xOffset,
                            if (this.mViewPortHandler.isSome()) {
                            this.mViewPortHandler().contentTop()
                        } else {
                            0.0
                        } + yOffset + labelLineHeight)
                        c.closePath()
                }
            } else if (labelPosition == LimitLabelPosition.RIGHT_BOTTOM) {
                this.mLimitLinePaint.setTextAlign(TextAlignStyle.Left)

                Utils.resetContext2DStyle(c, this.mLimitLinePaint)
                match (paintStyle) {
                    case Style.STROKE =>
                        c.beginPath()
                        c.strokeText(label, position[0] + xOffset,
                            if (this.mViewPortHandler.isSome()) {
                            this.mViewPortHandler().contentBottom()
                        } else {
                            0.0
                        } - yOffset)
                        c.closePath()

                    case Style.FILL => ()
                    case Style.FILL_AND_STROKE =>
                        ()

                        c.beginPath()
                        c.fillText(label, position[0] + xOffset,
                            if (this.mViewPortHandler.isSome()) {
                            this.mViewPortHandler().contentBottom()
                        } else {
                            0.0
                        } - yOffset)
                        c.closePath()
                }
            } else if (labelPosition == LimitLabelPosition.LEFT_TOP) {
                this.mLimitLinePaint.setTextAlign(TextAlignStyle.Right)
                let labelLineHeight = Utils.calcTextHeight(this.mLimitLinePaint, label)

                Utils.resetContext2DStyle(c, this.mLimitLinePaint)
                match (paintStyle) {
                    case Style.STROKE =>
                        c.beginPath()
                        c.strokeText(label, position[0] - xOffset,
                            if (this.mViewPortHandler.isSome()) {
                            this.mViewPortHandler().contentTop()
                        } else {
                            0.0
                        } + yOffset + labelLineHeight)
                        c.closePath()

                    case Style.FILL => ()
                    case Style.FILL_AND_STROKE =>
                        ()

                        c.beginPath()
                        c.fillText(label, position[0] - xOffset,
                            if (this.mViewPortHandler.isSome()) {
                            this.mViewPortHandler().contentTop()
                        } else {
                            0.0
                        } + yOffset + labelLineHeight)
                        c.closePath()
                }
            } else {
                this.mLimitLinePaint.setTextAlign(TextAlignStyle.Right)
                Utils.resetContext2DStyle(c, this.mLimitLinePaint)
                match (paintStyle) {
                    case Style.STROKE =>
                        c.beginPath()
                        c.strokeText(label, position[0] - xOffset,
                            if (this.mViewPortHandler.isSome()) {
                            this.mViewPortHandler().contentBottom()
                        } else {
                            0.0
                        } - yOffset)
                        c.closePath()

                    case Style.FILL => ()
                    case Style.FILL_AND_STROKE => ()
                    case _ =>
                        c.beginPath()
                        c.fillText(label, position[0] - xOffset,
                            if (this.mViewPortHandler.isSome()) {
                            this.mViewPortHandler().contentBottom()
                        } else {
                            0.0
                        } - yOffset)
                        c.closePath()
                }
            }
        }
    }
}
