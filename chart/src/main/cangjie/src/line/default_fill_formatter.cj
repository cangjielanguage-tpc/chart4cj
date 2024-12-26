/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.line

public class DefaultFillFormatter <: IFillFormatter {
    public func getFillLinePosition(dataSet: ILineDataSet, dataProvider: LineDataProvider): Float64 {
        var fillMin: Float64 = 0.0
        let chartMaxY: Float64 = dataProvider.getYChartMax()
        let chartMinY: Float64 = dataProvider.getYChartMin()

        if (let Some(data: LineData) <- dataProvider.getLineData()) {
            if (dataSet.getYMax() > 0.0 && dataSet.getYMin() < 0.0) {
                fillMin = 0.0
            } else {
                var max: Float64
                var min: Float64

                if (data.getYMax() > 0.0) {
                    max = 0.0
                } else {
                    max = chartMaxY
                }
                if (data.getYMin() < 0.0) {
                    min = 0.0
                } else {
                    min = chartMinY
                }

                fillMin = if (dataSet.getYMin() >= 0.0) {
                    min
                } else {
                    max
                }
            }
        }

        return fillMin
    }
}
