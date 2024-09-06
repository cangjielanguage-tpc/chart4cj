/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package chart.radar

public class RadarChartRenderer <: LineRadarRenderer {
    public var mChart: RadarChartModel
    /**
     * paint for drawing the web
     */
    public var mWebPaint: ChartPaint
    protected var mHighlightCirclePaint: ChartPaint

    public init(chart: RadarChartModel, animator: ChartAnimator, viewPortHandler: ViewPortHandler) {
        super(animator, viewPortHandler)
        this.mChart = chart

        this.mHighlightPaint = ChartPaint()
        this.mHighlightPaint.setStyle(Style.STROKE)
        this.mHighlightPaint.setStrokeWidth(2.0)
        this.mHighlightPaint.setColor(Color(UInt32(ChartColor.rgb(255, 187, 115))))

        this.mWebPaint = ChartPaint()
        this.mWebPaint.setStyle(Style.STROKE)

        this.mHighlightCirclePaint = ChartPaint()
    }

    public func getWebPaint(): ChartPaint {
        return this.mWebPaint
    }

    public func initBuffers(): Unit {
    }

    public func drawData(c: CanvasRenderingContext2D) {
        if (this.mChart.getRadarData().isNone()) {
            return
        }
        let radarData: ?RadarData = this.mChart.getRadarData()
        if (let Some(radarData) <- radarData) {
            let countSet: ?IRadarDataSet = radarData.getMaxEntryCountSet()
            if (countSet.isNone()) {
                return
            }
            let mostEntries = countSet().getEntryCount()

            for (i in 0..radarData.getDataSets().size) {
                let set = radarData.getDataSets()[i]
                if (set.isVisible()) {
                    this.drawDataSet(c, set, Float64(mostEntries))
                }
            }
        } else {
            return
        }
    }

    protected var mDrawDataSetSurfacePathBuffer: Path2D = Path2D()

    /**
     * Draws the RadarDataSet
     *
     * @param c
     * @param dataSet
     * @param mostEntries the entry count of the dataset with the most entries
     */
    protected func drawDataSet(c: CanvasRenderingContext2D, dataSet: IRadarDataSet, mostEntries: Float64): Unit {
        if (this.mAnimator.isNone()) {
            return
        }
        let phaseX: Float64 = this.mAnimator().getPhaseX()
        let phaseY: Float64 = this.mAnimator().getPhaseY()

        let sliceangle: Float64 = this.mChart.getSliceAngle()

        // calculate the factor that is needed for transforming the value to
        // pixels
        let factor: Float64 = this.mChart.getFactor() * 0.85

        let center: ?MPPointF = this.mChart.getCenterOffsets()
        var pOut: MPPointF = MPPointF.getInstance(0.0, 0.0)
        var surface: Path2D = this.mDrawDataSetSurfacePathBuffer
        surface = Path2D()

        var hasMovedToPoint: Bool = false

        for (j in 0..dataSet.getEntryCount()) {
            this.mRenderPaint.setColor(Color(dataSet.getColor(j)))

            let e: RadarEntry = dataSet.getEntryForIndex(j)()

            if (let Some(center) <- center) {
                pOut = Utils.getPosition(center, (e.getY() - this.mChart.getYChartMin()) * factor * phaseY,
                    sliceangle * Float64(j) * phaseX + this.mChart.getRotationAngle(), pOut)
            }

            if (pOut.x.isNaN()) {
                continue
            }

            if (!hasMovedToPoint) {
                surface.moveTo(pOut.x, pOut.y)
                hasMovedToPoint = true
            } else {
                surface.lineTo(pOut.x, pOut.y)
            }
        }

        if (dataSet.getEntryCount() > Int64(mostEntries) && center.isSome()) {
            // if this is not the largest set, draw a line to the center before closing
            surface.lineTo(center().x, center().y)
        }
        surface.closePath()

        if (dataSet.isDrawFilledEnabled()) {
            this.drawFilledPathWithAlpha(c, surface, dataSet.getFillColor(), dataSet.getFillAlpha())
        }

        this.mRenderPaint.setStrokeWidth(dataSet.getLineWidth())
        this.mRenderPaint.setStyle(Style.STROKE)

        // draw the line (only if filled is disabled or alpha is below 255)
        if (!dataSet.isDrawFilledEnabled() || dataSet.getFillAlpha() < 255.0) {
            Utils.resetContext2DStyle(c, this.mRenderPaint)
            c.beginPath()
            c.stroke(surface)
            c.closePath()
        }

        if (let Some(center) <- center) {
            MPPointF.recycleInstance(center)
        }
        MPPointF.recycleInstance(pOut)
    }

