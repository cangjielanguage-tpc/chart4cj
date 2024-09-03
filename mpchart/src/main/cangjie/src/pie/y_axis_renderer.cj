/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package mpchart.pie

public open class YAxisRenderer <: AxisRenderer {
    protected var mYAxis: YAxis
    protected var mZeroLinePaint: ChartPaint = ChartPaint()

    public init(viewPortHandler: ViewPortHandler, yAxis: YAxis, trans: ?Transformer) {
        super(viewPortHandler, yAxis, trans)
        this.mYAxis = yAxis

        this.mAxisLabelPaint.setColor(Color.BLACK)
        this.mAxisLabelPaint.setTextSize(10.0)

        this.mZeroLinePaint = ChartPaint()
        this.mZeroLinePaint.setColor(Color.GRAY)
        this.mZeroLinePaint.setStrokeWidth(1.0)
        this.mZeroLinePaint.setStyle(Style.STROKE)
    }

    /**
     * draws the y-axis labels to the screen
     */
    public open func renderAxisLabels(c: CanvasRenderingContext2D): Unit {
        if (!this.mYAxis.isEnabled() || !this.mYAxis.isDrawLabelsEnabled()) {
            return
        }

        let positions: Array<Float64> = this.getTransformedPositions()

        this.mAxisLabelPaint.setFontFamily(this.mYAxis.getTypeface())
        this.mAxisLabelPaint.setTextSize(this.mYAxis.getTextSize())
        this.mAxisLabelPaint.setColor(this.mYAxis.getTextColor())

        let xOffset = this.mYAxis.getXOffset()
        let yOffset = Utils.calcTextHeight(c, this.mAxisLabelPaint, "A") + this.mYAxis.getYOffset()
        let dependency: AxisDependency = this.mYAxis.getAxisDependency()
        let labelPosition: YAxisLabelPosition = this.mYAxis.getLabelPosition()

        var xPos: Float64 = 0.0

        if (dependency == AxisDependency.LEFT) {
            if (labelPosition == YAxisLabelPosition.OUTSIDE_CHART) {
                this.mAxisLabelPaint.setTextAlign(TextAlignStyle.Right)

                xPos = this.mViewPortHandler().offsetLeft() - xOffset
            } else {
                this.mAxisLabelPaint.setTextAlign(TextAlignStyle.Left)

                xPos = this.mViewPortHandler().offsetLeft() + xOffset
            }
        } else {
            if (labelPosition == YAxisLabelPosition.OUTSIDE_CHART) {
                this.mAxisLabelPaint.setTextAlign(TextAlignStyle.Left)

                xPos = this.mViewPortHandler().contentRight() + xOffset
            } else {
                this.mAxisLabelPaint.setTextAlign(TextAlignStyle.Right)

                xPos = this.mViewPortHandler().contentRight() - xOffset
            }
        }

        this.drawYLabels(c, xPos, positions, yOffset)
    }

    public open func renderAxisLine(c: CanvasRenderingContext2D, extraLine!: Float64): Unit {
        if (!this.mYAxis.isEnabled() || !this.mYAxis.isDrawAxisLineEnabled()) {
            return
        }

        this.mAxisLinePaint.setColor(this.mYAxis.getAxisLineColor())
        this.mAxisLinePaint.setStrokeWidth(this.mYAxis.getAxisLineWidth())

        Utils.resetContext2DStyle(c, this.mAxisLinePaint)
        if (this.mYAxis.getAxisDependency() == AxisDependency.LEFT) {
            c.beginPath()
            c.moveTo(this.mViewPortHandler().contentLeft(), this.mViewPortHandler().contentTop())
            c.lineTo(this.mViewPortHandler().contentLeft(), this.mViewPortHandler().contentBottom() + extraLine)
            c.stroke()
            c.closePath()
        } else {
            c.beginPath()
            c.moveTo(this.mViewPortHandler().contentRight(), this.mViewPortHandler().contentTop())
            c.lineTo(this.mViewPortHandler().contentRight(), this.mViewPortHandler().contentBottom() + extraLine)
            c.stroke()
            c.closePath()
        }
    }

