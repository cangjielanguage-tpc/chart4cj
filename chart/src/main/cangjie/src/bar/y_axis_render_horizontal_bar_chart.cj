/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package chart.bar

public class YAxisRendererHorizontalBarChart <: YAxisRenderer {
    public init(viewPortHandler: ViewPortHandler, yAxis: YAxis, trans: Transformer) {
        super(viewPortHandler, yAxis, trans)
        this.mLimitLinePaint.setTextAlign(TextAlignStyle.Left)
    }

    public func computeAxis(yMin: Float64, yMax: Float64, inverted: Bool): Unit {
        if (this.mTrans.isNone() || this.mViewPortHandler.isNone()) {
            return;
        }
        var mins: Float64 = yMin
        var maxs: Float64 = yMax
        if (let Some(handle) <- this.mViewPortHandler) {
            // calculate the starting and entry point of the y-labels (depending on
            // zoom / contentrect bounds)
            if (handle.contentHeight() > 10.0 && !handle.isFullyZoomedOutX()) {
                let p1: MPPointD = this.mTrans().getValuesByTouchPoint(handle.contentLeft(), handle.contentTop(),
                    Option<MPPointD>.None)
                let p2: MPPointD = this.mTrans().getValuesByTouchPoint(handle.contentRight(), handle.contentTop(),
                    Option<MPPointD>.None)

                if (!inverted) {
                    mins = p1.x
                    maxs = p2.x
                } else {
                    mins = p2.x
                    maxs = p1.x
                }

                MPPointD.recycleInstance(p1)
                MPPointD.recycleInstance(p2)
            }

            this.computeAxisValues(yMin, yMax)
        } else {
            return
        }
    }

    public func renderAxisLabels(c: CanvasRenderingContext2D): Unit {
        if (!this.mYAxis.isEnabled() || !this.mYAxis.isDrawLabelsEnabled() || this.mViewPortHandler.isNone()) {
            return
        }
        let positions: Array<Float64> = this.getTransformedPositions()

        this.mAxisLabelPaint.setFontFamily(this.mYAxis.getTypeface())
        this.mAxisLabelPaint.setTextSize(this.mYAxis.getTextSize())
        this.mAxisLabelPaint.setColor(this.mYAxis.getTextColor())
        this.mAxisLabelPaint.setTextAlign(TextAlignStyle.Center)

        let baseYOffset = Utils.handleDataValues(2.5)
        let textHeight = Utils.calcTextHeight(c, this.mAxisLabelPaint, "Q")

        let dependency: AxisDependency = this.mYAxis.getAxisDependency()
        let labelPosition: YAxisLabelPosition = this.mYAxis.getLabelPosition()

        var yPos: Float64 = 0.0

        if (dependency == AxisDependency.LEFT) {
            if (labelPosition == YAxisLabelPosition.OUTSIDE_CHART) {
                yPos = this.mViewPortHandler().contentTop() - baseYOffset
            } else {
                yPos = this.mViewPortHandler().contentTop() - baseYOffset
            }
        } else {
            if (labelPosition == YAxisLabelPosition.OUTSIDE_CHART) {
                yPos = this.mViewPortHandler().contentBottom() + textHeight + baseYOffset
            } else {
                yPos = this.mViewPortHandler().contentBottom() + textHeight + baseYOffset
            }
        }
        this.drawYLabels(c, yPos, positions, this.mYAxis.getYOffset())
    }

