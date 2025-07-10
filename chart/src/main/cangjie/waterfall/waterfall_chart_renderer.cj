/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.waterfall

public class WaterfallChartRenderer <: BarLineScatterCandleBubbleRenderer {
    protected var mBarBuffers: Array<WaterfallBuffer> = Array<WaterfallBuffer>()
    public var mChart: WaterfallDataProvider

    protected var mBarRect: ChartRect = ChartRect()
    protected var mShadowPaint: ChartPaint
    protected var mBarBorderPaint: ChartPaint

    public init(chart: WaterfallDataProvider, animator: ChartAnimator, viewPortHandler: ViewPortHandler) {
        super(animator, viewPortHandler)
        this.mChart = chart

        this.mHighlightPaint = ChartPaint()
        this.mHighlightPaint.setStyle(Style.FILL)
        this.mHighlightPaint.setColor(Color.BLACK)
        // set alpha after color
        this.mHighlightPaint.setGlobalAlpha(120.0 / 255.0)

        this.mShadowPaint = ChartPaint()
        this.mShadowPaint.setStyle(Style.FILL)

        this.mBarBorderPaint = ChartPaint()
        this.mBarBorderPaint.setStyle(Style.STROKE)
    }

    public func initBuffers(): Unit {
        let data: ?WaterfallData = this.mChart.getWaterfallData()
        if (let Some(d) <- data) {
            this.mBarBuffers = Array<WaterfallBuffer>(d.getDataSetCount(), repeat: WaterfallBuffer(0, 0, false))
            for (i in 0..this.mBarBuffers.size) {
                let dataSet: ?IWaterfallDataSet = d.getDataSetByIndex(i)
                if (let Some(ds: IWaterfallDataSet) <- dataSet) {
                    let size: Int64 = ds.getEntryCount() * 4 * (if (ds.isStacked()) {
                        ds.getStackSize()
                    } else {
                        1
                    })
                    this.mBarBuffers[i] = WaterfallBuffer(size, d.getDataSetCount(), ds.isStacked())
                }
            }
        }
    }

    private var mWaterfallShadowRectBuffer: ChartRect = ChartRect()

    public func drawData(c: CanvasRenderingContext2D): Unit {
        let data: ?WaterfallData = this.mChart.getWaterfallData()
        if (let Some(d) <- data) {
            let count: Int64 = d.getDataSetCount()
            for (i in 0..count) {
                let set: ?IWaterfallDataSet = d.getDataSetByIndex(i)
                if (let Some(ds: WaterfallDataSet) <- set) {
                    if (ds.isVisible()) {
                        this.drawDataSet(c, ds, i)
                    }
                }
            }
        }
    }

