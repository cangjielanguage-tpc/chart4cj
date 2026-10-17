/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.line

public class LineChartModel <: BarLineChartBaseModel<LineData, ILineDataSet, EntryOhos> & LineDataProvider {
    public var context2d: ?CanvasRenderingContext2D = None

    protected init() {
        super()
    }

    public static func build(): LineChartModel {
        let model: LineChartModel = LineChartModel()
        model.mAnimator = ChartAnimator(model)
        model.mRenderer = LineChartRenderer(model, model.mAnimator(), model.mViewPortHandler)
        model.setHighlighter(LineHighlighter(model))
        model.mChartTouchListener = LineChartTouchListener(model, model.mViewPortHandler.getMatrixTouch(), 3.0)
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

    public func setHighlighter(highlighter: LineHighlighter) {
        this.mHighlighter = highlighter
    }

    public func getLineDataSetByTouchPoint(x: Float64, y: Float64): ?ILineDataSet {
        let h: ?Highlight = this.getHighlightByTouchPoint(x, y)
        if (h.isSome() && this.mData.isSome()) {
            return this.mData().getDataSetByIndex(h().getDataSetIndex())
        }
        return None
    }

    public func computeScroll(event: GestureEvent): Unit {
        if (let Some(listener: LineChartTouchListener) <- this.mChartTouchListener) {
            listener.computeScroll(event)
        }
    }

    public func getLineEntryByTouchPoint(x: Float64, y: Float64): ?EntryOhos {
        let h: ?Highlight = this.getHighlightByTouchPoint(x, y)
        if (h.isSome() && this.mData.isSome()) {
            return this.mData().getEntryForHighlight(h())
        }
        return None
    }

    public func calcPosition(isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>): (Float64, Float64) {
        if (let Some(listener: LineChartTouchListener) <- this.mChartTouchListener) {
            return listener.getXyByEvent(isTouchEvent, touchEvent, gestureEvent)
        }
        return (0.0, 0.0)
    }
}
