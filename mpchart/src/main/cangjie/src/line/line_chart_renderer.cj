/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package mpchart.line

public class LineChartRenderer <: LineRadarRenderer {
    public var mChart: LineDataProvider
    public var mDrawBitmap: ?ChartPixelMap = None
    public var mBitmapCanvas: ?CanvasRenderingContext2D = None
    public var mCirclePaintInner: Paint
    protected var cubicPath: Path2D = Path2D()
    protected var cubicFillPath: Path2D = Path2D()

    public init(chart: LineDataProvider, animator: ChartAnimator, viewPortHandler: ViewPortHandler) {
        super(animator, viewPortHandler)
        this.mChart = chart

        this.mCirclePaintInner = Paint()
        this.mCirclePaintInner.setStyle(Style.FILL)
        this.mCirclePaintInner.setColor(Color(0xffffff))
    }

    public func initBuffers() {
    }

    public func drawData(c: CanvasRenderingContext2D): Unit {
        let width: Float64 = floor(if (let Some(handle) <- this.mViewPortHandler) {
            handle.getChartWidth()
        } else {
            0.0
        })
        let height: Float64 = floor(if (let Some(handle) <- this.mViewPortHandler) {
            handle.getChartHeight()
        } else {
            0.0
        })

        if (width > 0.0 && height > 0.0) {
            this.mBitmapCanvas = c
        } else {
            return
        }

        let lineData: ?LineData = this.mChart.getLineData()
        if (let Some(data) <- lineData) {
            let dataSets = data.getDataSets()

            for (i in 0..dataSets.size) {
                let set = dataSets[i]
                if (set.isVisible()) {
                    this.drawDataSet(c, set)
                }
            }
        } else {
            return
        }
    }

    public func drawDataSet(c: CanvasRenderingContext2D, dataSet: ILineDataSet) {
        if (dataSet.getEntryCount() < 1) {
            return
        }

        this.mRenderPaint.setStrokeWidth(dataSet.getLineWidth())
        this.mRenderPaint.setDashPathEffect(dataSet.getDashPathEffect())

        match (dataSet.getMode()) {
            case Mode.LINEAR => this.drawLinear(c, dataSet)
            case Mode.STEPPED => this.drawLinear(c, dataSet)

            case Mode.CUBIC_BEZIER => this.drawCubicBezier(c, dataSet)

            case Mode.HORIZONTAL_BEZIER => this.drawHorizontalBezier(c, dataSet)

            case _ => this.drawLinear(c, dataSet)
        }
        this.mRenderPaint.setDashPathEffect(Option<DashPathEffect>.None)
    }

    protected func drawHorizontalBezier(c: CanvasRenderingContext2D, dataSet: ILineDataSet) {
        if (this.mXBounds.isNone()) {
            return
        }
        let phaseY: Float64 = if (let Some(m) <- this.mAnimator) {
            m.getPhaseY()
        } else {
            1.0
        }
        let trans: ?Transformer = this.mChart.getTransformer(dataSet.getAxisDependency())
        this.mXBounds?.set(this.mChart, dataSet)

        var cubicPath: Path2D = Path2D()
        // cubicPath.reset()

        if (this.mXBounds().range >= 1) {
            var prev = dataSet.getEntryForIndex(this.mXBounds().mins)
            var cur = prev

            Utils.resetContext2DStyle(c, this.mRenderPaint)
            // let the spline start
            cubicPath.moveTo(cur.getX(), cur.getY() * phaseY)

            for (j in this.mXBounds().mins + 1..=this.mXBounds().range + this.mXBounds().mins) {
                prev = cur
                cur = dataSet.getEntryForIndex(j)

                let cpx: Float64 = (prev.getX()) + (cur.getX() - prev.getX()) / 2.0

                cubicPath.bezierCurveTo(cpx, prev.getY() * phaseY, cpx, cur.getY() * phaseY, cur.getX(),
                    cur.getY() * phaseY)
            }
        }

        // if filled is enabled, close the path
        if (dataSet.isDrawFilledEnabled() && trans.isSome()) {
            let cubicFillPath = Path2D()
            cubicFillPath.addPath(cubicPath)
            // create a path, this is bad for performance
            this.drawCubicFill(c, dataSet, cubicFillPath, trans(), this.mXBounds())
        }

        this.mRenderPaint.setColor(Color(dataSet.getColor()))
        this.mRenderPaint.setStyle(Style.STROKE)

        // todo 当前UI不支持 Matrix2D
        /* if (let Some(t) <- trans && trans().pathValueToPixel(cubicPath) ) {
            cubicPath = t.pathValueToPixel(cubicPath)
        }*/
        Utils.resetContext2DStyle(c, this.mRenderPaint)
        c.beginPath()
        c.stroke(cubicPath)
        c.closePath()

        this.mRenderPaint.setDashPathEffect(Option<DashPathEffect>.None)
    }