    protected func drawDataSet(c: CanvasRenderingContext2D, dataSet: WaterfallDataSet, index: Int64): Unit {
        let trans: ?Transformer = this.mChart.getTransformer(dataSet.getAxisDependency())
        this.mBarBorderPaint.setColor(Color(dataSet.getBarBorderColor()))
        this.mBarBorderPaint.setStrokeWidth(Utils.handleDataValues(dataSet.getBarBorderWidth()))

        let drawBorder: Bool = dataSet.getBarBorderWidth() > 0.0

        var phaseX: Float64 = 1.0
        var phaseY: Float64 = 1.0
        if (let Some(m) <- this.mAnimator) {
            phaseX = m.getPhaseX()
            phaseY = m.getPhaseY()
        }
        // draw the bar shadow before the values
        if (this.mChart.isDrawBarShadowEnabled()) {
            this.mShadowPaint.setColor(Color(dataSet.getBarShadowColor()))

            let waterfallData: ?WaterfallData = this.mChart.getWaterfallData()
            var barWidth: Float64
            if (let Some(d) <- waterfallData) {
                barWidth = d.getBarWidth()
            } else {
                return
            }

            let barWidthHalf: Float64 = barWidth / 2.0
            var x: Float64 = 0.0
            let count = min(Int64(ceil(Float64(dataSet.getEntryCount()) * phaseX)), dataSet.getEntryCount())
            for (i in 0..count) {
                let entry: ?WaterfallEntry = dataSet.getEntryForIndex(i)
                if(let Some(e) <- entry) {
                    x = e.getX()
                }

                this.mWaterfallShadowRectBuffer.left = x - barWidthHalf
                this.mWaterfallShadowRectBuffer.right = x + barWidthHalf

                if (let Some(t) <- trans) {
                    t.rectValueToPixel(this.mWaterfallShadowRectBuffer)
                }

                if (this.mViewPortHandler.isNone() ||
                    !this.mViewPortHandler().isInBoundsLeft(this.mWaterfallShadowRectBuffer.right)) {
                    continue
                }

                if (this.mViewPortHandler.isNone() ||
                    !this.mViewPortHandler().isInBoundsRight(this.mWaterfallShadowRectBuffer.left)) {
                    break
                }

                this.mWaterfallShadowRectBuffer.top = if (let Some(handle) <- this.mViewPortHandler) {
                    handle.contentTop()
                } else {
                    0.0
                }
                this.mWaterfallShadowRectBuffer.bottom = if (let Some(handle) <- this.mViewPortHandler) {
                    handle.contentBottom()
                } else {
                    0.0
                }

                Utils.resetContext2DStyle(c, this.mShadowPaint)
                c.beginPath()
                c.rect(this.mWaterfallShadowRectBuffer.left, this.mWaterfallShadowRectBuffer.top,
                    this.mWaterfallShadowRectBuffer.width(), this.mWaterfallShadowRectBuffer.height())
                match (this.mShadowPaint.getStyle()) {
                    case Style.STROKE => c.stroke()
                    case Style.FILL => c.fill()
                    case Style.FILL_AND_STROKE => c.fill()
                    case _ => c.fill()
                }
                c.closePath()
            }
        }

        // initialize the buffer
        let buffer: WaterfallBuffer = this.mBarBuffers[index]
        buffer.setPhases(phaseX, phaseY)
        buffer.setDataSet(index)
        buffer.setInverted(this.mChart.isInverted(dataSet.getAxisDependency()))
        let waterfallData: ?WaterfallData = this.mChart.getWaterfallData()
        if (let Some(data) <- waterfallData) {
            buffer.setBarWidth(data.getBarWidth())
        }
        buffer.feed(dataSet)
        let tempArray: Array<Float64> = buffer.buffer.toArray()
        if (let Some(t) <- trans) {
            t.pointValuesToPixel(tempArray)
            buffer.buffer = ArrayList<Float64>(tempArray)
        }
        let fills: ?ArrayList<Fill> = dataSet.getFills()
        let isCustomFill: Bool = fills.isSome() && fills().size > 0
        let isSingleColor: Bool = dataSet.getColors().size == 1
        let isInverted: Bool = this.mChart.isInverted(dataSet.getAxisDependency())
        if (isSingleColor) {
            this.mRenderPaint.setColor(Color(dataSet.getColor()))
            let opacity = dataSet.getOpacity()
            this.mRenderPaint.setGlobalAlpha(opacity)

        }

        let arrayTop = buffer.getArrayTop()
        var maxTop = arrayTop[0]
        for (i in 1..arrayTop.size) {
            if (arrayTop[i] > maxTop) {
                maxTop = arrayTop[i]
            }
        }

        let arrayBottom = buffer.getArrayBottom()
        var minBottom = arrayBottom[0]

        for (i in 1..arrayBottom.size) {
            if (arrayBottom[i] < minBottom) {
                minBottom = arrayBottom[i]
            }
        }
        if (dataSet.getEnableMaxOrMinHighlightColor()) {
            for (i in 0..Int64(min((ceil(Float64(dataSet.getEntryCount()) * phaseX)), Float64(dataSet.getEntryCount())))) {
                let entry: ?WaterfallEntry = dataSet.getEntryForIndex(i)
                if(let Some(e) <- entry) {
                    this.initMaxAndMinHighlightData(e, dataSet, maxTop, minBottom)
                }
            }
        }
        // 获取Y轴刻度范围数据
        let yAxisSegmentList = dataSet.getYAxisSegmentationColors()
        var j: Int64 = 0
        var pos: Int64 = 0
        while (j < buffer.size()) {
            if (this.mViewPortHandler.isNone() || !this.mViewPortHandler().isInBoundsLeft(buffer.buffer[j + 2])) {
                j += 4
                pos++
                continue
            }

            if (this.mViewPortHandler.isNone() || !this.mViewPortHandler().isInBoundsRight(buffer.buffer[j])) {
                break
            }
            if (!isSingleColor) {
                // Set the color for the currently drawn value. If the index
                // is out of bounds, reuse colors.
                this.mRenderPaint.setColor(Color(dataSet.getColor(pos)))
            }
            if (isCustomFill) {
                let fill: Fill = dataSet.getFill(pos)

                fill.fillRect(c, this.mRenderPaint, buffer.buffer[j], buffer.buffer[j + 1], buffer.buffer[j + 2],
                    buffer.buffer[j + 3], if (isInverted) {
                    FillDirection.DOWN
                } else {
                    FillDirection.UP
                })
            } else {
                Utils.resetContext2DStyle(c, this.mRenderPaint)

                let left: Float64 = buffer.buffer[j]
                let bottom: Float64 = buffer.buffer[j + 1]
                let right: Float64 = buffer.buffer[j + 2]
                let top: Float64 = buffer.buffer[j + 3]

                //绘制数据
                let radius = (right - left) / 2.0

                var path = Path2D()
                var outBarIsEllipse = false
                if (abs(top - bottom) > (right - left)) {
                    path = this.drawRoundedRectangles(c, left, top, right, bottom, radius)
                } else {
                    outBarIsEllipse = true
                    path = this.drawEllipse(c, left, top, right, bottom)
                }

                let entry: ?WaterfallEntry = dataSet.getEntryForIndex(j / 4)
                if(let Some(e) <- entry) {
                    //绘制Y轴刻度范围图
                    for (i in 0..yAxisSegmentList.size) {
                        let h = yAxisSegmentList[i]
                        //canvas画布的y轴与图表的y轴方向相反
                        var maxY = h.getMinY()
                        var minY = h.getMaxY()
                        if (maxY > e.getMaxY() || (minY < e.getMaxY() && minY < e.getMinY())) {
                            continue
                        }
                        maxY = if (maxY <= e.getMinY()) {
                            e.getMinY()
                        } else {
                            maxY
                        }
                        minY = if (minY >= e.getMaxY()) {
                            e.getMaxY()
                        } else {
                            minY
                        }
                        let yArray = [0.0, minY, 0.0, maxY]
                        trans?.pointValuesToPixel(yArray)
                        if (abs(yArray[1] - yArray[3]) > (right - left)) {
                            c.save()
                            c.fillStyle(Color(h.getColor()))
                            this.newMethod(c, left, right, radius, yArray, e, minY, maxY)
                            c.restore()
                        } else {
                            if (h.getMaxY() > e.getMaxY() || h.getMinY() < e.getMinY()) {
                                continue
                            }
                            c.save()
                            c.fillStyle(Color(h.getColor()))
                            if (yArray[3] + 2.0 * radius > bottom) {
                                this.drawCircle(c, left, bottom - 2.0 * radius, radius)
                            } else {
                                this.drawCircle(c, left, yArray[3], radius)
                            }
                            c.restore()
                        }
                    }

                    let highlights = e.getHighlights()
                    let topNum = this.getHighlightTop(e)
                    //绘制标记点
                    for (i in 0..highlights.size) {
                        let h = highlights[i]
                        //canvas画布的y轴与图表的y轴方向相反
                        let maxY = h.getMinY()
                        let minY = h.getMaxY()
                        let yArray = [0.0, minY, 0.0, maxY]
                        trans?.pointValuesToPixel(yArray)

                        if (yArray[1] == yArray[3]) {
                            c.save()
                            c.fillStyle(h.getColor())
                            c.clip(path)
                            if (outBarIsEllipse) {
                                this.drawEllipse(c, left, top, right, bottom)
                            } else {
                                if (yArray[1] == top) {
                                //绘制最高点
                                    this.drawEllipse(c, left, top, right, top + radius * 2.0)
                                } else {
                                //绘制最低点
                                    this.drawEllipse(c, left, bottom - radius * 2.0, right, bottom)
                                }
                            }
                            c.restore()
                            continue
                        }

                        c.save()
                        c.fillStyle(h.getColor())
                        c.clip(path)
                        if (e.getHighlights().size == 1) {
                            this.drawRoundedRectangles(c, left, yArray[1], right, yArray[3], radius)
                        } else {
                            this.drawHighlights(c, left, radius, yArray, i, right, h, topNum, outBarIsEllipse)
                        }
                        c.restore()

                    }
                }

            }

            if (drawBorder) {
                Utils.resetContext2DStyle(c, this.mBarBorderPaint)

                c.beginPath()
                c.rect(buffer.buffer[j], buffer.buffer[j + 1], buffer.buffer[j + 2] - buffer.buffer[j],
                    buffer.buffer[j + 3] - buffer.buffer[j + 1])
                c.stroke()
                c.closePath()
            }
            pos++
            j += 4
        }

        dataSet.setMaxTopHighlightEXIST(false)
        dataSet.setMinBottomHighlightEXIST(false)
    }

