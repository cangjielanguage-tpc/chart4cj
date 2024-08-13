/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package mpchart.candle

public class CandleStickChartRenderer <: LineScatterCandleRadarRenderer {
    public var mChart: CandleDataProvider
    private var mShadowBuffers: Array<Float64> = Array<Float64>(8, item: 0.0)
    private var mBodyBuffers: Array<Float64> = Array<Float64>(4, item: 0.0)
    private var mRangeBuffers: Array<Float64> = Array<Float64>(4, item: 0.0)
    private var mOpenBuffers: Array<Float64> = Array<Float64>(4, item: 0.0)
    private var mCloseBuffers: Array<Float64> = Array<Float64>(4, item: 0.0)

    public init(chart: CandleDataProvider, animator: ChartAnimator, viewPortHandler: ViewPortHandler) {
        super(animator, viewPortHandler)
        this.mChart = chart
    }

    public func initBuffers() {
    }

    public func drawData(c: CanvasRenderingContext2D): Unit {
        let candleData: ?CandleData = this.mChart.getCandleData()
        if (let Some(data) <- candleData) {
            let dataSets = data.getDataSets()

            for (i in 0..dataSets.size) {
                let set: ICandleDataSet = dataSets[i]
                if (set.isVisible()) {
                    this.drawDataSet(c, set)
                }
            }
        }
    }

