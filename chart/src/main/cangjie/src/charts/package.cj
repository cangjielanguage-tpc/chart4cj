/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package chart.charts

internal import ohos.ability.Ability
internal import ohos.ability.Want
internal import ohos.ability.LaunchParam
internal import ohos.window.WindowStage

internal import ohos.ability.AbilityStage
internal import ohos.ability.LaunchReason
internal import ohos.prompt_action.*

internal import chart.pie.{PieChartModel,PieData, IPieDataSet, PiEntry,IBarDataSet,BarEntry,
    IBubbleDataSet,BubblesEntry,ICandleDataSet,CandleEntry,IBarLineScatterCandleBubbleDataSet,
    EntryOhos, ILineDataSet,LineData,IScatterDataSet, WaterfallEntry}
internal import chart.bar.{BarChartModel,HorizontalBarChartModel,BarData}
internal import chart.bubble.{BubbleChartModel,BubbleData}
internal import chart.waterfall.{WaterfallChartModel,WaterfallData,IWaterfallDataSet}
internal import chart.line.{LineChartModel}
internal import chart.candle.{CandleStickChartModel,CandleData}
internal import chart.scatter.{ScatterChartModel,ScatterData}
internal import chart.radar.{RadarChartModel,RadarData, IRadarDataSet, RadarEntry}
internal import chart.combine.{CombinedChartModel,CombinedData}

extend<T> Option<T> {
    operator func ()(): T {
        this.getOrThrow()
    }
}