    protected func drawCubicBezier(c: CanvasRenderingContext2D, dataSet: ILineDataSet) {
        if (this.mXBounds.isNone()) {
            return
        }
        let phaseY: Float64 = if (let Some(m) <- this.mAnimator) {
            m.getPhaseY()
        } else {
            1.0
        }
        let trans: ?Transformer = this.mChart.getTransformer(dataSet.getAxisDependency())

        this.mXBounds().set(this.mChart, dataSet)

        let intensity: Float64 = dataSet.getCubicIntensity()

        var cubicPath = Path2D()
        if (this.mXBounds().range >= 1) {
            var prevDx: Float64 = 0.0
            var prevDy: Float64 = 0.0
            var curDx: Float64 = 0.0
            var curDy: Float64 = 0.0

            // Take an extra point from the left, and an extra from the right.
            // That's because we need 4 points for a cubic bezier (cubic=4), otherwise we get lines moving and doing weird stuff on the edges of the chart.
            // So in the starting `prev` and `cur`, go -2, -1
            // And in the `lastIndex`, add +1

            let firstIndex: Int64 = this.mXBounds().mins + 1
            let lastIndex: Int64 = this.mXBounds().mins + this.mXBounds().range

            var prevPrev: EntryOhos
            var prev: EntryOhos = dataSet.getEntryForIndex(max(firstIndex - 2, 0))
            var cur: EntryOhos = dataSet.getEntryForIndex(max(firstIndex - 1, 0))
            var next: EntryOhos = cur
            var nextIndex: Int64 = -1

            Utils.resetContext2DStyle(c, this.mRenderPaint)
            // let the spline start
            cubicPath.moveTo(cur.getX(), cur.getY() * phaseY)

            for (j in this.mXBounds().mins + 1..=this.mXBounds().range + this.mXBounds().mins) {
                prevPrev = prev
                prev = cur
                cur = if (nextIndex == j) {
                    next
                } else {
                    dataSet.getEntryForIndex(j)
                }

                nextIndex = if (j + 1 < dataSet.getEntryCount()) {
                    j + 1
                } else {
                    j
                }
                next = dataSet.getEntryForIndex(nextIndex)

                prevDx = (cur.getX() - prevPrev.getX()) * intensity
                prevDy = (cur.getY() - prevPrev.getY()) * intensity
                curDx = (next.getX() - prev.getX()) * intensity
                curDy = (next.getY() - prev.getY()) * intensity

                cubicPath.bezierCurveTo(
                    prev.getX() + prevDx,
                    (prev.getY() + prevDy) * phaseY,
                    cur.getX() - curDx,
                    (cur.getY() - curDy) * phaseY,
                    cur.getX(),
                    cur.getY() * phaseY
                )
            }
        }

        // if filled is enabled, close the path
        if (dataSet.isDrawFilledEnabled()) {
            let cubicFillPath: Path2D = Path2D()
            // cubicFillPath.reset()
            cubicFillPath.addPath(cubicPath)

            if (let Some(t) <- trans) {
                this.drawCubicFill(c, dataSet, cubicFillPath, t, this.mXBounds())
            }
        }

        this.mRenderPaint.setColor(Color(dataSet.getColor()))
        this.mRenderPaint.setStyle(Style.STROKE)

        // todo 当前UI不支持 Matrix2D
        /* if (let Some(t) <- trans && trans().pathValueToPixel(cubicPath) ) {
            cubicPath = t.pathValueToPixel(cubicPath)
        }*/
        Utils.resetContext2DStyle(c, this.mRenderPaint)
        c.beginPath()
        c.stroke(cubicPath)
        c.closePath()
        this.mRenderPaint.setDashPathEffect(Option<DashPathEffect>.None)
    }

