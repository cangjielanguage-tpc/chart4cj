/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package chart.pie

public abstract class ViewPortJob <: Poolable {
    protected var pts: Array<Float64> = Array<Float64>(2, item: 0.0)
    protected var mViewPortHandler: ?ViewPortHandler = Option<ViewPortHandler>.None
    protected var xValue: Float64 = 0.0
    protected var yValue: Float64 = 0.0
    protected var mTrans: ?Transformer = Option<Transformer>.None
    protected var view: ?ChartModel<BarLineScatterCandleBubbleData<IBarLineScatterCandleBubbleDataSet<EntryOhos>, EntryOhos>, IBarLineScatterCandleBubbleDataSet<EntryOhos>, EntryOhos> = None

    public init(viewPortHandler: ?ViewPortHandler, xValue: Float64, yValue: Float64, trans: ?Transformer,
        v: ?ChartModel<BarLineScatterCandleBubbleData<IBarLineScatterCandleBubbleDataSet<EntryOhos>, EntryOhos>, IBarLineScatterCandleBubbleDataSet<EntryOhos>, EntryOhos>) {
        super()
        this.mViewPortHandler = viewPortHandler
        this.xValue = xValue
        this.yValue = yValue
        this.mTrans = trans
        this.view = v
    }

    public func getXValue(): Float64 {
        return this.xValue
    }

    public func getYValue(): Float64 {
        return this.yValue
    }
}
