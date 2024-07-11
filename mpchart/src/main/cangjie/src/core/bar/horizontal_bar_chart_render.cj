/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package core.bar

public class HorizontalBarChartRenderer <: BarChartRenderer {
    var horizontalBarBuffer: Array<HorizontalBarBuffer> = Array<HorizontalBarBuffer>()

    public init(chart: BarDataProvider, animator: ChartAnimator, viewPortHandler: ViewPortHandler) {
        super(chart, animator, viewPortHandler)
        this.mValuePaint.setTextAlign(TextAlignStyle.Left)
    }

    public func initBuffers() {
        let barData: ?BarData = this.mChart.getBarData()
        if (let Some(batdata) <- barData) {
            this.horizontalBarBuffer = Array<HorizontalBarBuffer>(
                batdata.getDataSetCount(),
                item: HorizontalBarBuffer(0, 0, false)
            )
            for (i in 0..this.horizontalBarBuffer.size) {
                let set: ?IBarDataSet = batdata.getDataSetByIndex(i)
                if (let Some(iBarDataSet) <- set) {
                    this.horizontalBarBuffer[i] = HorizontalBarBuffer(
                        iBarDataSet.getEntryCount() * 4 * (if (iBarDataSet.isStacked()) {
                        iBarDataSet.getStackSize()
                    } else {
                        1
                    }), batdata.getDataSetCount(), iBarDataSet.isStacked())
                }
            }
        } else {
            return
        }
    }

    public func drawDataSet(c: CanvasRenderingContext2D, dataSet: IBarDataSet, index: Int64) {
        if (this.mChart.getBarData().isNone() || this.mViewPortHandler.isNone() || this.mAnimator.isNone()) {
            return
        }
        let trans: ?Transformer = this.mChart.getTransformer(dataSet.getAxisDependency())
        this.mBarBorderPaint.setColor(Color(dataSet.getBarBorderColor()))
        this.mBarBorderPaint.setStrokeWidth(Utils.handleDataValues(dataSet.getBarBorderWidth()))

        let phaseX = this.mAnimator().getPhaseX()

        // draw the bar shadow before the values
        if (this.mChart.isDrawBarShadowEnabled()) {
            this.mShadowPaint.setColor(Color(dataSet.getBarShadowColor()))

            let barData: ?BarData = this.mChart.getBarData()

            if (barData.isNone()) {
                return
            }
            let barWidth: Float64 = barData().getBarWidth()
            let barWidthHalf: Float64 = barWidth / 2.0
            var x: Float64 = 0.0

            for (i in 0..Int64(min((ceil(Float64(dataSet.getEntryCount()) * phaseX)), Float64(dataSet.getEntryCount())))) {
                let e: BarEntry = dataSet.getEntryForIndex(i)

                x = e.getX()

                this.mBarShadowRectBuffer.top = x - barWidthHalf
                this.mBarShadowRectBuffer.bottom = x + barWidthHalf
                if(let Some(t) <- trans) {
                    t.rectValueToPixel(this.mBarShadowRectBuffer)
                }
                
                if (!this.mViewPortHandler().isInBoundsTop(this.mBarShadowRectBuffer.bottom)) {
                    continue
                }
                if (!this.mViewPortHandler().isInBoundsBottom(this.mBarShadowRectBuffer.top)) {
                    break
                }

                this.mBarShadowRectBuffer.left = this.mViewPortHandler().contentLeft()
                this.mBarShadowRectBuffer.right = this.mViewPortHandler().contentRight()

                Utils.resetContext2DStyle(c, this.mShadowPaint)
                c.beginPath()
                c.rect(this.mBarShadowRectBuffer.left, this.mBarShadowRectBuffer.top, this.mBarShadowRectBuffer.width(),
                    this.mBarShadowRectBuffer.height())
                c.fill()
                c.closePath()
            }
        }
        drawDataSetFunc(index, phaseX, dataSet, trans, c)
    }