    /**
     * draws the y-labels on the specified x-position
     *
     * @param fixedPosition
     * @param positions
     */
    protected open func drawYLabels(c: CanvasRenderingContext2D, fixedPosition: Float64, positions: Array<Float64>,
        offset: Float64): Unit {
        let fromIndex: Int64 = if (this.mYAxis.isDrawBottomYLabelEntryEnabled()) {
            0
        } else {
            1
        }
        let to: Float64 = if (this.mYAxis.isDrawTopYLabelEntryEnabled()) {
            this.mYAxis.mEntryCount
        } else {
            (this.mYAxis.mEntryCount - 1.0)
        }

        let xOffset: Float64 = this.mYAxis.getLabelXOffset()

        // draw
        var i: Int64 = fromIndex
        while (i < Int64(to)) {
            let text: String = this.mYAxis.getFormattedLabel(i)
            let originTextBaseLine: TextBaseline = this.mAxisLabelPaint.getTextBaseline()
            this.mAxisLabelPaint.setTextBaseline(TextBaseline.Middle)
            Utils.resetContext2DStyle(c, this.mAxisLabelPaint)
            match (this.mAxisLabelPaint.getStyle()) {
                case Style.STROKE =>
                    c.beginPath()
                    c.strokeText(text, fixedPosition + xOffset,
                        positions[i * 2 + 1] + offset - Utils.calcTextHeight(c, this.mAxisLabelPaint, text))
                    c.closePath()

                case Style.FILL_AND_STROKE =>
                    c.beginPath()
                    c.fillText(text, fixedPosition + xOffset,
                        positions[i * 2 + 1] + offset - Utils.calcTextHeight(c, this.mAxisLabelPaint, text))
                    c.closePath()
                case Style.FILL =>
                    c.beginPath()
                    c.fillText(text, fixedPosition + xOffset,
                        positions[i * 2 + 1] + offset - Utils.calcTextHeight(c, this.mAxisLabelPaint, text))
                    c.closePath()
                case _ =>
                    c.beginPath()
                    c.fillText(text, fixedPosition + xOffset,
                        positions[i * 2 + 1] + offset - Utils.calcTextHeight(c, this.mAxisLabelPaint, text))
                    c.closePath()
            }
            this.mAxisLabelPaint.setTextBaseline(originTextBaseLine)
            i++
        }
    }

    public func renderGridLines(c: CanvasRenderingContext2D): Unit {
        if (!this.mYAxis.isEnabled()) {
            return
        }

        if (this.mYAxis.isDrawGridLinesEnabled()) {
            c.save()
            c.beginPath()
            let contentRect = this.getGridClippingRect()
            c.rect(contentRect.left, contentRect.top, contentRect.right - contentRect.left,
                contentRect.bottom - contentRect.top)
            c.closePath()
            c.clip()

            let positions: Array<Float64> = this.getTransformedPositions()

            this.mGridPaint.setColor(this.mYAxis.getGridColor())
            this.mGridPaint.setStrokeWidth(this.mYAxis.getGridLineWidth())
            let dashEffect = this.mYAxis.getGridDashPathEffect()
            this.mGridPaint.setDashPathEffect(dashEffect)

            // draw the grid
            var i: Int64 = 0
            while (i < positions.size) {
                Utils.resetContext2DStyle(c, this.mGridPaint)
                c.beginPath()
                this.linePath(c, i, positions)
                c.closePath()
                i += 2
            }

            c.restore()
        }

        if (this.mYAxis.isDrawZeroLineEnabled()) {
            this.drawZeroLine(c)
        }
    }

    protected var mGridClippingRect: MyRect = MyRect()

    public open func getGridClippingRect(): MyRect {
        this.mGridClippingRect.set(this.mViewPortHandler().getContentRect().left,
            this.mViewPortHandler().getContentRect().top, this.mViewPortHandler().getContentRect().right,
            this.mViewPortHandler().getContentRect().bottom)
        if (let Some(mAxis) <- this.mAxis) {
            this.mGridClippingRect.inset(0.0, -mAxis.getGridLineWidth(), 0.0, -mAxis.getGridLineWidth())
        }

        return this.mGridClippingRect
    }