    protected func drawCubicFill(c: CanvasRenderingContext2D, dataSet: ILineDataSet, spline: Path2D, trans: Transformer,
        bounds: XBounds) {
        let fillMin: Float64 = dataSet.getFillFormatter().getFillLinePosition(dataSet, this.mChart)
        var splineTemp = spline

        splineTemp.lineTo(dataSet.getEntryForIndex(bounds.mins + bounds.range).getX(), fillMin)
        splineTemp.lineTo(dataSet.getEntryForIndex(bounds.mins).getX(), fillMin)
        splineTemp.closePath()

        // todo 当前UI不支持 Matrix2D
        //splineTemp = trans.pathValueToPixel(splineTemp)

        let drawable: ?ChartPixelMap = dataSet.getFillDrawable()
        let gradientFillColor: ?ArrayList<ChartColorStop> = dataSet.getGradientFillColor()
        if (let Some(d) <- drawable) {
            this.drawFilledPath(c, splineTemp, d)
        } else if (gradientFillColor.isSome()) {
            let isInverted: Bool = this.mChart.isInverted(dataSet.getAxisDependency())
            var topValue: Float64 = 0.0
            if (isInverted) {
                topValue = dataSet.getYMin()
            } else {
                topValue = dataSet.getYMax()
            }
            let topBottomValueFloat64 = [0.0, topValue, 0.0, fillMin]
            trans.pointValuesToPixel(topBottomValueFloat64)
            this.drawGradientFill(c, splineTemp, gradientFillColor(), topBottomValueFloat64[1], topBottomValueFloat64[3]
            )
        } else {
            this.drawFilledPathWithAlpha(c, splineTemp, dataSet.getFillColor(), dataSet.getFillAlpha())
        }
    }

    private var mLineBuffer: Array<Float64> = Array<Float64>(4, item: 0.0)

