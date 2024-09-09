/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package chart.pie

public interface  IBarLineScatterCandleBubbleDataSet<E> <: IDataSet<E> where E <: EntryOhos {
    public func getHighLightColor(): UInt32
}
