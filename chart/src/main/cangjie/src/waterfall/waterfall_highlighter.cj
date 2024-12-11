/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.waterfall

public class WaterfallHighlighter <: ChartHighlighter<WaterfallDataProvider, WaterfallData, IWaterfallDataSet, WaterfallEntry > {
    public init(chart: WaterfallDataProvider) {
        super(chart);
    }

    public func getHighlight(x: Float64, y: Float64): ?Highlight {
        let high: ?Highlight = super.getHighlight(x, y);

        if (high.isNone()) {
            return None;
        }

        let pos: MPPointD = super.getValsForTouch(x, y);

        let waterfallData: ?WaterfallData = this.mChart.getWaterfallData();
        if (waterfallData.isNone()) {
            return None;
        }

        MPPointD.recycleInstance(pos);

        return high;
    }

    protected func getDistance(x1: Float64, y1: Float64, x2: Float64, y2: Float64): Float64 {
        return abs(x1 - x2);
    }

    protected func getData(): ?WaterfallData {
        return this.mChart.getWaterfallData();
    }
}