    protected func drawLinear(c: CanvasRenderingContext2D, dataSet: ILineDataSet): Unit {
        if (this.mXBounds.isNone()) {
            return
        }
        let entryCount = dataSet.getEntryCount()
        let isDrawSteppedEnabled = dataSet.isDrawSteppedEnabled()
        let pointsPerEntryPair = if (isDrawSteppedEnabled) {
            4
        } else {
            2
        }
        let trans: ?Transformer = this.mChart.getTransformer(dataSet.getAxisDependency())
        let phaseY: Float64 = if (let Some(m) <- this.mAnimator) {
            m.getPhaseY()
        } else {
            1.0
        }
        this.mRenderPaint.setStyle(Style.STROKE)
        var canvas: CanvasRenderingContext2D = c

        // if the data-set is dashed, draw on bitmap-canvas
        if (dataSet.isDashedLineEnabled() && this.mBitmapCanvas.isSome()) {
            canvas = this.mBitmapCanvas()
        } else {
            canvas = c
        }

        this.mXBounds().set(this.mChart, dataSet)

        // if drawing filled is enabled
        if (dataSet.isDrawFilledEnabled() && entryCount > 0 && trans.isSome()) {
            this.drawLinearFill(c, dataSet, trans(), this.mXBounds())
        }

        // more than 1 color
        if (dataSet.getColors().size > 1) {
            let Float64OfFloats = pointsPerEntryPair * 2
            if (this.mLineBuffer.size <= Float64OfFloats) {
                this.mLineBuffer = Array<Float64>(Float64OfFloats * 2, item: 0.0)
            }
            let maxs = this.mXBounds().mins + this.mXBounds().range
            for (j in this.mXBounds().mins..maxs) {
                var e: EntryOhos = dataSet.getEntryForIndex(j)

                this.mLineBuffer[0] = e.getX()
                this.mLineBuffer[1] = e.getY() * phaseY

                if (j < this.mXBounds().maxs) {
                    e = dataSet.getEntryForIndex(j + 1)

                    if (isDrawSteppedEnabled) {
                        this.mLineBuffer[2] = e.getX()
                        this.mLineBuffer[3] = this.mLineBuffer[1]
                        this.mLineBuffer[4] = this.mLineBuffer[2]
                        this.mLineBuffer[5] = this.mLineBuffer[3]
                        this.mLineBuffer[6] = e.getX()
                        this.mLineBuffer[7] = e.getY() * phaseY
                    } else {
                        this.mLineBuffer[2] = e.getX()
                        this.mLineBuffer[3] = e.getY() * phaseY
                    }
                } else {
                    this.mLineBuffer[2] = this.mLineBuffer[0]
                    this.mLineBuffer[3] = this.mLineBuffer[1]
                }

                // Determine the start and end coordinates of the line, and make sure they differ.
                let firstCoordinateX = this.mLineBuffer[0]
                let firstCoordinateY = this.mLineBuffer[1]
                let lastCoordinateX = this.mLineBuffer[Float64OfFloats - 2]
                let lastCoordinateY = this.mLineBuffer[Float64OfFloats - 1]

                if (firstCoordinateX == lastCoordinateX && firstCoordinateY == lastCoordinateY) {
                    continue
                }

                if (let Some(t) <- trans) {
                    t.pointValuesToPixel(this.mLineBuffer)
                }

                if (this.mViewPortHandler.isNone() || !this.mViewPortHandler().isInBoundsRight(firstCoordinateX)) {
                    break
                }

                // make sure the lines don't do shitty things outside
                // bounds
                if (!this.mViewPortHandler.isNone() || !this.mViewPortHandler().isInBoundsLeft(lastCoordinateX) ||
                    !this.mViewPortHandler().isInBoundsTop(max(firstCoordinateY, lastCoordinateY)) ||
                    !this.mViewPortHandler().isInBoundsBottom(min(firstCoordinateY, lastCoordinateY))) {
                    continue
                }

                // get the color that is set for this line-segment
                this.mRenderPaint.setColor(Color(dataSet.getColor(j)))
                // canvas.drawLines(this.mLineBuffer, 0, pointsPerEntryPair * 2, this.mRenderPaint)

                Utils.resetContext2DStyle(canvas, this.mRenderPaint)
                canvas.beginPath()

                canvas.moveTo(this.mLineBuffer[0], this.mLineBuffer[1])
                for (i in 0..pointsPerEntryPair * 2 : 2) {
                    canvas.lineTo(this.mLineBuffer[i], this.mLineBuffer[i + 1])
                }
                canvas.stroke()
                canvas.closePath()
            }
        } else { // only one color per dataset

            if (this.mLineBuffer.size < max((entryCount) * pointsPerEntryPair, pointsPerEntryPair) * 2) {
                this.mLineBuffer = Array<Float64>(
                    max((entryCount) * pointsPerEntryPair, pointsPerEntryPair) * 4,
                    item: 0.0
                )
            }

            var e1: EntryOhos
            var e2: EntryOhos

            e1 = dataSet.getEntryForIndex(this.mXBounds().mins)

            var j = 0
            for (x in this.mXBounds().mins..=this.mXBounds().range + this.mXBounds().mins) {
                e1 = dataSet.getEntryForIndex(if (x == 0) {
                    0
                } else {
                    (x - 1)
                })
                e2 = dataSet.getEntryForIndex(x)

                j += 1
                this.mLineBuffer[j] = e1.getX()
                j += 1
                this.mLineBuffer[j] = e1.getY() * phaseY

                if (isDrawSteppedEnabled) {
                    j += 1
                    this.mLineBuffer[j] = e2.getX()
                    j += 1
                    this.mLineBuffer[j] = e1.getY() * phaseY
                    j += 1
                    this.mLineBuffer[j] = e2.getX()
                    j += 1
                    this.mLineBuffer[j] = e1.getY() * phaseY
                }
                j += 1
                this.mLineBuffer[j] = e2.getX()
                j += 1
                this.mLineBuffer[j] = e2.getY() * phaseY
            }

            if (j > 0) {
                if (let Some(t) <- trans) {
                    t.pointValuesToPixel(this.mLineBuffer)
                }

                var size = max((this.mXBounds().range + 1) * pointsPerEntryPair, pointsPerEntryPair) * 2
                size = Int64(floor(Float64(size)))

                this.mRenderPaint.setColor(Color(dataSet.getColor()))
                Utils.resetContext2DStyle(canvas, this.mRenderPaint)
                canvas.beginPath()

                canvas.moveTo(this.mLineBuffer[0], this.mLineBuffer[1])
                for (i in 0..size : 2) {
                    canvas.lineTo(this.mLineBuffer[i], this.mLineBuffer[i + 1])
                }
                canvas.stroke()
                canvas.closePath()
            }
        }
        this.mRenderPaint.setDashPathEffect(Option<DashPathEffect>.None)
    }