    private func drawDataSetFunc(index: Int64, phaseX: Float64, dataSet: IBarDataSet, trans: ?Transformer,
        c: CanvasRenderingContext2D): Unit {
        let phaseY = this.mAnimator().getPhaseY()
        let drawBorder: Bool = dataSet.getBarBorderWidth() > 0.0
        let buffer: BarBuffer = this.horizontalBarBuffer[index]
        buffer.setPhases(phaseX, phaseY)
        buffer.setDataSet(index)
        buffer.setInverted(this.mChart.isInverted(dataSet.getAxisDependency()))
        let barData: ?BarData = this.mChart.getBarData()

        if (let Some(bar) <- barData) {
        	buffer.setBarWidth(bar.getBarWidth())
        }

        buffer.feed(dataSet)
        let tempArray: Array<Float64> = buffer.buffer.toArray()
        if (let Some(tran) <- trans) {
        	tran.pointValuesToPixel(tempArray)
            buffer.buffer = ArrayList<Float64>(tempArray)
        }
        let fills: ?ArrayList<Fill> = dataSet.getFills()
        let isCustomFill: Bool = fills.isSome() && fills().size > 0

        let isSingleColor: Bool = dataSet.getColors().size == 1
        let isInverted: Bool = this.mChart.isInverted(dataSet.getAxisDependency())

        if (isSingleColor) {
            this.mRenderPaint.setColor(Color(dataSet.getColor()))
        }

        var j: Int64 = 0
        var pos: Int64 = 0
        while (j < buffer.size()) {
            if (!this.mViewPortHandler().isInBoundsTop(buffer.buffer[j + 3])) {
                break
            }

            if (!this.mViewPortHandler().isInBoundsBottom(buffer.buffer[j + 1])) {
                j += 4
                pos++
                continue
            }

            if (!isSingleColor) {
                // Set the color for the currently drawn value. If the index
                // is out of bounds, reuse colors.
                this.mRenderPaint.setColor(Color(dataSet.getColor(j / 4)))
            }
            let left = buffer.buffer[j]
            let top = buffer.buffer[j + 1]
            let right = buffer.buffer[j + 2]
            let bottom = buffer.buffer[j + 3]

            if (isCustomFill) {
                dataSet.getFill(pos).fillRect(
                    c,
                    this.mRenderPaint,
                    left,
                    top,
                    right,
                    bottom,
                    (if (isInverted) {
                        FillDirection.LEFT
                    } else {
                        FillDirection.RIGHT
                    })
                )
            } else {
                Utils.resetContext2DStyle(c, this.mRenderPaint)
                c.beginPath()
                c.rect(left, top, right - left, bottom - top)
                c.fill()
                c.closePath()
            }

            if (drawBorder) {
                Utils.resetContext2DStyle(c, this.mBarBorderPaint)
                c.beginPath()
                c.rect(left, top, right - left, bottom - top)
                c.stroke()
                c.closePath()
            }
            j += 4
            pos++
        }
    }

