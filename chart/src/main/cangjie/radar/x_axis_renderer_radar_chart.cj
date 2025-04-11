/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.radar

public class XAxisRendererRadarChart <: XAxisRenderer {
    public var mChart: RadarChartModel

    public init(viewPortHandler: ViewPortHandler, xAxis: XAxis, chart: RadarChartModel, trans: ?Transformer) {
        super(viewPortHandler, xAxis, trans);
        this.mChart = chart
    }

    public func renderAxisLabels(c: CanvasRenderingContext2D) {
        if (this.mChart.getRadarData().isNone() || !this.mXAxis.isEnabled() || !this.mXAxis.isDrawLabelsEnabled()) {
            return;
        }

        let labelRotationAngleDegrees: Int64 = this.mXAxis.getLabelRotationAngle();
        let drawLabelAnchor: MPPointF = MPPointF.getInstance(0.5, 0.25);

        this.mAxisLabelPaint.setFontFamily(this.mXAxis.getTypeface());
        this.mAxisLabelPaint.setTextSize(this.mXAxis.getTextSize());
        this.mAxisLabelPaint.setColor(this.mXAxis.getTextColor());

        let sliceangle: Float64 = this.mChart.getSliceAngle();

        let factor: Float64 = this.mChart.getFactor();

        let center: ?MPPointF = this.mChart.getCenterOffsets();
        var pOut: MPPointF = MPPointF.getInstance(0.0, 0.0);

        let maxCountEntrySet: ?IRadarDataSet = this.mChart.getRadarData()().getMaxEntryCountSet();
        if (let Some(maxCountEntrySet) <- maxCountEntrySet) {
            for (i in 0..maxCountEntrySet.getEntryCount()) {
                let label: String = this.mXAxis.getValueFormatter()().getFormattedValue(Float64(i), this.mXAxis);
                let angle: Int64 = (Int64(sliceangle) * i + Int64(this.mChart.getRotationAngle())) % 360;
                if (let Some(c) <- center) {
                    pOut = Utils.getPosition(c,
                        this.mChart.getYRange() * factor + Float64(this.mXAxis.mLabelRotatedWidth / 2), Float64(angle),
                        pOut)
                }

                this.drawLabel(c, label, pOut.x, pOut.y - Float64(this.mXAxis.mLabelRotatedHeight) / 2.0,
                    drawLabelAnchor, Float64(labelRotationAngleDegrees));
            }
        }

        if (let Some(c) <- center) {
            MPPointF.recycleInstance(c);
        }
        MPPointF.recycleInstance(pOut);
        MPPointF.recycleInstance(drawLabelAnchor);
    }

    /**
     * XAxis LimitLines on RadarChart not yet supported.
     *
     * @param c
     */
    public func renderLimitLines(c: CanvasRenderingContext2D) {
        // this space intentionally left blank
    }
}