    public var mGenerateFilledPathBuffer: Path2D = Path2D()

    /**
     * Draws a filled linear path on the canvas.
     *
     * @param c
     * @param dataSet
     * @param trans
     * @param bounds
     */
    protected func drawLinearFill(c: CanvasRenderingContext2D, dataSet: ILineDataSet, trans: Transformer,
        bounds: XBounds): Unit {
        var filled: Path2D = this.mGenerateFilledPathBuffer

        let startingIndex: Int64 = bounds.mins
        let endingIndex: Int64 = bounds.range + bounds.mins
        let indexInterval: Int64 = 128

        var currentStartIndex: Int64 = 0
        var currentEndIndex: Int64 = indexInterval
        var iterations: Int64 = 0

        // 迭代执行以避免大范围的 OutOfMemory 错误
        do {
            currentStartIndex = startingIndex + iterations * indexInterval
            currentEndIndex = currentStartIndex + indexInterval
            currentEndIndex = if (currentEndIndex > endingIndex) {
                endingIndex
            } else {
                currentEndIndex
            }

            if (currentStartIndex <= currentEndIndex) {
                filled = this.generateFilledPath(dataSet, currentStartIndex, currentEndIndex, filled)
                // todo 当前UI不支持 Matrix2D
                //filled = trans.pathValueToPixel(filled)

                let isInverted: Bool = this.mChart.isInverted(dataSet.getAxisDependency())

                let drawable: ?ChartPixelMap = dataSet.getFillDrawable()
                let gradientFillColor: ?ArrayList<ChartColorStop> = dataSet.getGradientFillColor()
                if (let Some(d) <- drawable) {
                    this.drawFilledPath(c, filled, d)
                } else if (gradientFillColor.isSome()) {
                    var topValue = 0.0
                    if (isInverted) {
                        topValue = dataSet.getYMin()
                    } else {
                        topValue = dataSet.getYMax()
                    }
                    let fillMin = dataSet.getFillFormatter().getFillLinePosition(dataSet, this.mChart)
                    let topBottomValueFloat64 = [0.0, topValue, 0.0, fillMin]
                    trans.pointValuesToPixel(topBottomValueFloat64)
                    this.drawGradientFill(c, filled, gradientFillColor(), topBottomValueFloat64[1],
                        topBottomValueFloat64[3])
                } else {
                    this.drawFilledPathWithAlpha(c, filled, dataSet.getFillColor(), dataSet.getFillAlpha())
                }
            }

            iterations++
        } while (currentStartIndex <= currentEndIndex)
    }

