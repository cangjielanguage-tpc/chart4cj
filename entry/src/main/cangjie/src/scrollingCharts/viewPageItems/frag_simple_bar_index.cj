/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package ohos_app_cangjie_entry.scrollingCharts.viewPageItems

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import chart.pie.*
import chart.utils.*
import chart.components.*
import chart.charts.*
import chart.bar.*
import std.collection.{ArrayList}
import std.random.*

@Entry
@Component
public class fragSimpleBarIndex {
  @State
  var barModel: BarChartModel =  BarChartModel.build()
  var minOffset: Float64 = 15.0

  protected override func aboutToAppear() {
    this.setData(12, 100.0)

    let leftAxis = this.barModel.getAxisLeft()
    if (let Some(leftAxis) <- leftAxis) {
      leftAxis.setLabelCount(7, false)
      leftAxis.setSpaceTop(15.0)
      leftAxis.setAxisMinimum(0.0)
      leftAxis.setAxisMaximum(100.0)
      leftAxis.enableGridDashedLine(10, 10)
    }

    let rightAxis = this.barModel.getAxisRight()
    if (let Some(rightAxis) <- rightAxis) {
      rightAxis.setDrawGridLines(false)
      rightAxis.setLabelCount(7, false)
      rightAxis.setSpaceTop(11.0)
      rightAxis.setAxisMinimum(0.0)
      rightAxis.setAxisMaximum(10.0)
      rightAxis.setDrawAxisLine(false)
      rightAxis.setDrawLabels(false)
    }

    let xAxis = this.barModel.getXAxis()
    if (let Some(xAxis) <- xAxis) {
      xAxis.setLabelCount(5, false)
      xAxis.setAxisMinimum(0.0)
      xAxis.setAxisMaximum(12.0)
    }


    this.barModel.setDrawBarShadow(false)
    this.barModel.setDrawValueAboveBar(true)
    this.barModel.getDescription().setEnabled(false)
    this.barModel.setMaxVisibleValueCount(60)
  }

  func build() {
    Column() {
      Stack(Alignment.TopStart ) {
        BarChart(model: this.barModel)

      }.width(100.percent)
          .height(70.percent)
    }.alignItems(HorizontalAlign.Start)
  }

let VORDIPLOM_COLORS: Array<UInt32> = [UInt32(ChartColor.rgb(192, 255, 140)), UInt32(ChartColor.rgb(255, 247, 140)),
    UInt32(ChartColor.rgb(255, 208, 140)), UInt32(ChartColor.rgb(140, 234, 255)), UInt32(ChartColor.rgb(255, 140, 157))]

  private func setData(count: Int64, range: Float64) {
    let start: Int64 = 1

    let values: ArrayList<BarEntry> = ArrayList<BarEntry>()

    for (i in start..(start + count)) {
      let multi = range
      let val: Float64 = ( Random().nextFloat64() * (multi - 6.0))
      values.append(BarEntry(Float64(i), val))
    }
    let set1: ?BarDataSet

    let barData = this.barModel.getBarData()
    if (barData.isSome() &&
      barData().getDataSetCount() > 0) {
      set1 = barData().getDataSetByIndex(0) as BarDataSet
      set1().setEntries(values)
      barData().notifyDataChanged()
      this.barModel.notifyDataSetChanged()

    } else {
      set1 =  BarDataSet(values, "Company A")
      set1().setColorsByVariable(VORDIPLOM_COLORS)
      set1().setDrawValues(true)

      let dataSets: ArrayList<IBarDataSet> = ArrayList<IBarDataSet>()
      dataSets.append(set1())

      let data: BarData =  BarData(dataSets)

      data.setValueTextSize(10.0)
      this.barModel.setData(data)
      this.barModel.setFitBars(true)
    }
  }
}


extend<T> Option<T> {
    operator func ()(): T {
        this.getOrThrow()
    }
}

