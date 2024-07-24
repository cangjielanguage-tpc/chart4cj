/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package mpchart.waterfall

public interface WaterfallDataProvider <: BarLineScatterCandleBubbleDataProvider<WaterfallData,IWaterfallDataSet, WaterfallEntry> {
    func getWaterfallData(): ?WaterfallData
    func isDrawBarShadowEnabled(): Bool

    func isDrawValueAboveBarEnabled(): Bool

    func isHighlightFullBarEnabled(): Bool
}