    /**
     * Generates a path that is used for filled drawing.
     *
     * @param dataSet    The dataset from which to read the entries.
     * @param startIndex The index from which to start reading the dataset
     * @param endIndex   The index from which to stop reading the dataset
     * @param outputPath The path object that will be assigned the chart data.
     * @return
     */
    private func generateFilledPath(dataSet: ILineDataSet, startIndex: Int64, endIndex: Int64, outputPath: Path2D): Path2D {
        let fillMin: Float64 = dataSet.getFillFormatter().getFillLinePosition(dataSet, this.mChart)
        let phaseY: Float64 = if (let Some(m) <- this.mAnimator) {
            m.getPhaseY()
        } else {
            1.0
        }
        let isDrawSteppedEnabled: Bool = dataSet.getMode() == Mode.STEPPED

        var filled: Path2D = outputPath

        filled = Path2D()

        let entry: EntryOhos = dataSet.getEntryForIndex(startIndex)

        filled.moveTo(entry.getX(), fillMin)
        filled.lineTo(entry.getX(), entry.getY() * phaseY)

        var currentEntry: ?EntryOhos = None
        var previousEntry: EntryOhos = entry
        for (x in startIndex + 1..=endIndex) {
            currentEntry = dataSet.getEntryForIndex(x)

            if (isDrawSteppedEnabled) {
                filled.lineTo(currentEntry().getX(), previousEntry.getY() * phaseY)
            }

            filled.lineTo(currentEntry().getX(), currentEntry().getY() * phaseY)

            previousEntry = currentEntry()
        }

        // close up
        if (currentEntry.isSome()) {
            filled.lineTo(currentEntry().getX(), fillMin)
        }

        filled.closePath()
        return filled
    }

    public func drawValues(c: CanvasRenderingContext2D) {
        if (this.isDrawingValuesAllowed(this.mChart)) {
            let lineData: ?LineData = this.mChart.getLineData()
            if (lineData.isNone()) {
                return
            }
            let dataSets: ArrayList<ILineDataSet> = lineData().getDataSets()

            for (i in 0..dataSets.size) {
                let dataSet: ILineDataSet = dataSets[i]

                if (!this.shouldDrawValues(dataSet) || dataSet.getEntryCount() < 1) {
                    continue
                }

                // apply the text-styling defined by the DataSet
                this.applyValueTextStyle(dataSet)

                let trans: ?Transformer = this.mChart.getTransformer(dataSet.getAxisDependency())

                // make sure the values do not interfere with the circles
                var valOffset: Float64 = dataSet.getCircleRadius() * 1.75

                if (!dataSet.isDrawCirclesEnabled()) {
                    valOffset /= 2.0
                }

                if (this.mXBounds.isNone()) {
                    continue
                }
                this.mXBounds().set(this.mChart, dataSet)

                var positions: Array<Float64> = Array<Float64>()

                if (trans.isSome()) {
                    positions = trans().generateTransformedValuesLine(
                        dataSet,
                        if (let Some(m) <- this.mAnimator) {
                            m.getPhaseX()
                        } else {
                            1.0
                        },
                        if (let Some(m) <- this.mAnimator) {
                            m.getPhaseY()
                        } else {
                            1.0
                        },
                        this.mXBounds().mins,
                        this.mXBounds().maxs
                    )
                }

                let iconsOffset: MPPointF = MPPointF.getInstance(dataSet.getIconsOffset())
                iconsOffset.x = Utils.handleDataValues(iconsOffset.x)
                iconsOffset.y = Utils.handleDataValues(iconsOffset.y)

                for (j in 0..positions.size : 2) {
                    let x: Float64 = positions[j]
                    let y: Float64 = positions[j + 1]

                    if (this.mViewPortHandler.isNone() || !this.mViewPortHandler().isInBoundsRight(x)) {
                        break
                    }

                    if (this.mViewPortHandler.isNone() || !this.mViewPortHandler().isInBoundsLeft(x) ||
                        !this.mViewPortHandler().isInBoundsY(y)) {
                        continue
                    }

                    let entry: EntryOhos = dataSet.getEntryForIndex(j / 2 + this.mXBounds().mins)

                    if (dataSet.isDrawValuesEnabled()) {
                        let valueFormatter: ?IValueFormatter = dataSet.getValueFormatter()
                        if (valueFormatter.isSome()) {
                            this.drawValue(
                                c,
                                valueFormatter(),
                                entry.getY(),
                                entry,
                                i,
                                x,
                                y - valOffset,
                                Color(dataSet.getValueTextColor(j / 2))
                            )
                        }
                    }

                    if (entry.getIcon().isSome() && dataSet.isDrawIconsEnabled()) {
                        let icon: ?ChartPixelMap = entry.getIcon()
                        if (icon.isNone()) {
                            return
                        }
                        Utils.drawImage(
                            c,
                            icon(),
                            floor(x + iconsOffset.x),
                            floor(y + iconsOffset.y)
                        )
                    }
                }

                MPPointF.recycleInstance(iconsOffset)
            }
        }
    }