    private func drawHighlights(c: CanvasRenderingContext2D, left: Float64, radius: Float64, yArray: Array<Float64>,
        i: Int64, right: Float64, h: WaterfallHighlight, topNum: Float64, outBarIsEllipse: Bool) {
        c.beginPath()
        c.moveTo(left + radius, yArray[1])
        if (outBarIsEllipse) {
            this.drawEllipse(c, left, yArray[1], right, yArray[3])
            return
        }
        if (i == 0) {
            this.brawBottomCircularCylinder(c, right, yArray, radius, left)
        } else if (h.getMaxY() == topNum) {
            c.lineTo(right - radius, yArray[1])
            c.arc(right - radius, yArray[1] + radius, radius, 3.0 / 2.0 * Float64.getPI(), 0.0)
            c.lineTo(right, yArray[3])
            c.lineTo(left, yArray[3])
            c.lineTo(left, yArray[1] + radius)
            c.arc(left + radius, yArray[1] + radius, radius, Float64.getPI(), 3.0 / 2.0 * Float64.getPI())
        } else {
            c.rect(left, yArray[1], right - left, yArray[3] - yArray[1])
        }
        c.closePath()
        c.fill()
    }

    private func brawBottomCircularCylinder(c: CanvasRenderingContext2D, right: Float64, yArray: Array<Float64>,
        radius: Float64, left: Float64) {
        c.lineTo(right, yArray[1])
        c.lineTo(right, yArray[3] - radius)
        c.arc(right - radius, yArray[3] - radius, radius, 0.0, Float64.getPI() / 2.0)
        c.lineTo(left + radius, yArray[3])
        c.arc(left + radius, yArray[3] - radius, radius, Float64.getPI() / 2.0, Float64.getPI())
        c.lineTo(left, yArray[1])
    }

