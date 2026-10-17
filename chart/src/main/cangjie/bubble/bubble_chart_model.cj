/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.bubble

public class BubbleChartModel <: BarLineChartBaseModel<BubbleData, IBubbleDataSet, BubblesEntry> & BubbleDataProvider {
    public var context2d: ?CanvasRenderingContext2D = None
    init() {
        super()
    }

    public static func build(): BubbleChartModel {
        let model: BubbleChartModel = BubbleChartModel()
        model.mAnimator = ChartAnimator(model)
        model.mRenderer = BubbleChartRenderer(model, model.mAnimator(), model.mViewPortHandler)
        model.setHighlighter(BubbleHighlighter(model))
        model.mChartTouchListener = BubbleChartTouchListener(model, model.mViewPortHandler.getMatrixTouch(), 3.0)

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

    public func getBubbleData(): ?BubbleData {
        if (let Some(data: BubbleData) <- this.mData) {
            return data
        } else {
            return None
        }
    }

    public func setHighlighter(highlighter: BubbleHighlighter) {
        this.mHighlighter = highlighter
    }

    public func getBubbleDataSetByTouchPoint(x: Float64, y: Float64): ?IBubbleDataSet {
        let h: ?Highlight = this.getHighlightByTouchPoint(x, y)
        if (h.isSome() && this.mData.isSome()) {
            return this.mData().getDataSetByIndex(h().getDataSetIndex())
        }
        return None
    }

    public func computeScroll(event: GestureEvent): Unit {
        if (let Some(listener: BubbleChartTouchListener) <- this.mChartTouchListener) {
            listener.computeScroll(event)
        }
    }
}