    public func drawExtras(c: CanvasRenderingContext2D) {
        this.drawCircles(c)
    }

    /**
     * buffer for drawing the circles
     */
    private var mCirclesBuffer: Array<Float64> = Array<Float64>(2, item: 0.0)

    protected func drawCircles(c: CanvasRenderingContext2D) {
        if (this.mViewPortHandler.isNone() || this.mAnimator.isNone()) {
            return
        }
        this.mRenderPaint.setStyle(Style.FILL)

        let phaseY: Float64 = this.mAnimator().getPhaseY()

        this.mCirclesBuffer[0] = 0.0
        this.mCirclesBuffer[1] = 0.0

        let lineData: ?LineData = this.mChart.getLineData()
        if (lineData.isNone()) {
            return
        }

        let dataSets: ArrayList<ILineDataSet> = lineData().getDataSets()
        for (i in 0..dataSets.size) {
            let dataSet: ILineDataSet = dataSets[i]

            if (!dataSet.isVisible() || !dataSet.isDrawCirclesEnabled() || dataSet.getEntryCount() == 0) {
                continue
            }

            this.mCirclePaintInner.setColor(Color(dataSet.getCircleHoleColor()))

            let trans: ?Transformer = this.mChart.getTransformer(dataSet.getAxisDependency())

            this.mXBounds?.set(this.mChart, dataSet)

            let circleRadius: Float64 = dataSet.getCircleRadius()
            let circleHoleRadius: Float64 = dataSet.getCircleHoleRadius()
            let drawCircleHole: Bool = dataSet.isDrawCircleHoleEnabled() && circleHoleRadius < circleRadius &&
                circleHoleRadius > 0.0
            let drawTransparentCircleHole: Bool = drawCircleHole && dataSet.getCircleHoleColor() == ColorTemplate.
                COLOR_NONE

            if (this.mXBounds.isNone()) {
                return
            }
            let boundsRangeCount: Int64 = this.mXBounds().range + this.mXBounds().mins

            for (j in this.mXBounds().mins..=boundsRangeCount) {
                let e: EntryOhos = dataSet.getEntryForIndex(j)

                this.mCirclesBuffer[0] = e.getX()
                this.mCirclesBuffer[1] = e.getY() * phaseY

                trans?.pointValuesToPixel(this.mCirclesBuffer)

                if (!this.mViewPortHandler().isInBoundsRight(this.mCirclesBuffer[0])) {
                    break
                }

                if (!this.mViewPortHandler().isInBoundsLeft(this.mCirclesBuffer[0]) ||
                    !this.mViewPortHandler().isInBoundsY(this.mCirclesBuffer[1])) {
                    continue
                }
                this.fill(c, dataSet, drawCircleHole, drawTransparentCircleHole, this.mCirclesBuffer[0] - circleRadius,
                    this.mCirclesBuffer[1] - circleRadius)
            }
        }
    }

