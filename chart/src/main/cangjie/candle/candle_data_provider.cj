/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.candle

public interface CandleDataProvider <: BarLineScatterCandleBubbleDataProvider<CandleData, ICandleDataSet, CandleEntry> {
  func getCandleData(): ?CandleData
}