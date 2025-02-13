/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.pie

/**
 * Baseclass of all axis renderers.
 */
public abstract class AxisRenderer <: Renderer {
    /** base axis this axis renderer works with */
    protected var mAxis: ?AxisBase = None
    /** transformer to transform values to screen pixels and return */
    protected var mTrans: ?Transformer = None
    /**
     * paint object for the grid lines
     */
    protected var mGridPaint: ChartPaint = ChartPaint()
    /**
     * paint for the x-label values
     */
    protected var mAxisLabelPaint: ChartPaint = ChartPaint()
    /**
     * paint for the line surrounding the chart
     */
    protected var mAxisLinePaint: ChartPaint = ChartPaint()
    /**
     * paint used for the limit lines
     */
    protected var mLimitLinePaint: ChartPaint = ChartPaint()

    public init(viewPortHandler: ViewPortHandler, axis: AxisBase, trans: ?Transformer) {
        super(viewPortHandler)
        this.mTrans = trans
        this.mAxis = axis

        if (this.mViewPortHandler.isSome()) {
            this.mAxisLabelPaint = ChartPaint()

            this.mGridPaint = ChartPaint()
            this.mGridPaint.setColor(Color.GRAY)
            this.mGridPaint.setStrokeWidth(1.0)
            this.mGridPaint.setStyle(Style.STROKE)
            this.mGridPaint.setGlobalAlpha(90.0 / 255.0)

            this.mAxisLinePaint = ChartPaint()
            this.mAxisLinePaint.setColor(Color.BLACK)
            this.mAxisLinePaint.setStrokeWidth(1.0)
            this.mAxisLinePaint.setStyle(Style.STROKE)

            this.mLimitLinePaint = ChartPaint()
            this.mLimitLinePaint.setStyle(Style.STROKE)
        }
    }

    /**
     * Returns the ChartPaint object used for drawing the axis (labels).
     *
     * @return
     */
    public func getPaintAxisLabels(): ChartPaint {
        return this.mAxisLabelPaint
    }

    /**
     * Returns the ChartPaint object that is used for drawing the grid-lines of the
     * axis.
     *
     * @return
     */
    public func getPaintGrid(): ChartPaint {
        return this.mGridPaint
    }

    /**
     * Returns the ChartPaint object that is used for drawing the axis-line that goes
     * alongside the axis.
     *
     * @return
     */
    public func getPaintAxisLine(): ChartPaint {
        return this.mAxisLinePaint
    }

    /**
     * Returns the Transformer object used for transforming the axis values.
     *
     * @return
     */
    public func getTransformer(): ?Transformer {
        return this.mTrans
    }

    /**
     * Computes the axis values.
     *
     * @param min - the minimum value in the data object for this axis
     * @param max - the maximum value in the data object for this axis
     */
    public open func computeAxis(min: Float64, max: Float64, inverted: Bool) {
        var mins: Float64 = min
        var maxs: Float64 = max
        // calculate the starting and entry point of the y-labels (depending on
        // zoom / contentrect bounds)
        if (let Some(mTran) <- this.mTrans) {
            if (let Some(v) <- this.mViewPortHandler) {
                if (v.contentWidth() > 10.0 && !v.isFullyZoomedOutY()) {
                    let p1: MPPointD = mTran.getValuesByTouchPoint(
                        v.contentLeft(),
                        v.contentTop(),
                        Option<MPPointD>.None
                    )
                    let p2: MPPointD = mTran.getValuesByTouchPoint(
                        v.contentLeft(),
                        v.contentBottom(),
                        Option<MPPointD>.None
                    )

                    if (!inverted) {
                        mins = p2.y
                        maxs = p1.y
                    } else {
                        mins = p1.y
                        maxs = p2.y
                    }

                    MPPointD.recycleInstance(p1)
                    MPPointD.recycleInstance(p2)
                }
            }
        }
        this.computeAxisValues(mins, maxs)
    }