    public func renderAxisLine(c: CanvasRenderingContext2D, extraLine!: Float64) {
        if (!this.mYAxis.isEnabled() || !this.mYAxis.isDrawAxisLineEnabled() || this.mViewPortHandler.isNone()) {
            return
        }

        this.mAxisLinePaint.setColor(this.mYAxis.getAxisLineColor())
        this.mAxisLinePaint.setStrokeWidth(this.mYAxis.getAxisLineWidth())

        if (this.mYAxis.getAxisDependency() == AxisDependency.LEFT) {
            Utils.resetContext2DStyle(c, this.mAxisLinePaint)
            c.beginPath()
            c.moveTo(this.mViewPortHandler().contentLeft(), this.mViewPortHandler().contentTop())
            c.lineTo(this.mViewPortHandler().contentRight(), this.mViewPortHandler().contentTop())
            c.stroke()
            c.closePath()
        } else {
            Utils.resetContext2DStyle(c, this.mAxisLinePaint)
            c.beginPath()
            c.moveTo(this.mViewPortHandler().contentLeft(), this.mViewPortHandler().contentBottom())
            c.lineTo(this.mViewPortHandler().contentRight(), this.mViewPortHandler().contentBottom())
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
    protected func drawYLabels(c: CanvasRenderingContext2D, fixedPosition: Float64, positions: Array<Float64>,
        offset: Float64): Unit {
        this.mAxisLabelPaint.setFontFamily(this.mYAxis.getTypeface())
        this.mAxisLabelPaint.setTextSize(this.mYAxis.getTextSize())
        this.mAxisLabelPaint.setColor(this.mYAxis.getTextColor())

        let fromIndex = if (this.mYAxis.isDrawBottomYLabelEntryEnabled()) {
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
        for (i in fromIndex..Int64(to)) {
            let text: String = this.mYAxis.getFormattedLabel(i)

            Utils.resetContext2DStyle(c, this.mAxisLabelPaint)
            c.beginPath()
            c.fillText(text, positions[i * 2], fixedPosition - offset + xOffset)
            c.closePath()
        }
    }

    protected func getTransformedPositions(): Array<Float64> {
        if (this.mGetTransformedPositionsBuffer.size != Int64(this.mYAxis.mEntryCount * 2.0)) {
            this.mGetTransformedPositionsBuffer = Array<Float64>(Int64(this.mYAxis.mEntryCount * 2.0), item: 0.0)
        }
        let positions: Array<Float64> = this.mGetTransformedPositionsBuffer

        var i: Int64 = 0
        while (i < positions.size) {
            positions[i] = this.mYAxis.mEntries[i / 2]
            i += 2
        }
        if (let Some(mTrans) <- this.mTrans) {
            mTrans.pointValuesToPixel(positions)
        }

        return positions
    }

    public func getGridClippingRect(): MyRect {
        if (this.mViewPortHandler.isNone()) {
            this.mGridClippingRect.set(0.0, 0.0, 0.0, 0.0)
        } else {
            this.mGridClippingRect.set(this.mViewPortHandler().getContentRect().left,
                this.mViewPortHandler().getContentRect().top, this.mViewPortHandler().getContentRect().right,
                this.mViewPortHandler().getContentRect().bottom)
        }
        if (let Some(mAxis) <- this.mAxis) {
            this.mGridClippingRect.inset(-mAxis.getGridLineWidth(), 0.0, -mAxis.getGridLineWidth(), 0.0)
        }

        return this.mGridClippingRect
    }

    protected func linePath(c: CanvasRenderingContext2D, i: Int64, positions: Array<Float64>): Unit {
        c.beginPath()
        c.moveTo(
            if (let Some(handle) <- this.mViewPortHandler) {
                handle.offsetLeft()
            } else {
                0.0
            },
            positions[i + 1]
        )
        c.lineTo(
            if (let Some(handle) <- this.mViewPortHandler) {
                handle.contentRight()
            } else {
                0.0
            },
            positions[i + 1]
        )
        c.stroke()
        c.closePath()
    }

    protected var mDrawZeroLinePathBuffer: Path2D = Path2D()

    protected func drawZeroLine(c: CanvasRenderingContext2D): Unit {
        if (this.mViewPortHandler.isNone() || this.mTrans.isNone()) {
            return
        }
        c.save()
        this.mZeroLineClippingRect.set(this.mViewPortHandler().getContentRect().left,
            this.mViewPortHandler().getContentRect().top, this.mViewPortHandler().getContentRect().right,
            this.mViewPortHandler().getContentRect().bottom)

        this.mZeroLineClippingRect.inset(-this.mYAxis.getZeroLineWidth(), 0.0, -this.mYAxis.getZeroLineWidth(), 0.0)

        c.rect(this.mLimitLineClippingRect.left, this.mLimitLineClippingRect.top,
            this.mLimitLineClippingRect.right - this.mLimitLineClippingRect.left,
            this.mLimitLineClippingRect.bottom - this.mLimitLineClippingRect.top)
        c.clip()

        let pos: MPPointD = this.mTrans().getPixelForValues(0.0, 0.0)

        this.mZeroLinePaint.setColor(this.mYAxis.getZeroLineColor())
        this.mZeroLinePaint.setStrokeWidth(this.mYAxis.getZeroLineWidth())

        var zeroLinePath: Path2D = this.mDrawZeroLinePathBuffer

        zeroLinePath = Path2D()

        zeroLinePath.moveTo(pos.x - 1.0, this.mViewPortHandler().contentTop())
        zeroLinePath.lineTo(pos.x - 1.0, this.mViewPortHandler().contentBottom())

        Utils.resetContext2DStyle(c, this.mZeroLinePaint)
        c.beginPath()
        c.stroke(zeroLinePath)
        c.closePath()

        c.restore()
    }

    protected var mRenderLimitLinesPathBuffer: Path2D = Path2D()
    protected var mRenderLimitLinesBuffer: Array<Float64> = Array<Float64>(4, item: 0.0)

    /**
     * Draws the LimitLines associated with this axis to the screen.
     * This is the standard XAxis renderer using the YAxis limit lines.
     *
     * @param c
     */
    public func renderLimitLines(c: CanvasRenderingContext2D) {
        if (this.mViewPortHandler.isNone()) {
            return
        }

        let limitLines: ArrayList<LimitLine> = this.mYAxis.getLimitLines()

        if (limitLines.size <= 0) {
            return
        }

        let pts: Array<Float64> = this.mRenderLimitLinesBuffer
        pts[0] = 0.0
        pts[1] = 0.0
        pts[2] = 0.0
        pts[3] = 0.0
        var limitLinePath: Path2D = this.mRenderLimitLinesPathBuffer
        limitLinePath = Path2D()

        for (i in 0..limitLines.size) {
            let l: LimitLine = limitLines[i]

            if (!l.isEnabled()) {
                continue
            }

            c.save()
            this.mLimitLineClippingRect.set(this.mViewPortHandler().getContentRect().left,
                this.mViewPortHandler().getContentRect().top, this.mViewPortHandler().getContentRect().right,
                this.mViewPortHandler().getContentRect().bottom)
            this.mLimitLineClippingRect.inset(-l.getLineWidth(), 0.0, -l.getLineWidth(), 0.0)

            pts[0] = l.getLimit()
            pts[2] = l.getLimit()

            if (let Some(mTrans) <- this.mTrans) {
                mTrans.pointValuesToPixel(pts)
            }

            pts[1] = this.mViewPortHandler().contentTop()
            pts[3] = this.mViewPortHandler().contentBottom()

            limitLinePath.moveTo(pts[0], pts[1])
            limitLinePath.lineTo(pts[2], pts[3])

            this.mLimitLinePaint.setStyle(Style.STROKE)
            this.mLimitLinePaint.setColor(Color(UInt32(l.getLineColor())))
            this.mLimitLinePaint.setDashPathEffect(l.getDashPathEffect())
            this.mLimitLinePaint.setStrokeWidth(l.getLineWidth())

            let label: String = l.getLabel()

            // if drawing the limit-value label is enabled
            if (label != "") {
                this.mLimitLinePaint.setStyle(l.getTextStyle())
                this.mLimitLinePaint.setDashPathEffect(Option<DashPathEffect>.None)
                this.mLimitLinePaint.setColor(l.getTextColor())
                this.mLimitLinePaint.setFontFamily(l.getTypeface())
                this.mLimitLinePaint.setStrokeWidth(0.5)
                this.mLimitLinePaint.setTextSize(l.getTextSize())

                let xOffset: Float64 = l.getLineWidth() + l.getXOffset()
                let yOffset: Float64 = Utils.handleDataValues(2.0) + l.getYOffset()

                let position: LimitLabelPosition = l.getLabelPosition()

                c.beginPath()
                if (position == LimitLabelPosition.RIGHT_TOP) {
                    let labelLineHeight: Float64 = Utils.calcTextHeight(c, this.mLimitLinePaint, label)
                    this.mLimitLinePaint.setTextAlign(TextAlignStyle.Left)
                    Utils.resetContext2DStyle(c, this.mLimitLinePaint)
                    c.strokeText(label, pts[0] + xOffset, this.mViewPortHandler().contentTop() + yOffset +
                        labelLineHeight)
                } else if (position == LimitLabelPosition.RIGHT_BOTTOM) {
                    this.mLimitLinePaint.setTextAlign(TextAlignStyle.Left)
                    Utils.resetContext2DStyle(c, this.mLimitLinePaint)
                    c.strokeText(label, pts[0] + xOffset, this.mViewPortHandler().contentBottom() - yOffset)
                } else if (position == LimitLabelPosition.LEFT_TOP) {
                    this.mLimitLinePaint.setTextAlign(TextAlignStyle.Right)
                    let labelLineHeight: Float64 = Utils.calcTextHeight(c, this.mLimitLinePaint, label)
                    c.strokeText(label, pts[0] - xOffset, this.mViewPortHandler().contentTop() + yOffset +
                        labelLineHeight)
                } else {
                    this.mLimitLinePaint.setTextAlign(TextAlignStyle.Right)
                    Utils.resetContext2DStyle(c, this.mLimitLinePaint)
                    c.strokeText(label, pts[0] - xOffset, this.mViewPortHandler().contentBottom() - yOffset)
                }
                c.closePath()
            }
            c.restore()
        }
    }
}