    private func getHighlightTop(e: WaterfallEntry) {
        var topNum: Float64 = 0.0
        for (i in 0..e.getHighlights().size) {
            if (e.getHighlights()[i].getMaxY() == e.getHighlights()[i].getMinY()) {
                continue
            }
            topNum = if (e.getHighlights()[i].getMaxY() > topNum) {
                e.getHighlights()[i].getMaxY()
            } else {
                topNum
            }
        }
        return topNum
    }

    private func newMethod(c: CanvasRenderingContext2D, left: Float64, right: Float64, radius: Float64,
        yArray: Array<Float64>, e: WaterfallEntry, minY: Float64, maxY: Float64) {
        c.beginPath()
        c.moveTo(left + radius, yArray[1])
        if (e.getMaxY() == minY && e.getMinY() == maxY) {
            this.drawRoundedRectangles(c, left, yArray[1], right, yArray[3], radius)
        } else if (e.getMaxY() == minY) {
            c.lineTo(right - radius, yArray[1])
            c.arc(right - radius, yArray[1] + radius, radius, 3.0 / 2.0 * Float64.getPI(), 0.0)
            c.lineTo(right, yArray[3])
            c.lineTo(left, yArray[3])
            c.lineTo(left, yArray[1] + radius)
            c.arc(left + radius, yArray[1] + radius, radius, Float64.getPI(), 3.0 / 2.0 * Float64.getPI())
        } else if (e.getMinY() == maxY) {
            this.brawBottomCircularCylinder(c, right, yArray, radius, left)
        } else {
            c.rect(left, yArray[1], right - left, yArray[3] - yArray[1])
        }
        c.closePath()
        c.fill()
    }