    protected func drawDataSet(c: CanvasRenderingContext2D, dataSet: ICandleDataSet): Unit {
        let trans: ?Transformer = this.mChart.getTransformer(dataSet.getAxisDependency())

        let phaseY: Float64 = if (let Some(animator) <- this.mAnimator) {
            animator.getPhaseY()
        } else {
            1.0
        }
        let barSpace: Float64 = dataSet.getBarSpace()
        let showCandleBar: Bool = dataSet.getShowCandleBar()

        if (let Some(bounds) <- this.mXBounds) {
            bounds.set(this.mChart, dataSet)

            this.mRenderPaint.setStrokeWidth(dataSet.getShadowWidth())
            for (j in bounds.mins..=bounds.range + bounds.mins) {
                let e: CandleEntry = dataSet.getEntryForIndex(j)
                let xPos: Float64 = e.getX()
                let open: Float64 = e.getOpen()
                let close: Float64 = e.getClose()
                let high: Float64 = e.getHigh()
                let low: Float64 = e.getLow()

                if (showCandleBar) {
                    this.mShadowBuffers[0] = xPos
                    this.mShadowBuffers[2] = xPos
                    this.mShadowBuffers[4] = xPos
                    this.mShadowBuffers[6] = xPos

                    if (open > close) {
                        this.mShadowBuffers[1] = high * phaseY
                        this.mShadowBuffers[3] = open * phaseY
                        this.mShadowBuffers[5] = low * phaseY
                        this.mShadowBuffers[7] = close * phaseY
                    } else if (open < close) {
                        this.mShadowBuffers[1] = high * phaseY
                        this.mShadowBuffers[3] = close * phaseY
                        this.mShadowBuffers[5] = low * phaseY
                        this.mShadowBuffers[7] = open * phaseY
                    } else {
                        this.mShadowBuffers[1] = high * phaseY
                        this.mShadowBuffers[3] = open * phaseY
                        this.mShadowBuffers[5] = low * phaseY
                        this.mShadowBuffers[7] = this.mShadowBuffers[3]
                    }
                    if (let Some(t) <- trans) {
                        t.pointValuesToPixel(this.mShadowBuffers)
                    }

                    if (dataSet.getShadowColorSameAsCandle()) {
                        if (open > close) {
                            this.mRenderPaint.setColor(
                                if (dataSet.getDecreasingColor() == ColorTemplate.COLOR_NONE) {
                                Color(dataSet.getColor(j))
                            } else {
                                Color(dataSet.getDecreasingColor())
                            })
                        } else if (open < close) {
                            this.mRenderPaint.setColor(
                                if (dataSet.getIncreasingColor() == ColorTemplate.COLOR_NONE) {
                                Color(dataSet.getColor(j))
                            } else {
                                Color(dataSet.getIncreasingColor())
                            })
                        } else {
                            this.mRenderPaint.setColor(
                                if (dataSet.getNeutralColor() == ColorTemplate.COLOR_NONE) {
                                Color(dataSet.getColor(j))
                            } else {
                                Color(dataSet.getNeutralColor())
                            })
                        }
                    } else {
                        this.mRenderPaint.setColor(
                            if (dataSet.getShadowColor() == ColorTemplate.COLOR_NONE) {
                            Color(dataSet.getColor(j))
                        } else {
                            Color(dataSet.getShadowColor())
                        })
                    }

                    this.mRenderPaint.setStyle(Style.STROKE)
                    Utils.resetContext2DStyle(c, this.mRenderPaint)
                    c.beginPath()
                    c.moveTo(this.mShadowBuffers[0], this.mShadowBuffers[1])
                    c.lineTo(this.mShadowBuffers[2], this.mShadowBuffers[3])
                    c.moveTo(this.mShadowBuffers[4], this.mShadowBuffers[5])
                    c.lineTo(this.mShadowBuffers[6], this.mShadowBuffers[7])
                    c.stroke()
                    c.closePath()

                    this.mBodyBuffers[0] = xPos - 0.5 + barSpace
                    this.mBodyBuffers[1] = close * phaseY
                    this.mBodyBuffers[2] = (xPos + 0.5 - barSpace)
                    this.mBodyBuffers[3] = open * phaseY

                    if (let Some(t) <- trans) {
                        t.pointValuesToPixel(this.mBodyBuffers)
                    }

                    if (open > close) {
                        if (dataSet.getDecreasingColor() == ColorTemplate.COLOR_NONE) {
                            this.mRenderPaint.setColor(Color(dataSet.getColor(j)))
                        } else {
                            this.mRenderPaint.setColor(Color(dataSet.getDecreasingColor()))
                        }

                        this.mRenderPaint.setStyle(dataSet.getDecreasingPaintStyle())
                        Utils.resetContext2DStyle(c, this.mRenderPaint)
                        let paintStyle = this.mRenderPaint.getStyle()
                        match (paintStyle) {
                            case Style.STROKE => c.strokeRect(this.mBodyBuffers[0], this.mBodyBuffers[3],
                                this.mBodyBuffers[2] - this.mBodyBuffers[0], this.mBodyBuffers[1] - this.mBodyBuffers[3]
                            )

                            case Style.FILL => c.fillRect(this.mBodyBuffers[0], this.mBodyBuffers[3],
                                this.mBodyBuffers[2] - this.mBodyBuffers[0], this.mBodyBuffers[1] - this.mBodyBuffers[3]
                            )
                            case Style.FILL_AND_STROKE => c.fillRect(this.mBodyBuffers[0], this.mBodyBuffers[3],
                                this.mBodyBuffers[2] - this.mBodyBuffers[0], this.mBodyBuffers[1] - this.mBodyBuffers[3]
                            )
                        }
                    } else if (open < close) {
                        if (dataSet.getIncreasingColor() == ColorTemplate.COLOR_NONE) {
                            this.mRenderPaint.setColor(Color(dataSet.getColor(j)))
                        } else {
                            this.mRenderPaint.setColor(Color(dataSet.getIncreasingColor()))
                        }

                        this.mRenderPaint.setStyle(dataSet.getIncreasingPaintStyle())
                        Utils.resetContext2DStyle(c, this.mRenderPaint)
                        let paintStyle = this.mRenderPaint.getStyle()

                        match (paintStyle) {
                            case Style.STROKE => c.strokeRect(this.mBodyBuffers[0], this.mBodyBuffers[1],
                                this.mBodyBuffers[2] - this.mBodyBuffers[0], this.mBodyBuffers[3] - this.mBodyBuffers[1]
                            )

                            case Style.FILL => c.fillRect(this.mBodyBuffers[0], this.mBodyBuffers[1],
                                this.mBodyBuffers[2] - this.mBodyBuffers[0], this.mBodyBuffers[3] - this.mBodyBuffers[1]
                            )
                            case Style.FILL_AND_STROKE => c.fillRect(this.mBodyBuffers[0], this.mBodyBuffers[1],
                                this.mBodyBuffers[2] - this.mBodyBuffers[0], this.mBodyBuffers[3] - this.mBodyBuffers[1]
                            )
                        }
                    } else {
                        if (dataSet.getNeutralColor() == ColorTemplate.COLOR_NONE) {
                            this.mRenderPaint.setColor(Color(dataSet.getColor(j)))
                        } else {
                            this.mRenderPaint.setColor(Color(dataSet.getNeutralColor()))
                        }
                        Utils.resetContext2DStyle(c, this.mRenderPaint)
                        c.moveTo(this.mBodyBuffers[0], this.mBodyBuffers[1])
                        c.lineTo(this.mBodyBuffers[2], this.mBodyBuffers[3])
                        c.stroke()
                    }
                } else {
                    this.mRangeBuffers[0] = xPos
                    this.mRangeBuffers[1] = high * phaseY
                    this.mRangeBuffers[2] = xPos
                    this.mRangeBuffers[3] = low * phaseY

                    this.mOpenBuffers[0] = xPos - 0.5 + barSpace
                    this.mOpenBuffers[1] = open * phaseY
                    this.mOpenBuffers[2] = xPos
                    this.mOpenBuffers[3] = open * phaseY

                    this.mCloseBuffers[0] = xPos + 0.5 - barSpace
                    this.mCloseBuffers[1] = close * phaseY
                    this.mCloseBuffers[2] = xPos
                    this.mCloseBuffers[3] = close * phaseY

                    if (let Some(t) <- trans) {
                        t.pointValuesToPixel(this.mRangeBuffers)
                        t.pointValuesToPixel(this.mOpenBuffers)
                        t.pointValuesToPixel(this.mCloseBuffers)
                    }

                    var barColor: UInt32 = 0

                    if (open > close) {
                        barColor = if (dataSet.getDecreasingColor() == ColorTemplate.COLOR_NONE) {
                            dataSet.getColor(j)
                        } else {
                            dataSet.getDecreasingColor()
                        }
                    } else if (open < close) {
                        barColor = if (dataSet.getIncreasingColor() == ColorTemplate.COLOR_NONE) {
                            dataSet.getColor(j)
                        } else {
                            dataSet.getIncreasingColor()
                        }
                    } else {
                        barColor = if (dataSet.getNeutralColor() == ColorTemplate.COLOR_NONE) {
                            dataSet.getColor(j)
                        } else {
                            dataSet.getNeutralColor()
                        }
                    }

                    this.mRenderPaint.setColor(Color(barColor))
                    Utils.resetContext2DStyle(c, this.mRenderPaint)
                    c.moveTo(this.mRangeBuffers[0], this.mRangeBuffers[1])
                    c.lineTo(this.mRangeBuffers[2], this.mRangeBuffers[3])

                    c.moveTo(this.mOpenBuffers[0], this.mOpenBuffers[1])
                    c.lineTo(this.mOpenBuffers[2], this.mOpenBuffers[3])

                    c.moveTo(this.mCloseBuffers[0], this.mCloseBuffers[1])
                    c.lineTo(this.mCloseBuffers[2], this.mCloseBuffers[3])
                }
            }
        }
    }

