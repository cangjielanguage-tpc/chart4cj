/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package mpchart.line

public abstract class LineScatterCandleRadarRenderer <: BarLineScatterCandleBubbleRenderer {
    public init(animator: ChartAnimator, viewPortHandler: ViewPortHandler) {
        super(animator, viewPortHandler)
    }

    protected func drawHighlightLines(c: CanvasRenderingContext2D, x: Float64, y: Float64,
        set: ILineScatterCandleRadarDataSet<EntryOhos>): Unit {
        let highLightColor = set.getHighLightColor()
        this.mHighlightPaint.setColor(Color(highLightColor))

        this.mHighlightPaint.setStrokeWidth(set.getHighlightLineWidth())
        this.mHighlightPaint.setDashPathEffect(set.getDashPathEffectHighlight())
        Utils.resetContext2DStyle(c, this.mHighlightPaint)
        if (set.isVerticalHighlightIndicatorEnabled()) {
            c.beginPath()

            c.moveTo(x, if (let Some(handle) <- this.mViewPortHandler) {
                handle.contentTop()
            } else {
                0.0
            })
            c.lineTo(x, if (let Some(handle) <- this.mViewPortHandler) {
                handle.contentBottom()
            } else {
                0.0
            })
            c.stroke()
            c.closePath()
        }

        // draw horizontal highlight lines
        if (set.isHorizontalHighlightIndicatorEnabled()) {
            c.beginPath()

            c.moveTo(
                if (let Some(handle) <- this.mViewPortHandler) {
                    handle.contentLeft()
                } else {
                    0.0
                },
                y
            )
            c.lineTo(
                if (let Some(handle) <- this.mViewPortHandler) {
                    handle.contentRight()
                } else {
                    0.0
                },
                y
            )

            c.stroke()
            c.closePath()
        }
    }
}