    protected func drawEllipse(c: CanvasRenderingContext2D, left: Float64, top: Float64, right: Float64, bottom: Float64): Path2D {
        let path = Path2D()
        let centerX = (left + right) / 2.0
        let centerY = (top + bottom) / 2.0
        let radiusX = (right - left) / 2.0
        let radiusY = (bottom - top) / 2.0
        path.ellipse(centerX, centerY, radiusX, radiusY, 0.0, 0.0, 2.0 * Float64.getPI())
        path.closePath()
        c.fill(path)
        return path
    }

    protected func drawRect(c: CanvasRenderingContext2D, left: Float64, top: Float64, right: Float64, bottom: Float64) {
        c.moveTo(left, top)
        c.lineTo(left, bottom)
        c.lineTo(right, bottom)
        c.lineTo(right, top)
        c.lineTo(left, top)
        c.fill()
    }

    private func drawCircle(c: CanvasRenderingContext2D, left: Float64, top: Float64, radius: Float64) {
        c.beginPath()
        c.arc(left + radius, top + radius, radius, 0.0, 2.0 * Float64.getPI())
        c.closePath()
        c.fill()
    }

    private func drawRoundedRectangles(c: CanvasRenderingContext2D, left: Float64, top: Float64, right: Float64,
        bottom: Float64, radius: Float64): Path2D {
        let path = Path2D()
        path.moveTo(left + radius, top)
        path.lineTo(right - radius, top)
        path.arc(right - radius, top + radius, radius, 3.0 / 2.0 * Float64.getPI(), 0.0)
        path.lineTo(right, bottom - radius)
        path.arc(right - radius, bottom - radius, radius, 0.0, Float64.getPI() / 2.0)
        path.lineTo(left + radius, bottom)
        path.arc(left + radius, bottom - radius, radius, Float64.getPI() / 2.0, Float64.getPI())
        path.lineTo(left, top + radius)
        path.arc(left + radius, top + radius, radius, Float64.getPI(), 30.0 / 2.0 * Float64.getPI())
        path.closePath()
        c.fill(path)
        return path
    }