    func drawValues(c: CanvasRenderingContext2D) {
        if (this.mViewPortHandler.isNone() || this.mAnimator.isNone()) {
            return
        }
        let chartData: ?BarData = this.mChart.getBarData()
        if (chartData.isNone()) {
            return
        }
        if (this.isDrawingValuesAllowed(this.mChart)) {
            let dataSets: ArrayList<IBarDataSet> = chartData().getDataSets()

            let valueOffsetPlus: Float64 = Utils.handleDataValues(5.0)
            var posOffset: Float64 = 0.0
            var negOffset: Float64 = 0.0
            let drawValueAboveBar: Bool = this.mChart.isDrawValueAboveBarEnabled()

            for (i in 0..chartData().getDataSetCount()) {
                let dataSet: IBarDataSet = dataSets[i]

                if (!this.shouldDrawValues(dataSet)) {
                    continue
                }

                let isInverted: Bool = this.mChart.isInverted(dataSet.getAxisDependency())

                // apply the text-styling defined by the DataSet
                this.applyValueTextStyle(dataSet)
                let halfTextHeight: Float64 = Utils.calcTextHeight(c, this.mValuePaint, "10") / 2.0

                let formatter: ?IValueFormatter = dataSet.getValueFormatter()

                // get the buffer
                let buffer: BarBuffer = this.horizontalBarBuffer[i]

                let phaseY: Float64 = this.mAnimator().getPhaseY()

                let iconsOffset: MPPointF = MPPointF.getInstance(dataSet.getIconsOffset())
                iconsOffset.x = Utils.handleDataValues(iconsOffset.x)
                iconsOffset.y = Utils.handleDataValues(iconsOffset.y)

                // if only single values are drawn (sum)
                if (!dataSet.isStacked()) {
                    var j: Int64 = 0
                    while (j < buffer.buffer.size * Int64(this.mAnimator().getPhaseX())) {
                        let y: Float64 = (buffer.buffer[j + 1] + buffer.buffer[j + 3]) / 2.0

                        if (!this.mViewPortHandler().isInBoundsTop(buffer.buffer[j + 1])) {
                            break
                        }

                        if (!this.mViewPortHandler().isInBoundsX(buffer.buffer[j])) {
                            j += 4
                            continue
                        }

                        if (!this.mViewPortHandler().isInBoundsBottom(buffer.buffer[j + 1])) {
                            j += 4
                            continue
                        }

                        let entry: BarEntry = dataSet.getEntryForIndex(j / 4)
                        let val: Float64 = entry.getY()
                        var formattedValue: String = ""

                        if (formatter.isSome()) {
                            formattedValue = formatter().getFormattedValue(val, entry, i, this.mViewPortHandler())
                        }

                        // calculate the correct offset depending on the draw position of the value
                        let valueTextWidth: Float64 = Utils.calcTextWidth(c, this.mValuePaint, formattedValue)
                        posOffset = if (drawValueAboveBar) {
                            valueOffsetPlus
                        } else {
                            -(valueTextWidth + valueOffsetPlus)
                        }
                        negOffset = if (drawValueAboveBar) {
                            -(valueTextWidth + valueOffsetPlus)
                        } else {
                            valueOffsetPlus
                        }
                        -(buffer.buffer[j + 2] - buffer.buffer[j])

                        if (isInverted) {
                            posOffset = -posOffset - valueTextWidth
                            negOffset = -negOffset - valueTextWidth
                        }

                        if (dataSet.isDrawValuesEnabled()) {
                            this.drawHorizontalValue(
                                c,
                                formattedValue,
                                buffer.buffer[j + 2] + if (val >= 0.0) {
                                    posOffset
                                } else {
                                    negOffset
                                },
                                y + halfTextHeight,
                                dataSet.getValueTextColor(j / 2)
                            )
                        }

                        if (entry.getIcon().isSome() && dataSet.isDrawIconsEnabled()) {
                            let icon: ?ChartPixelMap = entry.getIcon()

                            var px: Float64 = buffer.buffer[j + 2] + if (val >= 0.0) {
                                posOffset
                            } else {
                                negOffset
                            }
                            var py: Float64 = y

                            px += iconsOffset.x
                            py += iconsOffset.y

                            if (let Some(i) <- icon) {
                                Utils.drawImage(c, i, floor(px), floor(py))
                            }
                        }
                    }

                // if each value of a potential stack should be drawn
                } else {
                    let trans: ?Transformer = this.mChart.getTransformer(dataSet.getAxisDependency())

                    var bufferIndex = 0
                    var index = 0

                    while (index < dataSet.getEntryCount() * Int64(this.mAnimator().getPhaseX())) {
                        let entry: BarEntry = dataSet.getEntryForIndex(index)

                        let color: UInt32 = dataSet.getValueTextColor(index)
                        let vals: ?Array<Float64> = entry.getYVals()

                        // we still draw stacked bars, but there is one
                        // non-stacked
                        // in between
                        if (vals.isNone()) {
                            if (!this.mViewPortHandler().isInBoundsTop(buffer.buffer[bufferIndex + 1])) {
                                break
                            }

                            if (!this.mViewPortHandler().isInBoundsX(buffer.buffer[bufferIndex])) {
                                continue
                            }

                            if (!this.mViewPortHandler().isInBoundsBottom(buffer.buffer[bufferIndex + 1])) {
                                continue
                            }

                            let val: Float64 = entry.getY()
                            var formattedValue: String = ""
                            if (formatter.isSome()) {
                                formattedValue = formatter().getFormattedValue(val, entry, i, this.mViewPortHandler())
                            }

                            // calculate the correct offset depending on the draw position of the value
                            let valueTextWidth: Float64 = Utils.calcTextWidth(c, this.mValuePaint, formattedValue)
                            posOffset = if (drawValueAboveBar) {
                                valueOffsetPlus
                            } else {
                                -(valueTextWidth + valueOffsetPlus)
                            }
                            negOffset = if (drawValueAboveBar) {
                                -(valueTextWidth + valueOffsetPlus)
                            } else {
                                valueOffsetPlus
                            }

                            if (isInverted) {
                                posOffset = -posOffset - valueTextWidth
                                negOffset = -negOffset - valueTextWidth
                            }

                            if (dataSet.isDrawValuesEnabled()) {
                                this.drawHorizontalValue(c, formattedValue,
                                    buffer.buffer[bufferIndex + 2]
                                    + if (entry.getY() >= 0.0) {
                                    posOffset
                                } else {
                                    negOffset
                                }, buffer.buffer[bufferIndex + 1] + halfTextHeight, color)
                            }

                            if (entry.getIcon().isNone() && dataSet.isDrawIconsEnabled()) {
                                let icon: ?ChartPixelMap = entry.getIcon()

                                var px: Float64 = buffer.buffer[bufferIndex + 2]
                                    + if (entry.getY() >= 0.0) {
                                    posOffset
                                } else {
                                    negOffset
                                }
                                var py: Float64 = buffer.buffer[bufferIndex + 1]

                                px += iconsOffset.x
                                py += iconsOffset.y

                                if (icon.isSome()) {
                                    Utils.drawImage(
                                        c,
                                        icon(),
                                        px,
                                        py
                                    )
                                }
                            }
                        } else {
                            let transformed: Array<Float64> = Array<Float64>(vals().size * 2, item: 0.0)

                            var posY: Float64 = 0.0
                            var negY: Float64 = -entry.getNegativeSum()
                            var m: Int64 = 0
                            var idx: Int64 = 0
                            while (m < transformed.size) {
                                let value: Float64 = vals()[idx]
                                var y: Float64 = 0.0

                                if (value == 0.0 && (posY == 0.0 || negY == 0.0)) {
                                    // Take care of the situation of a 0.0 value, which overlaps a non-zero bar
                                    y = value
                                } else if (value >= 0.0) {
                                    posY += value
                                    y = posY
                                } else {
                                    y = negY
                                    negY -= value
                                }

                                transformed[m] = y * phaseY
                                m += 2
                                idx++
                            }

                            trans?.pointValuesToPixel(transformed)
                            var k: Int64 = 0
                            while (k < transformed.size) {
                                let val: Float64 = vals()[k / 2]
                                var formattedValue: String = ""
                                if (formatter.isSome()) {
                                    formattedValue = formatter().getFormattedValue(val, entry, i,
                                        this.mViewPortHandler())
                                }

                                // calculate the correct offset depending on the draw position of the value
                                let valueTextWidth: Float64 = Utils.calcTextWidth(c, this.mValuePaint, formattedValue)
                                posOffset = if (drawValueAboveBar) {
                                    valueOffsetPlus
                                } else {
                                    -(valueTextWidth + valueOffsetPlus)
                                }
                                negOffset = if (drawValueAboveBar) {
                                    -(valueTextWidth + valueOffsetPlus)
                                } else {
                                    valueOffsetPlus
                                }

                                if (isInverted) {
                                    posOffset = -posOffset - valueTextWidth
                                    negOffset = -negOffset - valueTextWidth
                                }

                                let drawBelow: Bool = (val == 0.0 && negY == 0.0 && posY > 0.0) || val < 0.0

                                let x = transformed[k] + if (drawBelow) {
                                    negOffset
                                } else {
                                    posOffset
                                }
                                let y = (buffer.buffer[bufferIndex + 1] + buffer.buffer[bufferIndex + 3]) / 2.0

                                if (!this.mViewPortHandler().isInBoundsTop(y)) {
                                    break
                                }

                                if (!this.mViewPortHandler().isInBoundsX(x)) {
                                    k += 2
                                    continue
                                }

                                if (!this.mViewPortHandler().isInBoundsBottom(y)) {
                                    k += 2
                                    continue
                                }

                                if (dataSet.isDrawValuesEnabled()) {
                                    this.drawHorizontalValue(c, formattedValue, x, y + halfTextHeight, color)
                                }

                                if (entry.getIcon().isSome() && dataSet.isDrawIconsEnabled()) {
                                    let icon: ?ChartPixelMap = entry.getIcon()
                                    if (let Some(i) <- icon) {
                                        Utils.drawImage(c, i, (x + iconsOffset.x), (y + iconsOffset.y))
                                    }
                                }
                                k += 2
                            }
                        }
                        bufferIndex = if (vals.isNone()) {
                            bufferIndex + 4
                        } else {
                            bufferIndex + 4 * vals().size
                        }
                        index++
                    }
                }
                MPPointF.recycleInstance(iconsOffset)
            }
        }
    }

