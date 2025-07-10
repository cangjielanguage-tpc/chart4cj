/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package chart.charts

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.state_macro_manage.*

internal import chart.pie.{PieChartModel,PieData, IPieDataSet, PiEntry,IBarDataSet,BarEntry,
    IBubbleDataSet,BubblesEntry,ICandleDataSet,CandleEntry,IBarLineScatterCandleBubbleDataSet,
    EntryOhos, ILineDataSet,LineData,IScatterDataSet, WaterfallEntry}
internal import chart.bar.{BarChartModel,HorizontalBarChartModel,BarData,EventType,BarCustomUiInfo}
internal import chart.bubble.{BubbleChartModel,BubbleData}
internal import chart.waterfall.{WaterfallChartModel,WaterfallData,IWaterfallDataSet}
internal import chart.line.{LineChartModel,LineCustomUiInfo}
internal import chart.candle.{CandleStickChartModel,CandleData}
internal import chart.scatter.{ScatterChartModel,ScatterData}
internal import chart.radar.{RadarChartModel,RadarData, IRadarDataSet, RadarEntry}
internal import chart.combine.{CombinedChartModel,CombinedData}
internal import chart.utils.*

extend<T> Option<T> {
    operator func ()(): T {
        this.getOrThrow()
    }
}


@Builder func emptyBuilder() {}