/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.scatter

public interface ScatterDataProvider <: BarLineScatterCandleBubbleDataProvider<ScatterData, IScatterDataSet, EntryOhos> {
    func getScatterData(): ?ScatterData
}
