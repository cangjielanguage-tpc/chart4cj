/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package chart.pie

/**
 * Baseclass for all Line, Bar, Scatter, Candle and Bubble data.
 *
 */
public abstract class BarLineScatterCandleBubbleData<S, E> <: ChartData<S, E> where S <: IBarLineScatterCandleBubbleDataSet<E>,
    E <: EntryOhos {
    public init() {
        super()
    }

    public init(sets: Array<S>) {
        super(sets)
    }

    public init(sets: ArrayList<S>) {
        super(sets)
    }
}
