/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.combine

public interface CombinedDataProvider <: LineDataProvider & BarDataProvider & BubbleDataProvider & CandleDataProvider & ScatterDataProvider & WaterfallDataProvider {
    func getCombinedData(): ?CombinedData
}