    private func initMaxAndMinHighlightData(e: WaterfallEntry, dataSet: WaterfallDataSet, maxTop: Float64,
        minBottom: Float64) {

        if (maxTop == e.getMaxY() && !dataSet.getMaxTopHighlightEXIST()) {
            dataSet.setMaxTopHighLightEXIST(true)
            e.setHighlights(WaterfallHighlight(maxTop, maxTop, color:dataSet.getMaxyHighlightColor()))
        }

        if (minBottom == e.getMinY() && !dataSet.getMinBottomHighlightEXIST()) {
            dataSet.setMinBottomHighlightEXIST(true)
            e.setHighlights(WaterfallHighlight(minBottom, minBottom, color:dataSet.getMinyHighlightColor()))
        }
    }
    protected open func isDrawingValuesAllowed(chart: WaterfallDataProvider): Bool {
        let chartData: ?WaterfallData = chart.getWaterfallData()
        if (this.mViewPortHandler.isSome() && chartData.isSome()) {
            return Float64(chartData().getEntryCount()) < Float64(chart.getMaxVisibleCount()) *
                this.mViewPortHandler().getScaleX()
        }
        return false
    }
    public func drawValues(c: CanvasRenderingContext2D,isHorizontalFlip!: Bool = false): Unit {
        if (this.mChart.getWaterfallData().isNone()) {
            return
        }
        // if values are drawn
        if (this.isDrawingValuesAllowed(this.mChart)) {
            let waterfallData: ?WaterfallData = this.mChart.getWaterfallData()
            var dataSets: ArrayList<IWaterfallDataSet>
            if (let Some(data) <- waterfallData) {
                dataSets = data.getDataSets()
            } else {
                return
            }

            let valueOffsetPlus: Float64 = .0
            var posOffset: Float64 = 0.0
            var negOffset: Float64 = 0.0
            let drawValueAboveBar: Bool = this.mChart.isDrawValueAboveBarEnabled()

            let count: Int64 = waterfallData().getDataSetCount()
            for (i in 0..count) {
                let waterfallDataSet: ?IWaterfallDataSet = dataSets.get(i)
                if(let Some(dataSet) <- waterfallDataSet) {
                    if (!this.shouldDrawValues(dataSet)) {
                        continue
                    }

                    // apply the text-styling defined by the DataSet
                    this.applyValueTextStyle(dataSet)

                    let isInverted: Bool = this.mChart.isInverted(dataSet.getAxisDependency())

                    // calculate the correct offset depending on the draw position of
                    // the value
                    let valueTextHeight: Float64 = Utils.calcTextHeight(c, this.mValuePaint, "8")
                    posOffset = (if (drawValueAboveBar) {
                        -valueOffsetPlus
                    } else {
                        valueTextHeight + valueOffsetPlus
                    })
                    negOffset = (if (drawValueAboveBar) {
                        valueTextHeight + valueOffsetPlus
                    } else {
                        -valueOffsetPlus
                    })

                    if (isInverted) {
                        posOffset = -posOffset - valueTextHeight
                        negOffset = -negOffset - valueTextHeight
                    }

                    // get the buffer
                    let buffer: WaterfallBuffer = this.mBarBuffers[i]

                    let iconsOffset: MPPointF = MPPointF.getInstance(dataSet.getIconsOffset())
                    iconsOffset.x = Utils.handleDataValues(iconsOffset.x)
                    iconsOffset.y = Utils.handleDataValues(iconsOffset.y)
                    let limit: Int64 = buffer.buffer.size * if (let Some(m) <- this.mAnimator) {
                        Int64(m.getPhaseX())
                    } else {
                        1
                    }
                    for (j in 0..limit : 4) {
                        let x: Float64 = (buffer.buffer[j] + buffer.buffer[j + 2]) / 2.0

                        if (this.mViewPortHandler.isNone() || !this.mViewPortHandler().isInBoundsRight(x)) {
                            break
                        }

                        if (this.mViewPortHandler.isNone() || !this.mViewPortHandler().isInBoundsY(buffer.buffer[j + 1])
                            || !this.mViewPortHandler().isInBoundsLeft(x)) {
                            continue
                        }

                        let entry: ?WaterfallEntry = dataSet.getEntryForIndex(j / 4)
                        if(let Some(waterfallEntry) <- entry) {
                            let val: Float64 = waterfallEntry.getY()

                            if (dataSet.isDrawValuesEnabled()) {
                                let valueFormatter: ?IValueFormatter = dataSet.getValueFormatter()
                                if (let Some(format) <- valueFormatter) {
                                     this.drawValue(c, format, val, waterfallEntry, i, x, (buffer.buffer[j + 3] + posOffset),
                                        Color(dataSet.getValueTextColor(j / 4)))
                                }
                            }
                            let icon: ?ChartPixelMap = waterfallEntry.getIcon()
                            if (let Some(i) <- icon) {
                                if (dataSet.isDrawIconsEnabled()) {
                                    var px: Float64 = x
                                    var py: Float64 = if (val >= 0.0) {
                                        (buffer.buffer[j + 1] + posOffset)
                                    } else {
                                        (buffer.buffer[j + 3] + negOffset)
                                    }

                                    px += iconsOffset.x
                                    py += iconsOffset.y

                                    Utils.drawImage(
                                        c,
                                        i,
                                        Utils.parseInt(px),
                                        Utils.parseInt(py),
                                        i.getWidth(),
                                        i.getHeight()
                                    )
                                }
                            }
                        }

                    }

                    MPPointF.recycleInstance(iconsOffset)
                }


            }
        }
    }

