/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.pie

public class MoveViewJob <: Poolable {
    protected var pts: Array<Float64> = Array<Float64>(2, repeat: 0.0)
    protected var mViewPortHandler: ?ViewPortHandler = Option<ViewPortHandler>.None
    protected var xValue: Float64 = 0.0
    protected var yValue: Float64 = 0.0
    protected var mTrans: ?Transformer = Option<Transformer>.None
    protected var view: Any

    private static var pool: ObjectPool<MoveViewJob> = ObjectPool(2,
        MoveViewJob(Option<ViewPortHandler>.None, 0.0, 0.0, Option<Transformer>.None, Option<Any>.None)).create()

    public static func getInstance(viewPortHandler: ViewPortHandler, xValue: Float64, yValue: Float64,
        trans: Transformer, v: Any): MoveViewJob  {
        let result: MoveViewJob = MoveViewJob.pool.get()
        result.mViewPortHandler = viewPortHandler
        result.xValue = xValue
        result.yValue = yValue
        result.mTrans = trans
        result.view = v
        return result
    }

    public static func recycleInstance(instance: MoveViewJob): Unit {
        MoveViewJob.pool.recycle(instance)
    }

    public init(viewPortHandler: ?ViewPortHandler, xValue: Float64, yValue: Float64, trans: ?Transformer,
        v: ?Any) {
        this.mViewPortHandler = viewPortHandler
        this.xValue = xValue
        this.yValue = yValue
        this.mTrans = trans
        this.view = v
    }

    public func run<D,S,E>(): Unit where D <: ChartData<S, E>, S <: IDataSet<E>, E <: EntryOhos  {
        this.pts[0] = this.xValue
        this.pts[1] = this.yValue

        if (this.mTrans.isSome()) {
            this.mTrans().pointValuesToPixel(this.pts)
        }
        if (this.mViewPortHandler.isSome()) {
            this.mViewPortHandler().centerViewPort(this.pts, (this.view as ChartModel<D, S, E>)())
        }
        MoveViewJob.recycleInstance(this)
    }

    public func instantiate(): Poolable {
        return MoveViewJob(this.mViewPortHandler, this.xValue, this.yValue, this.mTrans, this.view)
    }
    public func getXValue(): Float64 {
        return this.xValue
    }

    public func getYValue(): Float64 {
        return this.yValue
    }
}