    /**
     * Calculates the path for a grid line.
     *
     * @param p
     * @param i
     * @param positions
     * @return
     */
    protected open func linePath(c: CanvasRenderingContext2D, i: Int64, positions: Array<Float64>): Unit {
        c.beginPath()
        c.moveTo(this.mViewPortHandler().offsetLeft(), positions[i + 1])
        c.lineTo(this.mViewPortHandler().contentRight(), positions[i + 1])
        c.stroke()
        c.closePath()
    }

    protected var mGetTransformedPositionsBuffer: Array<Float64> = Array<Float64>(2, item: 0.0)

    /**
     * Transforms the values contained in the axis entries to screen pixels and returns them in form of a float array
     * of x- and y-coordinates.
     *
     * @return
     */
    protected open func getTransformedPositions(): Array<Float64> {
        if (this.mGetTransformedPositionsBuffer.size != Int64(this.mYAxis.mEntryCount) * 2) {
            this.mGetTransformedPositionsBuffer = Array<Float64>(Int64(this.mYAxis.mEntryCount) * 2, item: 0.0)
        }
        let positions: Array<Float64> = this.mGetTransformedPositionsBuffer

        var i: Int64 = 0
        while (i < positions.size) {
            // only fill y values, x values are not needed for y-labels
            positions[i + 1] = this.mYAxis.mEntries[i / 2]
            i += 2
        }
        if (let Some(mTrans) <- this.mTrans) {
            mTrans.pointValuesToPixel(positions)
        }

        return positions
    }

    // protected mDrawZeroLinePath: Path2D = new Path2D()
    protected var mZeroLineClippingRect: MyRect = MyRect()

    /**
     * Draws the zero line.
     */
    protected open func drawZeroLine(c: CanvasRenderingContext2D): Unit {
        c.save()
        if (this.mViewPortHandler.isSome() && this.mTrans.isSome()) {
            this.mZeroLineClippingRect.set(this.mViewPortHandler().getContentRect().left,
                this.mViewPortHandler().getContentRect().top, this.mViewPortHandler().getContentRect().right,
                this.mViewPortHandler().getContentRect().bottom)
            this.mZeroLineClippingRect.inset(0.0, -this.mYAxis.getZeroLineWidth(), 0.0, -this.mYAxis.getZeroLineWidth())

            c.rect(this.mZeroLineClippingRect.left, this.mZeroLineClippingRect.top,
                this.mZeroLineClippingRect.right - this.mZeroLineClippingRect.left,
                this.mZeroLineClippingRect.bottom - this.mZeroLineClippingRect.top)
            c.clip()

            // draw zero line
            let pos: MPPointD = this.mTrans().getPixelForValues(0.0, 0.0)

            this.mZeroLinePaint.setColor(this.mYAxis.getZeroLineColor())
            this.mZeroLinePaint.setStrokeWidth(this.mYAxis.getZeroLineWidth())

            c.beginPath()
            c.moveTo(this.mViewPortHandler().contentLeft(), pos.y)
            c.lineTo(this.mViewPortHandler().contentRight(), pos.y)

            c.stroke()
            c.closePath()
            c.restore()
        }
    }

    var mRenderLimitLinesBuffer: Array<Float64> = Array<Float64>(2, item: 0.0)
    protected var mLimitLineClippingRect: MyRect = MyRect()

