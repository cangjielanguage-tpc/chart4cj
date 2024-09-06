/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package chart.bar

public class XAxisRendererHorizontalBarChart <: XAxisRenderer {
    protected var mChart: BarChartModel

    public init(viewPortHandler: ViewPortHandler, xAxis: XAxis, trans: Transformer, chart: BarChartModel) {
        super(viewPortHandler, xAxis, trans)
        this.mChart = chart
    }

    public func computeAxis(min: Float64, max: Float64, inverted: Bool): Unit {
        var mins: Float64 = min
        var maxs: Float64 = max
        if (this.mTrans.isNone() || this.mViewPortHandler.isNone()) {
            return;
        }
        if (let Some(handle) <- this.mViewPortHandler) {
            // calculate the starting and entry point of the y-labels (depending on
            // zoom / contentrect bounds)
            if (handle.contentWidth() > 10.0 && !handle.isFullyZoomedOutY()) {
                let p1: MPPointD = this.mTrans().getValuesByTouchPoint(handle.contentLeft(), handle.contentBottom(),
                    Option<MPPointD>.None)
                let p2: MPPointD = this.mTrans().getValuesByTouchPoint(handle.contentLeft(), handle.contentTop(),
                    Option<MPPointD>.None)

                if (inverted) {
                    mins = p2.y
                    maxs = p1.y
                } else {
                    mins = p1.y
                    maxs = p2.y
                }

                MPPointD.recycleInstance(p1)
                MPPointD.recycleInstance(p2)
            }

            this.computeAxisValues(min, max)
        } else {
            return
        }
    }

    protected func computeSize(): Unit {
        this.mAxisLabelPaint.setFontFamily(this.mXAxis.getTypeface())
        this.mAxisLabelPaint.setTextSize(this.mXAxis.getTextSize())

        let longest: String = this.mXAxis.getLongestLabel()

        let labelSize: FSize = Utils.calcTextSize(this.mAxisLabelPaint, longest)

        let labelWidth: Float64 = round(labelSize.width + this.mXAxis.getXOffset() * 3.5)
        let labelHeight: Float64 = labelSize.height

        let labelRotatedSize: FSize = Utils.getSizeOfRotatedRectangleByDegrees(
            labelSize.width,
            labelHeight,
            Float64(this.mXAxis.getLabelRotationAngle())
        )

        this.mXAxis.mLabelWidth = Int64(round(labelWidth))
        this.mXAxis.mLabelHeight = Int64(round(labelHeight))
        this.mXAxis.mLabelRotatedWidth = Int64(round(labelRotatedSize.width + this.mXAxis.getXOffset() * 3.5))
        this.mXAxis.mLabelRotatedHeight = Int64(round(labelRotatedSize.height))

        FSize.recycleInstance(labelRotatedSize)
    }

    public func renderAxisLabels(c: CanvasRenderingContext2D) {
        if (!this.mXAxis.isEnabled() || !this.mXAxis.isDrawLabelsEnabled() || this.mViewPortHandler.isNone()) {
            return
        }
        let xoffset: Float64 = this.mXAxis.getXOffset()

        this.mAxisLabelPaint.setFontFamily(this.mXAxis.getTypeface())
        this.mAxisLabelPaint.setTextSize(this.mXAxis.getTextSize())
        this.mAxisLabelPaint.setColor(this.mXAxis.getTextColor())

        let pointF: MPPointF = MPPointF.getInstance(0.0, 0.0)
        if (this.mXAxis.getPosition() == XAxisPosition.TOP) {
            pointF.x = 0.0
            pointF.y = 0.5
            this.drawLabels(c, this.mViewPortHandler().contentRight() + xoffset, pointF)
        } else if (this.mXAxis.getPosition() == XAxisPosition.TOP_INSIDE) {
            pointF.x = 1.0
            pointF.y = 0.5
            this.drawLabels(c, this.mViewPortHandler().contentRight() - xoffset, pointF)
        } else if (this.mXAxis.getPosition() == XAxisPosition.BOTTOM) {
            pointF.x = 1.0
            pointF.y = 0.5
            this.drawLabels(c, this.mViewPortHandler().contentLeft() - xoffset, pointF)
        } else if (this.mXAxis.getPosition() == XAxisPosition.BOTTOM_INSIDE) {
            pointF.x = 1.0
            pointF.y = 0.5
            this.drawLabels(c, this.mViewPortHandler().contentLeft() + xoffset, pointF)
        } else { // BOTH SIDED
            pointF.x = 0.0
            pointF.y = 0.5
            this.drawLabels(c, this.mViewPortHandler().contentRight() + xoffset, pointF)
            pointF.x = 1.0
            pointF.y = 0.5
            this.drawLabels(c, this.mViewPortHandler().contentLeft() - xoffset, pointF)
        }
        MPPointF.recycleInstance(pointF)
    }

