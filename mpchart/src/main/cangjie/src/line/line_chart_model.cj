/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package mpchart.line

public class LineChartModel <: BarLineChartBaseModel<LineData, ILineDataSet, EntryOhos> & LineDataProvider {
    public var context2d: ?CanvasRenderingContext2D = None

    protected init() {
        super()
    }

    public static func build(): LineChartModel {
        let model: LineChartModel = LineChartModel()
        model.mAnimator = ChartAnimator(model)
        model.mRenderer = LineChartRenderer(model, model.mAnimator(), model.mViewPortHandler)

        return model
    }

    public func invalidate() {
        if (let Some(context2d) <- this.context2d) {
            this.onDraw(context2d)
        }
    }

    public func setContext2D(context2d: CanvasRenderingContext2D) {
        this.context2d = context2d
    }

    public func onChartSizeChanged(newWidth: Float64, newHeight: Float64, oldWidth: Float64, oldHeight: Float64) {
        super.onSizeChanged(newWidth, newHeight, oldWidth, oldHeight)
    }

    public func onDraw(c: CanvasRenderingContext2D): Unit {
        super.onDraw(c)
    }

    public func getLineData(): ?LineData {
        return this.mData
    }
}