    public func drawHighlighted(c: CanvasRenderingContext2D, indices: Array<Highlight>): Unit {
        let waterfallData: ?WaterfallData = this.mChart.getWaterfallData()
        if (waterfallData.isNone()) {
            return
        }

        for (i in 0..indices.size) {
            let high: Highlight = indices[i]
            let set: ?IWaterfallDataSet = waterfallData().getDataSetByIndex(high.getDataSetIndex())

            if (set.isNone() || !set().isHighlightEnabled()) {
                continue
            }

            let e: ?WaterfallEntry = set().getEntryForXValue(high.getX(), high.getY(), rounding: Rounding.CLOSEST)
            if (e.isNone()) {
                continue
            }
            if (!this.isInBoundsX(e, set())) {
                continue
            }

            let trans: ?Transformer = this.mChart.getTransformer(set().getAxisDependency())
            var highLightColor: UInt32 = set().getHighLightColor()

            this.mHighlightPaint.setColor(Color(highLightColor))
            this.mHighlightPaint.setGlobalAlpha(set().getHighLightAlpha() / 255.0)

            var y1: Float64 = 0.0
            var y2: Float64 = 0.0

            y1 = e().getY()
            y2 = e().getMinY()
            if (let Some(t) <- trans) {
                this.prepareBarHighlight(e().getX(), y1, y2, waterfallData().getBarWidth() / 2.0, t)
            }

            this.setHighlightDrawPos(high, this.mBarRect)
            Utils.resetContext2DStyle(c, this.mHighlightPaint)

            let round = this.mBarRect.width() / 2.0
            if (this.mBarRect.height() >= this.mBarRect.width()) {

                c.beginPath()
                c.moveTo(this.mBarRect.left + round, this.mBarRect.top)
                c.lineTo(this.mBarRect.right - round, this.mBarRect.top)
                c.arc(this.mBarRect.right - round, this.mBarRect.top + round, round, 3.0 / 2.0 * Float64.getPI(), 0.0)
                c.lineTo(this.mBarRect.right, this.mBarRect.bottom - round)
                c.arc(this.mBarRect.right - round, this.mBarRect.bottom - round, round, 0.0, Float64.getPI() / 20.0)
                c.lineTo(this.mBarRect.left + round, this.mBarRect.bottom)
                c.arc(this.mBarRect.left + round, this.mBarRect.bottom - round, round, Float64.getPI() / 2.0, Float64.getPI())
                c.lineTo(this.mBarRect.left, this.mBarRect.top + round)
                c.arc(this.mBarRect.left + round, this.mBarRect.top + round, round, Float64.getPI(), 3.0 / 2.0 * Float64.getPI())
                c.closePath()
                c.fill()

            } else {
                this.drawEllipse(c, this.mBarRect.left, this.mBarRect.top, this.mBarRect.right, this.mBarRect.bottom)
            }
        }
    }

    protected func prepareBarHighlight(x: Float64, y1: Float64, y2: Float64, barWidthHalf: Float64,
        transformer: Transformer): Unit {
        let left: Float64 = x - barWidthHalf
        let right: Float64 = x + barWidthHalf
        let top: Float64 = y1
        let bottom: Float64 = y2

        this.mBarRect.set(left, top, right, bottom)

        transformer.rectToPixelPhase(
            this.mBarRect,
            if (let Some(animator) <- this.mAnimator) {
                animator.getPhaseY()
            } else {
                1.0
            }
        )
    }

    protected open func setHighlightDrawPos(high: Highlight, bar: ChartRect): Unit {
        high.setDraw(bar.centerX(), bar.top)
    }

    public func drawExtras(c: CanvasRenderingContext2D): Unit {}

}
