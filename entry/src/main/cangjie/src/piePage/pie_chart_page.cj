/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package ohos_app_cangjie_entry.piePage

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*

@Entry
@Component
class PieChartPage {

    //标题栏标题
    private var title: String = "PieChart"
    private var model: PieChartModel = PieChartModel.build()
    protected let parties: Array<String> = ["Party A", "Party B", "Party C", "Party D", "Party E", "Party F", "Party G",
    "Party H", "Party I", "Party J", "Party K", "Party L", "Party M", "Party N", "Party O", "Party P", "Party Q",
    "Party R", "Party S", "Party T", "Party U", "Party V", "Party W", "Party X", "Party Y", "Party Z"]

    var pieData: PieData = PieData()

    protected override  func aboutToAppear() {


        let l: ?Legend = this.model.getLegend()
        if (let Some(v) <- l) {
            v.setEnabled(true)
            v.setOrientation(LegendOrientation.VERTICAL)
            v.setVerticalAlignment(LegendVerticalAlignment.BOTTOM)
            v.setHorizontalAlignment(LegendHorizontalAlignment.LEFT)
        }


        this.model.animateX(1000, easing: "Sharp");
        this.model.setUsePercentValues(true);
        this.model.getDescription().setEnabled(false)
        this.model.setExtraOffsets(5.0, 10.0, 5.0, 5.0);

        this.model.setDragDecelerationFrictionCoef(0.95);

        this.model.setCenterText("mpchart");
        this.model.setCenterTextSize(22.0)

        this.model.setDrawHoleEnabled(true);
        this.model.setHoleColor(0xff000000);

        this.model.setTransparentCircleColor(0xff000000);
        this.model.setTransparentCircleAlpha(110.0);

        this.model.setHoleRadius(58.0);
        this.model.setTransparentCircleRadius(61.0);

        this.model.setDrawCenterText(true);

        this.model.setRotationAngle(0.0);
        // enable rotation of the chart by touch
        this.model.setRotationEnabled(true);
        this.model.setHighlightPerTapEnabled(true);

        this.setData(4, 10);
    }
    //初始化饼状图数据
    private func setData(count: Int64, range: Int64): Unit {
        var entries: ArrayList<PiEntry> = ArrayList<PiEntry>()
        for (i in 0..count) {
            entries.append(
                PiEntry((Random().nextFloat64() * Float64 (range)) + Float64 (range) / 5.0, this.parties[i % this.parties.size]))
        }

        var dataSet: PieDataSet = PieDataSet(entries, "Election Results")
        dataSet.setDrawIcons(false)
        dataSet.setSliceSpace(1.0)
        dataSet.setIconsOffset(MPPointF(0.0, 40.0))
        dataSet.setSelectionShift(5.0)
        dataSet.setValueTextColor(UInt32(0XFFFFFF))

        var colors: ArrayList<UInt32> = ArrayList<UInt32>()
        for (i in 0..ColorTemplate.COLORFUL_COLORS.size) {
            colors.append(UInt32(ColorTemplate.COLORFUL_COLORS[i]))
        }

        for (i in 0..ColorTemplate.VORDIPLOM_COLORS.size) {
            colors.append(UInt32(ColorTemplate.VORDIPLOM_COLORS[i]))
        }

        for (i in 0..ColorTemplate.JOYFUL_COLORS.size) {
            colors.append(UInt32(ColorTemplate.JOYFUL_COLORS[i]))
        }

        for (i in 0..ColorTemplate.LIBERTY_COLORS.size) {
            colors.append(UInt32(ColorTemplate.LIBERTY_COLORS[i]))
        }
        for (i in 0..ColorTemplate.PASTEL_COLORS.size) {
            colors.append(UInt32(ColorTemplate.PASTEL_COLORS[i]))
        }
        colors.append(UInt32(ColorTemplate.getHoloBlue()))
        dataSet.setColorsByList(colors)
        let data: PieData = PieData(dataSet)

        this.model.setData(data)
    }


    func build() {
        Column {
            PieChart(model: this.model)
        }.width(100.percent).height(70.percent).backgroundColor(Color.WHITE)

    }
}