    public func renderLine(c: CanvasRenderingContext2D, l: LimitLine) {
        this.mLimitLineClippingRect.set(this.mViewPortHandler().getContentRect().left,
            this.mViewPortHandler().getContentRect().top, this.mViewPortHandler().getContentRect().right,
            this.mViewPortHandler().getContentRect().bottom)

        this.mLimitLineClippingRect.inset(0.0, -l.getLineWidth(), 0.0, -l.getLineWidth())
        c.beginPath()
        c.rect(this.mLimitLineClippingRect.left, this.mLimitLineClippingRect.top, this.mLimitLineClippingRect.width(),
            this.mLimitLineClippingRect.height())
        c.closePath()
        c.clip()
        this.mLimitLinePaint.setStyle(Style.STROKE)
        this.mLimitLinePaint.setColor(Color(UInt32(l.getLineColor())))
        this.mLimitLinePaint.setStrokeWidth(l.getLineWidth())
        let dashEffect = l.getDashPathEffect()
        this.mLimitLinePaint.setDashPathEffect(dashEffect)

        this.mRenderLimitLinesBuffer[1] = l.getLimit()
        if (let Some(mTrans) <- this.mTrans) {
            mTrans.pointValuesToPixel(this.mRenderLimitLinesBuffer)
        }

        Utils.resetContext2DStyle(c, this.mLimitLinePaint)
        c.beginPath()
        c.moveTo(this.mViewPortHandler().contentLeft(), this.mRenderLimitLinesBuffer[1])
        c.lineTo(this.mViewPortHandler().contentRight(), this.mRenderLimitLinesBuffer[1])
        c.stroke()
        c.closePath()
    }

    public func renderCustomGridLines(c: CanvasRenderingContext2D) {
        let gridLines = this.mYAxis.getGridLines()
        if (gridLines.size <= 0) {
            return
        }

        for (i in 0..gridLines.size) {
            c.save()

            let l: LimitLine = gridLines.get(i)()

            if (!l.isEnabled()) {
                continue
            }

            this.renderLine(c, l)

            c.restore()
        }
    }

