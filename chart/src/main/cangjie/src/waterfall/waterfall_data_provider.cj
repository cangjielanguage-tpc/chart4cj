/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.waterfall

public interface WaterfallDataProvider <: BarLineScatterCandleBubbleDataProvider<WaterfallData,IWaterfallDataSet, WaterfallEntry> {
    func getWaterfallData(): ?WaterfallData
    func isDrawBarShadowEnabled(): Bool

    func isDrawValueAboveBarEnabled(): Bool

    func isHighlightFullBarEnabled(): Bool
}
