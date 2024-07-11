/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package core.waterfall

public class WaterfallChartModel <: BarLineChartBaseModel<WaterfallData, IWaterfallDataSet, WaterfallEntry> & WaterfallDataProvider {
    public var context2d: ?CanvasRenderingContext2D = None
    protected var mHighlightFullBarEnabled: Bool = false
    private var mDrawValueAboveBar: Bool = true
    private var mDrawBarShadow: Bool = false
    private var mFitBars: Bool = false

    init() {
        super()
    }
    public static func build(): WaterfallChartModel {
        let model: WaterfallChartModel = WaterfallChartModel()
        var mAnimator: ChartAnimator = ChartAnimator(model)
        model.mRenderer = WaterfallChartRenderer(model, mAnimator, model.mViewPortHandler)
        return model
    }
    public func getWaterfallData(): ?WaterfallData {
        if (let Some(data: WaterfallData) <- this.mData) {
            return data
        } else {
            return None;
        }
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

    public func isDrawValueAboveBarEnabled(): Bool {
        return this.mDrawValueAboveBar
    }

    public func setDrawBarShadow(enabled: Bool): Unit  {
        this.mDrawBarShadow = enabled;
    }

    public func isDrawBarShadowEnabled(): Bool {
        return this.mDrawBarShadow
    }

    public func isHighlightFullBarEnabled(): Bool {
        return this.mHighlightFullBarEnabled
    }

    public func onDraw(c: CanvasRenderingContext2D): Unit {
        super.onDraw(c)
    }

     public func getHighlightByTouchPoint(x: Float64, y: Float64): ?Highlight {
        if (this.mData.isNone()) {
            AppLog.error("mpchart: Can't select by touch. No data set.")
            return None
        } else {
            let highLighter: ?IHighlighter = this.getHighlighter()
            if (let Some(lighter) <- highLighter) {
                let h: ?Highlight = lighter.getHighlight(x, y)
                if (let Some(hh) <- h) {
                    if (!this.isHighlightFullBarEnabled()) {
                        return None
                    }
                    return Highlight(hh.getX(), y: hh.getY(), dataSetIndex: hh.getDataSetIndex(), dataIndex: 0, stackIndex: -1, xPx: hh.getXPx(), yPx: hh.getYPx(),
                        axis: hh.getAxis())
                } else {
                    return None
                }
            } else {
                return None
            }
        }
    }

    public func getBarBoundsByEntry(e: BarEntry): MyRect {
        let bounds: MyRect = MyRect()
        this.getBarBounds(e, bounds)

        return bounds
    }

    public func getBarBounds(e: BarEntry, outputRect: MyRect): Unit {
        match (this.mData) {
            case Some(data: BarData) =>
                let bounds: MyRect = outputRect

                match (data.getDataSetForEntry(e)) {
                    case Some(set: IBarDataSet) =>
                        let y: Float64 = e.getY()
                        let x: Float64 = e.getX()

                        let barWidth: Float64 = data.getBarWidth()

                        let left: Float64 = x - barWidth / 2.0
                        let right: Float64 = x + barWidth / 2.0
                        let top: Float64 = if (y >= 0.0) {
                            y
                        } else {
                            0.0
                        }
                        let bottom: Float64 = if (y <= 0.0) {
                            y
                        } else {
                            0.0
                        }

                        bounds.set(left, top, right, bottom)

                        let transformer: ?Transformer = this.getTransformer(set.getAxisDependency())
                        if (let Some(t) <- transformer) {
                            t.rectValueToPixel(outputRect)
                        }
                    case None =>
                        bounds.set(Float64.Min, Float64.Min, Float64.Min, Float64.Min)
                        return
                }
            case _ => return
        }
    }

    public func setDrawValueAboveBar(enabled: Bool): Unit {
        this.mDrawValueAboveBar = enabled
    }

    public func setHighlightFullBarEnabled(enabled: Bool): Unit {
        this.mHighlightFullBarEnabled = enabled
    }

   public func highlightValue(x: Float64, dataSetIndex: Int64, stackIndex: Int64): Unit {
        this.highlightValueForObject(
            Highlight(x, y: 0.0, dataSetIndex:dataSetIndex, dataIndex: 0, stackIndex: stackIndex, axis: Option<AxisDependency>.None),
            false
        )
    }

    public func setFitBars(enabled: Bool): Unit {
        this.mFitBars = enabled
    }

    public func groupBars(fromX: Float64, groupSpace: Float64, barSpace: Float64): Unit {
        if (this.getWaterfallData().isNone()) {
            throw Exception("You need to set data for the chart before grouping bars.")
        } else {
            let barData: ?WaterfallData = this.getWaterfallData()
            if (let Some(data) <- barData) {
                data.groupBars(fromX, groupSpace, barSpace)
            }
            this.notifyDataSetChanged()
        }
    }
}