    public func fill(c: CanvasRenderingContext2D, set: ILineDataSet, drawCircleHole: Bool,
        drawTransparentCircleHole: Bool, offsetX: Float64, offsetY: Float64): Unit {
        let colorCount: Int64 = set.getCircleColorCount()
        let circleRadius: Float64 = set.getCircleRadius()
        let circleHoleRadius: Float64 = set.getCircleHoleRadius()
        for (i in 0..colorCount) {
            this.mRenderPaint.setColor(Color(set.getCircleColor(i)))
            if (drawTransparentCircleHole) {
                // Begin path for circle with hole
                Utils.resetContext2DStyle(c, this.mRenderPaint)
                c.beginPath()
                c.arc(circleRadius + offsetX, circleRadius + offsetY, circleRadius, 0.0, Float64.PI * 2.0,
                    anticlockwise: false)

                // Cut hole in path
                c.arc(circleRadius + offsetX, circleRadius + offsetY, circleHoleRadius, 0.0, Float64.PI * 2.0,
                    anticlockwise: true)

                // Fill in-between
                c.fill()
                c.closePath()
            } else {
                Utils.resetContext2DStyle(c, this.mRenderPaint)
                c.beginPath()
                c.arc(circleRadius + offsetX, circleRadius + offsetY, circleRadius, 0.0, Float64.PI * 2.0)
                c.fill()
                c.closePath()

                if (drawCircleHole) {
                    Utils.resetContext2DStyle(c, this.mCirclePaintInner)
                    c.beginPath()
                    c.arc(circleRadius + offsetX, circleRadius + offsetY, circleHoleRadius, 0.0, Float64.PI * 2.0)
                    c.fill()
                    c.closePath()
                }
            }
        }
    }

    public func drawHighlighted(c: CanvasRenderingContext2D, indices: Array<Highlight>) {
        let lineData: ?LineData = this.mChart.getLineData()
        if (lineData.isNone()) {
            return
        }

        for (high in indices) {
            let set: ?ILineDataSet = lineData().getDataSetByIndex(high.getDataSetIndex())

            if (set.isNone() || !set().isHighlightEnabled()) {
                continue
            }

            let e: ?EntryOhos = set().getEntryForXValue(high.getX(), high.getY(), rounding: Rounding.CLOSEST)

            if (e.isNone() || !this.isInBoundsX(e, set())) {
                continue
            }

            let trans: ?Transformer = this.mChart.getTransformer(set().getAxisDependency())
            if (trans.isNone()) {
                return
            }
            let pix: MPPointD = trans().getPixelForValues(
                e().getX(),
                e().getY() * if (this.mAnimator.isSome()) {
                    this.mAnimator().getPhaseY()
                } else {
                    1.0
                }
            )

            high.setDraw(pix.x, pix.y)

            // draw the lines
            this.drawHighlightLines(c, pix.x, pix.y, set())
        }
    }

    /**
     * Releases the drawing bitmap. This should be called when {@link LineChart#onDetachedFromWindow()}.
     */
    public func releaseBitmap(): Unit {
        if (this.mBitmapCanvas.isSome()) {
            this.mBitmapCanvas = None
        }

        if (this.mDrawBitmap.isSome()) {
            this.mDrawBitmap = None
        }
    }
}