    protected func drawLabels(c: CanvasRenderingContext2D, pos: Float64, anchor: MPPointF): Unit {
        if (this.mViewPortHandler.isNone()) {
            return
        }
        let labelRotationAngleDegrees: Int64 = this.mXAxis.getLabelRotationAngle()
        let centeringEnabled: Bool = this.mXAxis.isCenterAxisLabelsEnabled()

        let positions: Array<Float64> = Array(Int64(this.mXAxis.mEntryCount * 2.0), item: 0.0)

        for (i in 0..positions.size : 2) {

            // only fill x values
            if (centeringEnabled) {
                positions[i + 1] = this.mXAxis.mCenteredEntries[i / 2]
            } else {
                positions[i + 1] = this.mXAxis.mEntries[i / 2]
            }
        }
        if (let Some(mTrans) <- this.mTrans) {
            mTrans.pointValuesToPixel(positions)
        }

        var j: Int64 = 0
        while (j < positions.size) {
            let y: Float64 = positions[j + 1]

            if (this.mViewPortHandler().isInBoundsY(y)) {
                let label: String = this.mXAxis.getValueFormatter()().getFormattedValue(
                    this.mXAxis.mEntries[j / 2],
                    this.mXAxis
                )
                this.drawLabel(c, label, pos, y, anchor, Float64(labelRotationAngleDegrees))
            }
            j += 2
        }
    }

    public func getGridClippingRect(): MyRect {
        if (this.mAxis.isNone() || this.mViewPortHandler.isNone()) {
            return MyRect()
        }
        this.mGridClippingRect.set(this.mViewPortHandler().getContentRect().left,
            this.mViewPortHandler().getContentRect().top, this.mViewPortHandler().getContentRect().right,
            this.mViewPortHandler().getContentRect().bottom)
        if (let Some(mAxis) <- this.mAxis) {
            this.mGridClippingRect.inset(0.0, -mAxis.getGridLineWidth(), 0.0, -mAxis.getGridLineWidth())
        }

        return this.mGridClippingRect
    }

    protected func drawGridLine(c: CanvasRenderingContext2D, x: Float64, y: Float64): Unit {
        // draw a path because lines don't support dashing on lower ohos versions
        Utils.resetContext2DStyle(c, this.mGridPaint)
        c.beginPath()
        c.moveTo(
            if (let Some(handle) <- this.mViewPortHandler) {
                handle.contentRight()
            } else {
                0.0
            },
            y
        )
        c.lineTo(
            if (let Some(handle) <- this.mViewPortHandler) {
                handle.contentLeft()
            } else {
                0.0
            },
            y
        )
        c.stroke()
        c.closePath()
    }

    public func renderAxisLine(c: CanvasRenderingContext2D) {
        if (!this.mXAxis.isDrawAxisLineEnabled() || !this.mXAxis.isEnabled()) {
            return
        }

        this.mAxisLinePaint.setColor(this.mXAxis.getAxisLineColor())
        this.mAxisLinePaint.setStrokeWidth(this.mXAxis.getAxisLineWidth())
    }

    protected var mRenderLimitLinesPathBuffer: Path2D = Path2D()

