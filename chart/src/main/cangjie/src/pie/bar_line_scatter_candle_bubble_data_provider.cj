/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.pie

public interface BarLineScatterCandleBubbleDataProvider<D, S, E> <: ChartInterface<D, S, E> where D <: ChartData<S, E>, S <: IDataSet<E>, E <: EntryOhos {
    func getTransformer(axis: AxisDependency): ?Transformer

    func isInverted(axis: AxisDependency): Bool

    func getLowestVisibleX(): Float64

    func getHighestVisibleX(): Float64

    func getData(): Any
}