    public func drawValues(c: CanvasRenderingContext2D, isHorizontalFlip!: Bool) {
        if (this.mChart.getRadarData().isNone() || this.mAnimator.isNone()) {
            return
        }
        let phaseX = this.mAnimator().getPhaseX()
        let phaseY = this.mAnimator().getPhaseY()

        let sliceangle = this.mChart.getSliceAngle()

        // calculate the factor that is needed for transforming the value to
        // pixels
        let factor = this.mChart.getFactor() * 0.85

        let center = this.mChart.getCenterOffsets()
        var pOut = MPPointF.getInstance(0.0, 0.0)
        var pIcon = MPPointF.getInstance(0.0, 0.0)

        let yoffset = Utils.handleDataValues(5.0)

        for (i in 0..(this.mChart.getRadarData())().getDataSetCount()) {
            let dataSet: ?IRadarDataSet =( this.mChart.getRadarData())().getDataSetByIndex(i)

            if (dataSet.isNone() || !this.shouldDrawValues(dataSet())) {
                continue
            }

            // apply the text-styling defined by the DataSet
            this.applyValueTextStyle(dataSet())

            var iconsOffset = MPPointF.getInstance(dataSet().getIconsOffset())
            iconsOffset.x = Utils.handleDataValues(iconsOffset.x)
            iconsOffset.y = Utils.handleDataValues(iconsOffset.y)

            for (j in 0..dataSet().getEntryCount()) {
                let entry: RadarEntry = dataSet().getEntryForIndex(j)()

                if (let Some(center) <- center) {
                    pOut = Utils.getPosition(
                        center,
                        (entry.getY() - this.mChart.getYChartMin()) * factor * phaseY,
                        sliceangle * Float64(j) * phaseX + this.mChart.getRotationAngle(),
                        pOut
                    )
                }

                let formatter: ?IValueFormatter = dataSet().getValueFormatter()
                if (dataSet().isDrawValuesEnabled() && formatter.isSome()) {
                    this.drawValue(
                        c,
                        formatter(),
                        entry.getY(),
                        entry,
                        i,
                        pOut.x,
                        pOut.y - yoffset,
                        Color(dataSet().getValueTextColor(j))
                    )
                }

                if (entry.getIcon().isSome() && dataSet().isDrawIconsEnabled()) {
                    let icon: ?ChartPixelMap = entry.getIcon()

                    if (let Some(center) <- center) {
                        pIcon = Utils.getPosition(
                            center,
                            entry.getY() * factor * phaseY + iconsOffset.y,
                            sliceangle * Float64(j) * phaseX + this.mChart.getRotationAngle(),
                            pIcon
                        )
                    }

                    //noinspection SuspiciousNameCombination
                    pIcon.y += iconsOffset.x

                    if (let Some(icon) <- icon) {
                        Utils.drawImage(
                            c,
                            icon,
                            floor(pIcon.x),
                            floor(pIcon.y)
                        )
                    }
                }
            }

            MPPointF.recycleInstance(iconsOffset)
        }

        if (let Some(center) <- center) {
            MPPointF.recycleInstance(center)
        }
        MPPointF.recycleInstance(pOut)
        MPPointF.recycleInstance(pIcon)
    }

