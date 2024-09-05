/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package mpchart.combine

public interface CombinedDataProvider <: LineDataProvider & BarDataProvider & BubbleDataProvider & CandleDataProvider & ScatterDataProvider & WaterfallDataProvider {
    func getCombinedData(): ?CombinedData
}
