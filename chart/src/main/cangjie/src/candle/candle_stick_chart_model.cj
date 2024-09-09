/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package chart.candle

public class CandleStickChartModel <: BarLineChartBaseModel<CandleData, ICandleDataSet, CandleEntry> & CandleDataProvider {
    public var context2d: ?CanvasRenderingContext2D = None

    init() {
        super()
        this.mAnimator = ChartAnimator(this)
        if(let Some(animator) <- this.mAnimator) {
            this.mRenderer = CandleStickChartRenderer(this, animator, this.mViewPortHandler)
        }

    }
    public static func build(): CandleStickChartModel {
        let model: CandleStickChartModel = CandleStickChartModel()
        let xAxis: ?XAxis = model.getXAxis()
        if (let Some(xaxis) <- xAxis) {
            xaxis.setSpaceMin(0.5)
            xaxis.setSpaceMax(0.5)
        }
        return model
    }

    public func invalidate(): Unit {
        if (let Some(context2d) <- this.context2d) {
            super.onDraw(context2d)
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

    public func getCandleData(): ?CandleData {
        return this.mData
    }
}