    /**
     * Draws the LimitLines associated with this axis to the screen.
     *
     * @param c
     */
    public open func renderLimitLines(c: CanvasRenderingContext2D): Unit {
        let limitLines: ArrayList<LimitLine> = this.mYAxis.getLimitLines()

        if (limitLines.size <= 0) {
            return
        }

        let pts: Array<Float64> = this.mRenderLimitLinesBuffer
        pts[0] = 0.0
        pts[1] = 0.0

        for (i in 0..limitLines.size) {
            let l: LimitLine = limitLines.get(i)()
            if (!l.isEnabled()) {
                continue
            }
            c.save()

            this.renderLine(c, l)
            let label: String = l.getLabel()
            if (label != "") {
                this.mLimitLinePaint.setStyle(l.getTextStyle())
                this.mLimitLinePaint.setDashPathEffect(Option<DashPathEffect>.None)
                this.mLimitLinePaint.setColor(l.getTextColor())
                this.mLimitLinePaint.setFontFamily(l.getTypeface())
                this.mLimitLinePaint.setStrokeWidth(0.5)
                this.mLimitLinePaint.setTextSize(l.getTextSize())
                let labelLineHeight = Utils.calcTextHeight(c, this.mLimitLinePaint, label)
                let xOffset = 4.0 + l.getXOffset()
                let yOffset = l.getLineWidth() + labelLineHeight + l.getYOffset()
                let position: LimitLabelPosition = l.getLabelPosition()
                let paintStyle = this.mLimitLinePaint.getStyle()

                if (position == LimitLabelPosition.RIGHT_TOP) {
                    this.mLimitLinePaint.setTextAlign(TextAlignStyle.Right)
                    Utils.resetContext2DStyle(c, this.mLimitLinePaint)

                    match (paintStyle) {
                        case Style.STROKE =>
                            c.beginPath()
                            c.strokeText(label, this.mViewPortHandler().contentRight() - xOffset,
                                pts[1] - yOffset + labelLineHeight)
                            c.closePath()

                        case Style.FILL =>
                            c.beginPath()
                            c.fillText(label, this.mViewPortHandler().contentRight() - xOffset,
                                pts[1] - yOffset + labelLineHeight)
                            c.closePath()
                        case Style.FILL_AND_STROKE =>
                            c.beginPath()
                            c.fillText(label, this.mViewPortHandler().contentRight() - xOffset,
                                pts[1] - yOffset + labelLineHeight)
                            c.closePath()
                        case _ =>
                            c.beginPath()
                            c.fillText(label, this.mViewPortHandler().contentRight() - xOffset,
                                pts[1] - yOffset + labelLineHeight)
                            c.closePath()
                    }
                } else if (position == LimitLabelPosition.RIGHT_BOTTOM) {
                    this.mLimitLinePaint.setTextAlign(TextAlignStyle.Right)
                    Utils.resetContext2DStyle(c, this.mLimitLinePaint)
                    match (paintStyle) {
                        case Style.STROKE =>
                            c.beginPath()
                            c.strokeText(label, this.mViewPortHandler().contentRight() - xOffset,
                                pts[1] + yOffset - Utils.calcTextHeight(c, this.mLimitLinePaint, label) / 2.0)
                            c.closePath()

                        case Style.FILL =>
                            c.beginPath()
                            c.fillText(label, this.mViewPortHandler().contentRight() - xOffset,
                                pts[1] + yOffset - Utils.calcTextHeight(c, this.mLimitLinePaint, label) / 2.0)
                            c.closePath()
                        case Style.FILL_AND_STROKE =>
                            c.beginPath()
                            c.fillText(label, this.mViewPortHandler().contentRight() - xOffset,
                                pts[1] + yOffset - Utils.calcTextHeight(c, this.mLimitLinePaint, label) / 2.0)
                            c.closePath()
                        case _ =>
                            c.beginPath()
                            c.fillText(label, this.mViewPortHandler().contentRight() - xOffset,
                                pts[1] + yOffset - Utils.calcTextHeight(c, this.mLimitLinePaint, label) / 2.0)
                            c.closePath()
                    }
                } else if (position == LimitLabelPosition.LEFT_TOP) {
                    this.mLimitLinePaint.setTextAlign(TextAlignStyle.Left)
                    Utils.resetContext2DStyle(c, this.mLimitLinePaint)
                    match (paintStyle) {
                        case Style.STROKE =>
                            c.beginPath()
                            c.strokeText(label, this.mViewPortHandler().contentLeft() + xOffset,
                                pts[1] - yOffset + labelLineHeight)
                            c.closePath()

                        case Style.FILL =>
                            c.beginPath()
                            c.fillText(label, this.mViewPortHandler().contentLeft() + xOffset,
                                pts[1] - yOffset + labelLineHeight)
                            c.closePath()
                        case Style.FILL_AND_STROKE =>
                            c.beginPath()
                            c.fillText(label, this.mViewPortHandler().contentLeft() + xOffset,
                                pts[1] - yOffset + labelLineHeight)
                            c.closePath()
                        case _ =>
                            c.beginPath()
                            c.fillText(label, this.mViewPortHandler().contentLeft() + xOffset,
                                pts[1] - yOffset + labelLineHeight)
                            c.closePath()
                    }
                } else {
                    this.mLimitLinePaint.setTextAlign(TextAlignStyle.Left)
                    Utils.resetContext2DStyle(c, this.mLimitLinePaint)
                    match (paintStyle) {
                        case Style.STROKE =>
                            c.beginPath()
                            c.strokeText(label, this.mViewPortHandler().contentLeft() + xOffset,
                                pts[1] + yOffset - Utils.calcTextHeight(c, this.mLimitLinePaint, label) / 2.0)
                            c.closePath()

                        case Style.FILL =>
                            c.beginPath()
                            c.fillText(label, this.mViewPortHandler().contentLeft() + xOffset,
                                pts[1] + yOffset - Utils.calcTextHeight(c, this.mLimitLinePaint, label) / 2.0)
                            c.closePath()
                        case Style.FILL_AND_STROKE =>
                            c.beginPath()
                            c.fillText(label, this.mViewPortHandler().contentLeft() + xOffset,
                                pts[1] + yOffset - Utils.calcTextHeight(c, this.mLimitLinePaint, label) / 2.0)
                            c.closePath()
                        case _ =>
                            c.beginPath()
                            c.fillText(label, this.mViewPortHandler().contentLeft() + xOffset,
                                pts[1] + yOffset - Utils.calcTextHeight(c, this.mLimitLinePaint, label) / 2.0)
                            c.closePath()
                    }
                }
            }
            c.restore()
        }
    }
}
