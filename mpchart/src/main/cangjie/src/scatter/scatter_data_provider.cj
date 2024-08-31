/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package mpchart.scatter

public interface ScatterDataProvider <: BarLineScatterCandleBubbleDataProvider<ScatterData, IScatterDataSet, EntryOhos> {
    func getScatterData(): ?ScatterData
}