    func drawHorizontalValue(c: CanvasRenderingContext2D, valueText: String, x: Float64, y: Float64, color: UInt32) {
        this.mValuePaint.setColor(Color(color))
        Utils.resetContext2DStyle(c, this.mValuePaint)
        c.beginPath()
        c.strokeText(valueText, x, y)
        c.closePath()
    }

    public func prepareBarHighlight(x: Float64, y1: Float64, y2: Float64, barWidthHalf: Float64, trans: Transformer): Unit {
        let top = x - barWidthHalf
        let bottom = x + barWidthHalf
        let left = y1
        let right = y2

        this.mBarRect.set(left, top, right, bottom)
        trans.rectToPixelPhaseHorizontal(
            this.mBarRect,
            if (let Some(animator) <- this.mAnimator) {
                animator.getPhaseY()
            } else {
                0.0
            }
        )
    }

    public func setHighlightDrawPos(high: Highlight, bar: MyRect) {
        high.setDraw(bar.centerY(), bar.right)
    }

    public func isDrawingValuesAllowed(chart: BarDataProvider) {
        let chartData: ?BarData = chart.getData()
        if (chartData.isSome() && this.mViewPortHandler.isSome()) {
            return chartData().getEntryCount() < chart.getMaxVisibleCount()
                * Int64(this.mViewPortHandler().getScaleY())
        } else {
            return false
        }
    }
}