    public func drawExtras(c: CanvasRenderingContext2D) {
        this.drawWeb(c)
    }

    protected func drawWeb(c: CanvasRenderingContext2D) {
        if ((this.mChart.getRadarData()).isNone()) {
            return
        }
        let sliceangle: Float64 = this.mChart.getSliceAngle()

        // calculate the factor that is needed for transforming the value to
        // pixels
        let factor: Float64 = this.mChart.getFactor() * 0.85
        let rotationangle = this.mChart.getRotationAngle()

        let center: ?MPPointF = this.mChart.getCenterOffsets()

        // draw the web lines that come from the center
        this.mWebPaint.setStrokeWidth(this.mChart.getWebLineWidth())
        this.mWebPaint.setColor(Color(this.mChart.getWebColor()))
        this.mWebPaint.setGlobalAlpha(this.mChart.getWebAlpha() / 255.0)

        let xIncrements: Int64 = 1 + this.mChart.getSkipWebLineCount()
        let maxCountEntrySet: ?IRadarDataSet = (this.mChart.getRadarData())().getMaxEntryCountSet()

        c.save()
        if (let Some(maxCountEntrySet) <- maxCountEntrySet) {
            let maxEntryCount: Int64 = maxCountEntrySet.getEntryCount()

            var p: MPPointF = MPPointF.getInstance(0.0, 0.0)
            for (i in 0..maxEntryCount : xIncrements) {
                if (let Some(center) <- center) {
                    p = Utils.getPosition(
                        center,
                        this.mChart.getYRange() * factor,
                        sliceangle * Float64(i) + rotationangle,
                        p
                    )
                    Utils.resetContext2DStyle(c, this.mWebPaint)
                    c.beginPath()
                    c.moveTo(center.x, center.y)
                    c.lineTo(p.x, p.y)
                    c.stroke()
                    c.closePath()
                }
            }
            MPPointF.recycleInstance(p)
        }

        // draw the inner-web
        this.mWebPaint.setStrokeWidth(this.mChart.getWebLineWidthInner())
        this.mWebPaint.setColor(Color(this.mChart.getWebColorInner()))
        this.mWebPaint.setGlobalAlpha(this.mChart.getWebAlpha() / 255.0)
        let yAxis = this.mChart.getYAxis()

        let labelCount: Int64 = Int64(yAxis.mEntryCount)

        var p1out: MPPointF = MPPointF.getInstance(0.0, 0.0)
        var p2out: MPPointF = MPPointF.getInstance(0.0, 0.0)
        for (j in 0..labelCount) {
            for (i in 0..(this.mChart.getRadarData())().getEntryCount()) {
                let r: Float64 = (yAxis.mEntries[j] - this.mChart.getYChartMin()) * factor
                if (let Some(center) <- center) {
                    p1out = Utils.getPosition(center, r, sliceangle * Float64(i) + rotationangle, p1out)
                    p2out = Utils.getPosition(center, r, sliceangle * Float64(i + 1) + rotationangle, p2out)
                }
                Utils.resetContext2DStyle(c, this.mWebPaint)
                c.beginPath()
                c.moveTo(p1out.x, p1out.y)
                c.lineTo(p2out.x, p2out.y)
                c.stroke()
                c.closePath()
            }
        }
        MPPointF.recycleInstance(p1out)
        MPPointF.recycleInstance(p2out)

        c.restore()
    }