    public func drawValues(c: CanvasRenderingContext2D, isHorizontalFlip!: Bool): Unit {
        if (this.isDrawingValuesAllowed(this.mChart)) {
            let chartData: ?CandleData = this.mChart.getCandleData()
            if (let Some(chartData) <- chartData) {
                let dataSets: ArrayList<ICandleDataSet> = chartData.getDataSets()

                for (i in 0..dataSets.size) {
                    let dataSet: ICandleDataSet = dataSets[i]

                    if (!this.shouldDrawValues(dataSet) || dataSet.getEntryCount() < 1) {
                        continue
                    }

                    this.applyValueTextStyle(dataSet)

                    let trans: ?Transformer = this.mChart.getTransformer(dataSet.getAxisDependency())
                    if (let Some(xbounds) <- this.mXBounds) {
                        xbounds.set(this.mChart, dataSet)
                        var positions: Array<Float64> = []
                        if (let Some(trans) <- trans) {
                            positions = trans.generateTransformedValuesCandle(dataSet,
                                if (let Some(animator) <- this.mAnimator) {
                                animator.getPhaseX()
                            } else {
                                1.0
                            }, if (let Some(animator) <- this.mAnimator) {
                                animator.getPhaseY()
                            } else {
                                1.0
                            }, xbounds.mins, xbounds.maxs)
                        }

                        let yOffset: Float64 = Utils.handleDataValues(5.0)

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

                            let entry: CandleEntry = dataSet.getEntryForIndex(j / 2 + xbounds.mins)

                            if (dataSet.isDrawValuesEnabled()) {
                                this.drawValue(
                                    c,
                                    dataSet.getValueFormatter()(),
                                    entry.getHigh(),
                                    entry,
                                    i,
                                    x,
                                    y - yOffset,
                                    Color(dataSet.getValueTextColor(j / 2))
                                )
                            }
                            if (entry.getIcon().isSome() && dataSet.isDrawIconsEnabled()) {
                                let icon: ?ChartPixelMap = entry.getIcon()
                                if (let Some(icon) <- icon) {
                                    Utils.drawImage(
                                        c,
                                        icon,
                                        (x + iconsOffset.x),
                                        (y + iconsOffset.y)
                                    )
                                }
                            }
                        }
                        MPPointF.recycleInstance(iconsOffset)
                    }
                }
            } else {
                return
            }
        }
    }

    public func drawExtras(c: CanvasRenderingContext2D) {
    }

    public func drawHighlighted(c: CanvasRenderingContext2D, indices: Array<Highlight>) {
        let candleData: ?CandleData = this.mChart.getCandleData()
        if (let Some(candleData) <- candleData) {
            for (i in 0..indices.size) {
                let high = indices[i]

                let set: ?ICandleDataSet = candleData.getDataSetByIndex(high.getDataSetIndex())

                if (set.isNone() || !set().isHighlightEnabled()) {
                    continue
                }
                let e: ?CandleEntry = set().getEntryForXValue(high.getX(), high.getY(), rounding: Rounding.CLOSEST)
                if (e.isNone()) {
                    continue
                }

                if (!this.isInBoundsX(e, set())) {
                    continue
                }
                let lowValue: Float64 = e().getLow() * if (let Some(animator) <- this.mAnimator) {
                    animator.getPhaseY()
                } else {
                    1.0
                }
                let highValue: Float64 = e().getHigh() * if (let Some(animator) <- this.mAnimator) {
                    animator.getPhaseY()
                } else {
                    1.0
                }

                let y: Float64 = (lowValue + highValue) / 2.0
                let transformer: ?Transformer = this.mChart.getTransformer(set().getAxisDependency())
                var pix: MPPointD = MPPointD.getInstance(0.0, 0.0)
                if (let Some(transformer) <- transformer) {
                    pix = transformer.getPixelForValues(e().getX(), y)
                }
                high.setDraw((pix.x), (pix.y))
                if (let Some(set: ILineScatterCandleRadarDataSet<EntryOhos>) <- set) {
                    this.drawHighlightLines(c, (pix.x), (pix.y), set)
                }
            }
        } else {
            return
        }
    }
}
