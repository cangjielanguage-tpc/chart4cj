/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.radar

public class YAxisRendererRadarChart <: YAxisRenderer {
    public var mChart: RadarChartModel

    public init(viewPorthandler: ViewPortHandler, yAxis: YAxis, chart: RadarChartModel, trans: ?Transformer) {
        super(viewPorthandler, yAxis, trans)
        this.mChart = chart
    }

    protected func computeAxisValues(mins: Float64, maxs: Float64): Unit {
        if (this.mAxis.isNone()) {
           return;
        }

        let yMin: Float64 = mins
        let yMax: Float64 = maxs

        let labelCount: Int64 = this.mAxis().getLabelCount()
        let range: Float64 = abs(yMax - yMin)

        if (labelCount == 0 || range <= 0.0 || range == Float64.Inf) {
            this.mAxis().mEntries = ArrayList<Float64>()
            this.mAxis().mCenteredEntries = ArrayList<Float64>()
            this.mAxis().mEntryCount = 0.0
            return
        }

        // Find out how much spacing (in y value space) between axis values
        let rawInterval: Float64 = range / Float64(labelCount)
        var interval: Float64 = Utils.roundToNextSignificant(rawInterval)

        // If granularity is enabled, then do not allow the interval to go below specified granularity.
        // This is used to aUnit repeated values when rounding values for display.
        if (this.mAxis().isGranularityEnabled()) {
            interval = if (interval < this.mAxis().getGranularity()) {
                this.mAxis().getGranularity()
            } else {
                interval
            }
        }

        let num = if (interval < 1.0) {
            log10(interval)
        } else {
            0.0
        }
        let intervalMagnitude: Float64 = Utils.roundToNextSignificant(pow(10.0, num))
        let intervalSigDigit = interval / intervalMagnitude
        if (intervalSigDigit > 5.0) {
            // Use one order of magnitude higher, to aUnit intervals like 0.9 or 90
            // if it's 0.0 after floor(), we use the old value
            interval = if (floor(10.0 * intervalMagnitude) == 0.0) {
                interval
            } else {
                floor(10.0 * intervalMagnitude)
            }
        }

        let centeringEnabled: Bool = this.mAxis().isCenterAxisLabelsEnabled()
        var n = if (centeringEnabled) {
            1
        } else {
            0
        }

        // force label count
        if (this.mAxis().isForceLabelsEnabled()) {
            let step: Float64 = range / Float64(labelCount - 1)
            this.mAxis().mEntryCount = Float64(labelCount)

            if (this.mAxis().mEntries.size < labelCount) {
                // Ensure stops contains at least numStops elements.
                this.mAxis().mEntries = ArrayList<Float64>(labelCount)
            }

            var v: Float64 = mins

            for (i in 0..labelCount) {
                this.mAxis().mEntries.replaceOrAppend(i, v)
                v += step
            }

            n = labelCount

        // no forced count
        } else {
            var first: Float64 = if (interval == 0.0) {
                0.0
            } else {
                ceil(yMin / interval) * interval
            }
            if (centeringEnabled) {
                first -= interval
            }

            let last: Float64 = if (interval == 0.0) {
                0.0
            } else {
                Utils.nextUp(floor(yMax / interval) * interval)
            }

            var f: Float64 = first

            if (interval != 0.0) {
                while(f <= last) {
                    n++
                    f += interval
                }
            }

            n++

            this.mAxis().mEntryCount = Float64(n)

            if (this.mAxis().mEntries.size < n) {
                // Ensure stops contains at least numStops elements.
                this.mAxis().mEntries = ArrayList<Float64>(n)
            }
            f = first
            var i: Int64 = 0
            while (i < n) {
                if (f == 0.0) {
                    f = 0.0
                }
                this.mAxis().mEntries.replaceOrAppend(i, f)
                f += interval
                i++
            }
        }

        // set decimals
        if (interval < 1.0) {
            this.mAxis().mDecimals = Int64(ceil(-log10(interval)))
        } else {
            this.mAxis().mDecimals = 0
        }

        if (centeringEnabled) {
            if (this.mAxis().mCenteredEntries.size < n) {
                this.mAxis().mCenteredEntries = ArrayList<Float64>(n)
            }

            let offset: Float64 = (this.mAxis().mEntries[1] - this.mAxis().mEntries[0]) / 2.0

            for (i in 0..n) {
                this.mAxis().mCenteredEntries[i] = this.mAxis().mEntries[i] + offset
            }
        }
        this.mAxis().mAxisMinimum = this.mAxis().mEntries[0]
        this.mAxis().mAxisMaximum = this.mAxis().mEntries[n - 1]
        this.mAxis().mAxisRange = abs(this.mAxis().mAxisMaximum - this.mAxis().mAxisMinimum)
    }

