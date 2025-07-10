/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.line

public abstract class LineScatterCandleRadarRenderer <: BarLineScatterCandleBubbleRenderer {
    public init(animator: ChartAnimator, viewPortHandler: ViewPortHandler) {
        super(animator, viewPortHandler)
    }
}