    /**
     * Sets up the axis values. Computes the desired number of labels between the two given extremes.
     *
     * @return
     */
    protected open func computeAxisValues(min: Float64, max: Float64) {
        let yMin = min
        let yMax = max
        if (let Some(mAxis) <- this.mAxis) {
            let labelCount: Int64 = mAxis.getLabelCount()
            let range: Float64 = abs(yMax - yMin)

            if (labelCount == 0 || range <= 0.0 || range == Float64.Inf) {
                mAxis.mEntries = ArrayList<Float64>()
                mAxis.mCenteredEntries = ArrayList<Float64>()
                mAxis.mEntryCount = 0.0
                return
            }

            // Find out how much spacing (in y value space) between axis values
            let rawInterval: Float64 = range / Float64(labelCount)
            var interval: Float64 = Utils.roundToNextSignificant(rawInterval)
            // If granularity is enabled, then do not allow the interval to go below specified granularity.
            // This is used to avoid repeated values when rounding values for display.
            if (mAxis.isGranularityEnabled()) {
                interval = if (interval < mAxis.getGranularity()) {
                    mAxis.getGranularity()
                } else {
                    interval
                }
            }
            // Normalize interval
            let intervalMagnitude: Float64 = Utils.roundToNextSignificant(
                pow(
                    10.0,
                    floor(if (interval == 0.0) {
                        0.0
                    } else {
                        log10(interval)
                    })
                )
            )

            let intervalSigDigit: Float64 = floor((interval / intervalMagnitude))
            if (intervalSigDigit > 5.0) {
                // Use one order of magnitude higher, to avoid intervals like 0.9 or 90
                // if it's 0.0 after floor(), we use the old value
                interval = if (floor(10.0 * intervalMagnitude) == 0.0) {
                    interval
                } else {
                    floor(10.0 * intervalMagnitude)
                }
            }

            var n = if (mAxis.isCenterAxisLabelsEnabled()) {
                1
            } else {
                0
            }

            // force label count
            if (mAxis.isForceLabelsEnabled()) {
                interval = range / Float64(labelCount - 1)
                xaxisIsForceLablesEnabled(labelCount, yMin, interval)
                n = labelCount

            // no forced count
            } else {
                (interval, n) = xaxisIsForceLablesDesnabled(interval, yMin, yMax, n)
            }

            // set decimals
            if (interval < 1.0) {
                mAxis.mDecimals = Int64(floor(ceil(-log10(interval))))
            } else {
                mAxis.mDecimals = 0
            }
            if (mAxis.isCenterAxisLabelsEnabled()) {
                if (mAxis.mCenteredEntries.size < n) {
                    mAxis.mCenteredEntries = ArrayList<Float64>(n)
                }

                let offset: Float64 = interval / 2.0
                for (i in 0..n) {
                    mAxis.mCenteredEntries.replaceOrAppend(i, mAxis.mEntries[i] + offset)
                }
            }
        }
    }

    private func xaxisIsForceLablesEnabled(labelCount: Int64, min: Float64, interval: Float64): Unit {
        if (let Some(mAxis) <- this.mAxis) {
            mAxis.mEntryCount = Float64(labelCount)

            if (mAxis.mEntries.size < labelCount) {
                // Ensure stops contains at least numStops elements.
                mAxis.mEntries = ArrayList<Float64>(labelCount)
            }

            var v = min

            for (i in 0..labelCount) {
                mAxis.mEntries.replaceOrAppend(i, v)
                v += interval
            }
        }
    }

    private func xaxisIsForceLablesDesnabled(interval: Float64, yMin: Float64, yMax: Float64, nn: Int64): (Float64, 
        Int64) {
        if (let Some(mAxis) <- this.mAxis) {
            var n: Int64 = nn
            var first: Float64 = if (interval == 0.0) {
                0.0
            } else {
                ceil(yMin / interval) * interval
            }
            if (mAxis.isCenterAxisLabelsEnabled()) {
                first -= interval
            }

            let last: Float64 = if (interval == 0.0) {
                0.0
            } else {
                Utils.nextUp(floor(yMax / interval) * interval)
            }

            var f: Float64 = 0.0
            var i: Int64 = 0

            if (interval != 0.0 && last != first) {
                f = first
                while (f <= last) {
                    n++
                    f += interval
                }
            } else if (last == first && n == 0) {
                n = 1
            }

            mAxis.mEntryCount = Float64(n)
            if (mAxis.mEntries.size < n) {
                // Ensure stops contains at least numStops elements.
                mAxis.mEntries = ArrayList<Float64>(n)
            }
            f = first
            i = 0
            while (i < n) {
                if (f == 0.0) {
                    f = 0.0
                } // Fix for negative zero case (Where value == -0.0, and 0.0 == -0.0)

                mAxis.mEntries.replaceOrAppend(i, f)
                f += interval
                i++
            }
            return (interval, n)
        }
        return (0.0, 0)
    }

    /**
     * Draws the axis labels to the screen.
     *
     * @param c
     */
    public open func renderAxisLabels(c: CanvasRenderingContext2D): Unit

    /**
     * Draws the grid lines belonging to the axis.
     *
     * @param c
     */
    public open func renderGridLines(c: CanvasRenderingContext2D): Unit

    /**
     * Draws the line that goes alongside the axis.
     *
     * @param c
     */
    public open func renderAxisLine(c: CanvasRenderingContext2D, extraLine!: Float64): Unit

    /**
     * Draws the LimitLines associated with this axis to the screen.
     *
     * @param c
     */
    public open func renderLimitLines(c: CanvasRenderingContext2D): Unit
}
