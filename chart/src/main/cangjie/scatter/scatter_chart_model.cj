/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.scatter

public class ScatterChartModel <: BarLineChartBaseModel<ScatterData, IScatterDataSet, EntryOhos> & ScatterDataProvider {
    public var context2d: ?CanvasRenderingContext2D = None
    init() {
        super()
        this.mAnimator = ChartAnimator(this)
        if (let Some(animator) <- this.mAnimator) {
            this.mRenderer = ScatterChartRenderer(this, animator, this.mViewPortHandler)
        }
        let xAxis: ?XAxis = this.getXAxis()
        if (let Some(xaxis) <- xAxis) {
            xaxis.setSpaceMin(0.5)
            xaxis.setSpaceMax(0.5)
        }
    }
    public static func build(): ScatterChartModel {
        let model: ScatterChartModel = ScatterChartModel()
        model.setHighlighter(ScatterHighlighter(model))
        model.mChartTouchListener = ScatterChartTouchListener(model, model.mViewPortHandler.getMatrixTouch(), 3.0)
        return model
    }

    public func onChartSizeChanged(newWidth: Float64, newHeight: Float64, oldWidth: Float64, oldHeight: Float64) {
        super.onSizeChanged(newWidth, newHeight, oldWidth, oldHeight)
    }

    public func invalidate(): Unit {
        if (let Some(context2d) <- this.context2d) {
            super.onDraw(context2d)
        }
    }

    public func setContext2D(context2d: CanvasRenderingContext2D) {
        this.context2d = context2d
    }

    public func onDraw(c: CanvasRenderingContext2D): Unit {
        super.onDraw(c)
    }

    public func getScatterData(): ?ScatterData {
        return this.mData
    }

    public func setHighlighter(highlighter: ScatterHighlighter) {
        this.mHighlighter = highlighter
    }

    public func getScatterDataSetByTouchPoint(x: Float64, y: Float64): ?IScatterDataSet {
        let h: ?Highlight = this.getHighlightByTouchPoint(x, y)
        if (h.isSome() && this.mData.isSome()) {
            return this.mData().getDataSetByIndex(h().getDataSetIndex())
        }
        return None
    }

    public func computeScroll(event: GestureEvent): Unit {
        if (let Some(listener: ScatterChartTouchListener) <- this.mChartTouchListener) {
            listener.computeScroll(event)
        }
    }
}

/**
 * Predefined ScatterShapes that allow the specification of a shape a ScatterDataSet should be drawn with.
 * If a ScatterShape is specified for a ScatterDataSet, the required renderer is set.
 */
public enum ChartShape {
    | SQUARE //正方形
    | CIRCLE //圆
    | TRIANGLE //三角形
    | CROSS //十字
    | X //x
    | CHEVRON_UP //山峰
    | CHEVRON_DOWN //低洼

    public func toString(): String {
        match (this) {
            case SQUARE => "SQUARE"
            case CIRCLE => "CIRCLE"
            case TRIANGLE => "TRIANGLE"
            case TRIANGLE => "TRIANGLE"
            case CROSS => "CROSS"
            case X => "X"
            case CHEVRON_UP => "CHEVRON_UP"
            case CHEVRON_DOWN => "CHEVRON_DOWN"
        }
    }
}

public class ScatterShape {
    private var shapeIdentifier: ChartShape

    public init(shapeIdentifier: ChartShape) {
        this.shapeIdentifier = shapeIdentifier
    }

    public func toString(): String {
        return this.shapeIdentifier.toString()
    }

    public static func getAllDefaultShapes(): Array<ChartShape> {
        return [ChartShape.SQUARE, ChartShape.CIRCLE, ChartShape.TRIANGLE, ChartShape.CROSS, ChartShape.X,
        ChartShape.CHEVRON_UP, ChartShape.CHEVRON_DOWN]
    }
}