    public func drawHighlighted(c: CanvasRenderingContext2D, indices: Array<Highlight>) {
        if (this.mAnimator.isNone()) {
            return
        }
        let sliceangle: Float64 = this.mChart.getSliceAngle()

        // calculate the factor that is needed for transforming the value to
        // pixels
        let factor: Float64 = this.mChart.getFactor() * 0.85

        let center: ?MPPointF = this.mChart.getCenterOffsets()
        var pOut: MPPointF = MPPointF.getInstance(0.0, 0.0)

        let radarData: ?RadarData = this.mChart.getRadarData()
        if (let Some(radarData) <- radarData) {
            for (high in indices) {
                let set: ?IRadarDataSet = radarData.getDataSetByIndex(high.getDataSetIndex())

                if (set.isNone() || !set().isHighlightEnabled()) {
                    continue
                }

                let e: ?RadarEntry = set().getEntryForIndex(Int64(floor(high.getX())))
                if (e.isNone() || !this.isInBoundsX(e(), set())) {
                    continue
                }

                let y: Float64 = (e().getY() - this.mChart.getYChartMin())
                if (let Some(center) <- center) {
                    pOut = Utils.getPosition(
                        center,
                        y * factor * this.mAnimator().getPhaseY(),
                        sliceangle * high.getX() * this.mAnimator().getPhaseX() + this.mChart.getRotationAngle(),
                        pOut
                    )
                }

                high.setDraw(pOut.x, pOut.y)
                //TODO this.drawHighlightLines(c, pOut.x, pOut.y, set())
                if (set().isDrawHighlightCircleEnabled()) {
                    if (!pOut.x.isNaN() && !pOut.y.isNaN()) {
                        var strokeColor: UInt32 = set().getHighlightCircleStrokeColor()
                        if (strokeColor == ColorTemplate.COLOR_NONE) {
                            strokeColor = set().getColor(0)
                        }

                        if (set().getHighlightCircleStrokeAlpha() < 255.0) {
                            strokeColor = UInt32(ColorTemplate.colorWithAlpha(
                                    Int64(strokeColor),
                                    set().getHighlightCircleStrokeAlpha()
                                ))
                        }

                        this.drawHighlightCircle(
                            c,
                            pOut,
                            set().getHighlightCircleInnerRadius(),
                            set().getHighlightCircleOuterRadius(),
                            (set().getHighlightCircleFillColor()),
                            strokeColor,
                            set().getHighlightCircleStrokeWidth()
                        )
                    }
                }
            }
        }
        if (let Some(center) <- center) {
            MPPointF.recycleInstance(center)
        }
        MPPointF.recycleInstance(pOut)
    }

    protected var mDrawHighlightCirclePathBuffer: Path2D = Path2D()

    public func drawHighlightCircle(
        c: CanvasRenderingContext2D,
        point: MPPointF,
        innerRadius: Float64,
        outerRadius: Float64,
        fillColor: UInt32,
        strokeColor: UInt32,
        strokeWidth: Float64
    ): Unit {
        c.save()

        let outerRadiusInner = Utils.handleDataValues(outerRadius)
        let innerRadiusInner = Utils.handleDataValues(innerRadius)

        if (fillColor != ColorTemplate.COLOR_NONE) {
            var p: Path2D = this.mDrawHighlightCirclePathBuffer
            p = Path2D()
            c.beginPath()
            p.arc(point.x, point.y, outerRadius, 0.0, 2.0 * Float64.PI, anticlockwise: false)
            if (innerRadius > 0.0) {
                p.arc(point.x, point.y, innerRadius, 0.0, 2.0 * Float64.PI, anticlockwise: true)
            }
            this.mHighlightCirclePaint.setColor(Color(fillColor))
            this.mHighlightCirclePaint.setStyle(Style.FILL)
            Utils.resetContext2DStyle(c, this.mHighlightCirclePaint)
            c.closePath()
            //TODO c.fill(p)
            c.stroke(p)
        }

        if (strokeColor != ColorTemplate.COLOR_NONE) {
            this.mHighlightCirclePaint.setColor(Color(strokeColor))
            this.mHighlightCirclePaint.setStyle(Style.STROKE)
            this.mHighlightCirclePaint.setStrokeWidth(Utils.handleDataValues(strokeWidth))
            Utils.resetContext2DStyle(c, this.mHighlightCirclePaint)
            c.beginPath()
            c.arc(point.x, point.y, outerRadius, 0.0, 2.0 * Float64.PI)
            c.stroke()
            c.closePath()
        }

        c.restore()
    }
}
