/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package chart.combine

public interface CombinedDataProvider <: LineDataProvider & BarDataProvider & BubbleDataProvider & CandleDataProvider & ScatterDataProvider & WaterfallDataProvider {
    func getCombinedData(): ?CombinedData
}
