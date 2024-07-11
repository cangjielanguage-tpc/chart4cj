/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package core.bubble

public interface BubbleDataProvider <: BarLineScatterCandleBubbleDataProvider<BubbleData, IBubbleDataSet, BubbleEntry> {
    func getBubbleData(): ?BubbleData
}
