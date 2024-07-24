/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package mpchart.pie

public class MoveViewJob <: ViewPortJob {
    private static var pool: ObjectPool<MoveViewJob> = ObjectPool(2,
        MoveViewJob(Option<ViewPortHandler>.None, 0.0, 0.0, Option<Transformer>.None, None)).create()

    public static func getInstance(viewPortHandler: ViewPortHandler, xValue: Float64, yValue: Float64,
        trans: Transformer, v: ?ChartModel<ChartData<IDataSet<EntryOhos>, EntryOhos>, IDataSet<EntryOhos>, EntryOhos>): MoveViewJob {
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
        v: ?ChartModel<ChartData<IDataSet<EntryOhos>, EntryOhos>, IDataSet<EntryOhos>, EntryOhos>) {
        super(viewPortHandler, xValue, yValue, trans, v)
    }

    public func run(): Unit {
        this.pts[0] = this.xValue
        this.pts[1] = this.yValue

        if (this.mTrans.isSome()) {
            this.mTrans().pointValuesToPixel(this.pts)
        }
        if (this.mViewPortHandler.isSome() && this.view.isSome()) {
            this.mViewPortHandler().centerViewPort(this.pts, this.view())
        }
        MoveViewJob.recycleInstance(this)
    }

    public func instantiate(): Poolable {
        return MoveViewJob(this.mViewPortHandler, this.xValue, this.yValue, this.mTrans, this.view)
    }
}