    /**
     * Draws the LimitLines associated with this axis to the screen.
     * This is the standard YAxis renderer using the XAxis limit lines.
     *
     * @param c
     */
    public func renderLimitLines(c: CanvasRenderingContext2D) {
        if (this.mViewPortHandler.isNone()) {
            return
        }

        let limitLines: ArrayList<LimitLine> = this.mXAxis.getLimitLines()

        if (limitLines.size <= 0) {
            return
        }

        let pts: Array<Float64> = this.mRenderLimitLinesBuffer
        pts[0] = 0.0
        pts[1] = 0.0

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
            this.mLimitLineClippingRect.inset(0.0, -l.getLineWidth(), 0.0, -l.getLineWidth())

            this.mLimitLinePaint.setStyle(Style.STROKE)
            this.mLimitLinePaint.setColor(Color(UInt32(l.getLineColor())))
            this.mLimitLinePaint.setStrokeWidth(l.getLineWidth())
            this.mLimitLinePaint.setDashPathEffect(l.getDashPathEffect())

            pts[1] = l.getLimit()

            if (let Some(mTrans) <- this.mTrans) {
                mTrans.pointValuesToPixel(pts)
            }

            limitLinePath.moveTo(this.mViewPortHandler().contentLeft(), pts[1])
            limitLinePath.lineTo(this.mViewPortHandler().contentRight(), pts[1])

            // c.drawPath(limitLinePath, this.mLimitLinePaint)
            Utils.resetContext2DStyle(c, this.mLimitLinePaint)
            c.beginPath()
            c.stroke(limitLinePath)
            c.closePath()
            limitLinePath = Path2D()

            // c.drawLines(pts, mLimitLinePaint)

            let label: String = l.getLabel()

            // if drawing the limit-value label is enabled
            if (label.size > 0) {
                this.mLimitLinePaint.setStyle(l.getTextStyle())
                this.mLimitLinePaint.setDashPathEffect(Option<DashPathEffect>.None)
                this.mLimitLinePaint.setColor(l.getTextColor())
                this.mLimitLinePaint.setStrokeWidth(0.5)
                this.mLimitLinePaint.setTextSize(l.getTextSize())

                let labelLineHeight: Float64 = Utils.calcTextHeight(c, this.mLimitLinePaint, label)
                let xOffset: Float64 = Utils.handleDataValues(4.0) + l.getXOffset()
                let yOffset: Float64 = l.getLineWidth() + labelLineHeight + l.getYOffset()

                let position: LimitLabelPosition = l.getLabelPosition()

                if (position == LimitLabelPosition.RIGHT_TOP) {
                    this.mLimitLinePaint.setTextAlign(TextAlignStyle.Right)
                    Utils.resetContext2DStyle(c, this.mLimitLinePaint)
                    c.beginPath()
                    c.strokeText(label, this.mViewPortHandler().contentRight() - xOffset,
                        pts[1] - yOffset + labelLineHeight)
                    c.closePath()
                } else if (position == LimitLabelPosition.RIGHT_BOTTOM) {
                    this.mLimitLinePaint.setTextAlign(TextAlignStyle.Right)
                    Utils.resetContext2DStyle(c, this.mLimitLinePaint)
                    c.beginPath()
                    c.strokeText(label, this.mViewPortHandler().contentRight() - xOffset, pts[1] + yOffset)
                    c.closePath()
                } else if (position == LimitLabelPosition.LEFT_TOP) {
                    this.mLimitLinePaint.setTextAlign(TextAlignStyle.Left)
                    /* c.drawText(label,
                    mViewPortHandler.contentLeft() + xOffset,
                    pts[1] - yOffset + labelLineHeight, mLimitLinePaint)*/
                    Utils.resetContext2DStyle(c, this.mLimitLinePaint)
                    c.beginPath()
                    c.strokeText(label, this.mViewPortHandler().contentLeft() + xOffset,
                        pts[1] - yOffset + labelLineHeight)
                    c.closePath()
                } else {
                    this.mLimitLinePaint.setTextAlign(TextAlignStyle.Left)
                    /*	c.drawText(label,
                              mViewPortHandler.offsetLeft() + xOffset,
                    pts[1] + yOffset, mLimitLinePaint)*/
                    Utils.resetContext2DStyle(c, this.mLimitLinePaint)
                    c.beginPath()
                    c.strokeText(label, this.mViewPortHandler().offsetLeft() + xOffset, pts[1] + yOffset)
                    c.closePath()
                }
            }

            c.restore()
        }
    }
}
