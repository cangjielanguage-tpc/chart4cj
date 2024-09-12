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
import std.collection.{ArrayList}
import std.random.*

@Entry
@Component
public class fragmentSimplePieIndex {
    var pieData: PieData = PieData()
    @State
    var pieModel: PieChartModel = PieChartModel.build()
    var parties: Array<String> = ["Party A", "Party B", "Party C", "Party D", "Party E", "Party F", "Party G",
    "Party H", "Party I", "Party J", "Party K", "Party L", "Party M", "Party N", "Party O", "Party P", "Party Q",
    "Party R", "Party S", "Party T", "Party U", "Party V", "Party W", "Party X", "Party Y", "Party Z"]

    protected override func aboutToAppear() {
        this.pieData = this.initPieData(4, 10.0)
        this.pieModel.setData(this.pieData)

        let l: ?Legend = this.pieModel.getLegend()
        if (let Some(l) <- l) {
            l.setOrientation(LegendOrientation.VERTICAL)
            l.setVerticalAlignment(LegendVerticalAlignment.TOP)
            l.setHorizontalAlignment(LegendHorizontalAlignment.RIGHT)
            l.setYEntrySpace(10.0)
            l.setFormToTextSpace(20.0)
        }
    }

    // 初始化饼状图数据
    private func initPieData(count: Int64, range: Float64): PieData {
        let entries = ArrayList<PiEntry>()
        for (i in 0..count) {
            entries.append(PiEntry(((Random().nextFloat64() * range) + range / 5.0), this.parties[i % this.parties.size]
            ))
        }

        let dataSet: PieDataSet = PieDataSet(entries, "Election Results")
        dataSet.setDrawIcons(false)
        dataSet.setSliceSpace(1.0)
        dataSet.setIconsOffset(MPPointF(0.0, 40.0))
        dataSet.setSelectionShift(5.0)

        // add a lot of colors
        let colors: ArrayList<Int64> = ArrayList()
        for (index in 0..ColorTemplate.VORDIPLOM_COLORS.size) {
            colors.append(ColorTemplate.VORDIPLOM_COLORS[index])
        }

        for (index in 0..ColorTemplate.JOYFUL_COLORS.size) {
            colors.append(ColorTemplate.JOYFUL_COLORS[index])
        }

        for (index in 0..ColorTemplate.COLORFUL_COLORS.size) {
            colors.append(ColorTemplate.COLORFUL_COLORS[index])
        }
        for (index in 0..ColorTemplate.LIBERTY_COLORS.size) {
            colors.append(ColorTemplate.LIBERTY_COLORS[index])
        }
        for (index in 0..ColorTemplate.PASTEL_COLORS.size) {
            colors.append(ColorTemplate.PASTEL_COLORS[index])
        }
        colors.append(ColorTemplate.getHoloBlue())
        let colorss: ArrayList<UInt32> = ArrayList()
        for (color in colors) {
            colorss.append(UInt32(color))
        }
        dataSet.setColorsByList(colorss)
        return PieData(dataSet)
    }

    func build() {
        Column() {
            PieChart(model: this.pieModel)
        }.width(100.percent).height(80.percent)
    }
}