    public func renderAxisLabels(c: CanvasRenderingContext2D) {
        if (!this.mYAxis.isEnabled() || !this.mYAxis.isDrawLabelsEnabled()) {
            return
        }

        this.mAxisLabelPaint.setFontFamily(this.mYAxis.getTypeface())
        this.mAxisLabelPaint.setTextSize(this.mYAxis.getTextSize())
        this.mAxisLabelPaint.setColor(this.mYAxis.getTextColor())

        let center: ?MPPointF = this.mChart.getCenterOffsets()
        var pOut: MPPointF = MPPointF.getInstance(0.0, 0.0)
        let factor: Float64 = this.mChart.getFactor()

        let myFrom: Float64 = if (this.mYAxis.isDrawBottomYLabelEntryEnabled()) {
            0.0
        } else {
            1.0
        }
        let to = if (this.mYAxis.isDrawTopYLabelEntryEnabled()) {
            this.mYAxis.mEntryCount
        } else {
            (this.mYAxis.mEntryCount - 1.0)
        }

        let xOffset = this.mYAxis.getLabelXOffset()

        for (j in Int64(myFrom)..Int64(to)) {
            let r: Float64 = (this.mYAxis.mEntries[j] - this.mYAxis.mAxisMinimum) * factor
            if (let Some(c) <- center) {
                pOut = Utils.getPosition(c, r, this.mChart.getRotationAngle(), pOut)
            }

            let label: String = this.mYAxis.getFormattedLabel(j)

            //c.drawText(label, pOut.x + xOffset, pOut.y, mAxisLabelPaint)
            Utils.resetContext2DStyle(c, this.mAxisLabelPaint)
            c.beginPath()
            c.fillText(label, pOut.x + xOffset, pOut.y)
            c.closePath()
        }
        if (let Some(c) <- center) {
            MPPointF.recycleInstance(c)
        }
        MPPointF.recycleInstance(pOut)
    }

    private var mRenderLimitLinesPathBuffer: String = ""

    public func renderLimitLines(c: CanvasRenderingContext2D) {
        let limitLines: ArrayList<LimitLine> = this.mYAxis.getLimitLines()

        let sliceangle: Float64 = this.mChart.getSliceAngle()

        // calculate the factor that is needed for transforming the value to
        // pixels
        let factor: Float64 = this.mChart.getFactor()

        let center: ?MPPointF = this.mChart.getCenterOffsets()
        var pOut: MPPointF = MPPointF.getInstance(0.0, 0.0)
        for (i in 0..limitLines.size) {
            let l: LimitLine = limitLines[i]

            if (!l.isEnabled()) {
                continue
            }

            this.mLimitLinePaint.setColor(Color(l.getLineColor()))
            if (let Some(l) <- l.getDashPathEffect()) {
                this.mLimitLinePaint.setDashPathEffect(l)
            }

            this.mLimitLinePaint.setStrokeWidth(l.getLineWidth())

            let r: Float64 = (l.getLimit() - this.mChart.getYChartMin()) * factor

            this.mRenderLimitLinesPathBuffer

            let modeData: ?RadarData = this.mChart.getRadarData()
            if (let Some(modeData) <- modeData) {
                let entrySet: ?IRadarDataSet = modeData.getMaxEntryCountSet()
                if (let Some(entrySet) <- entrySet) {
                    for (j in 0..entrySet.getEntryCount()) {
                        if (let Some(c) <- center) {
                            pOut = Utils.getPosition(c, r, sliceangle * Float64(j) + this.mChart.getRotationAngle(),
                                pOut)
                        }
                    }
                }
            }
        }
        if (let Some(c) <- center) {
            MPPointF.recycleInstance(c)
        }
        MPPointF.recycleInstance(pOut)
    }
}
