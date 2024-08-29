/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package ohos_app_cangjie_entry.readmeTest

import ohos.state_macro_manage.*
import ohos.base.LengthProp
import ohos.component.Column
import ohos.component.Row
import ohos.component.Button
import ohos.component.Text
import ohos.component.CustomView
import ohos.component.CJEntry
import ohos.component.loadNativeView
import ohos.state_manage.SubscriberManager
import ohos.state_manage.ObservedProperty
import ohos.state_macro_manage.Entry
import ohos.state_macro_manage.Component
import ohos.state_macro_manage.State
import ohos.state_macro_manage.r
import ohos.base.*
import ohos.component.*
import std.collection.{ArrayList}
import std.math.*
import std.random.*
import mpchart.pie.*
import mpchart.utils.*
import mpchart.components.*

@Entry
@Component
class PieChartPageReadme {
    private var model: PieChartModel = PieChartModel.build()
    protected let parties: Array<String> = ["Party A", "Party B", "Party C", "Party D", "Party E", "Party F", "Party G",
    "Party H", "Party I", "Party J", "Party K", "Party L", "Party M", "Party N", "Party O", "Party P", "Party Q",
    "Party R", "Party S", "Party T", "Party U", "Party V", "Party W", "Party X", "Party Y", "Party Z"]

    var pieData: PieData = PieData()

    protected override func aboutToAppear() {
        let l: ?Legend = this.model.getLegend()
        if (let Some(v) <- l) {
            v.setEnabled(true)
            v.setOrientation(LegendOrientation.HORIZONTAL)
            v.setVerticalAlignment(LegendVerticalAlignment.BOTTOM)
            v.setHorizontalAlignment(LegendHorizontalAlignment.RIGHT)
        }

        this.model.animateX(1000, easing: "Sharp") // 启用X轴动画效果，动画持续时间为1000毫秒
        this.model.setUsePercentValues(true) // 使用百分比值
        this.model.getDescription().setEnabled(false) // 禁用描述信息
        this.model.setExtraOffsets(5.0, 10.0, 5.0, 5.0) // 设置额外偏移量

        this.model.setCenterText("mpchart") // 设置中心文本
        this.model.setDrawCenterText(true)
        this.model.setCenterTextSize(20.0) // 设置中心文本大小
        this.model.setCenterTextColor(0xFF3333)

        this.model.setDrawHoleEnabled(true) // 启用绘制中心孔
        this.model.setHoleColor(0xFF00FFFF) // 设置中心孔颜色

        this.model.setTransparentCircleColor(0xff0000FF) // 设置透明圆环颜色
        this.model.setTransparentCircleAlpha(110.0) // 设置透明圆环透明度

        this.model.setHoleRadius(58.0) // 设置中心孔半径
        this.model.setTransparentCircleRadius(61.0) // 设置透明圆环半径

        this.model.setDrawCenterText(true) // 绘制中心文本
        this.model.setEntryLabelColor(0xFF000000)
        this.model.setEntryLabelTextSize(30.0)
        this.model.setRotationAngle(0.0) // 设置旋转角度

        // 通过触摸启用图表的旋转
        this.model.setRotationEnabled(true)

        this.setData(4, 10) // 设置图表数据
    }

    //初始化饼状图数据
    private func setData(count: Int64, range: Int64): Unit {
        var entries: ArrayList<PiEntry> = ArrayList<PiEntry>()
        for (i in 0..count) {
            entries.append(
                PiEntry((Random().nextFloat64() * Float64(range)) + Float64(range) / 5.0,
                this.parties[i % this.parties.size]))
        }

        // 创建饼状图数据集对象，设置数据项和数据集名称
        var dataSet: PieDataSet = PieDataSet(entries, "Election Results")
        // 设置是否绘制数据项图标
        dataSet.setDrawIcons(false)
        // 设置数据项之间的间隙
        dataSet.setSliceSpace(10.0)
        // 设置数据项图标的偏移量
        dataSet.setIconsOffset(MPPointF(0.0, 40.0))
        // 设置选中时数据项的偏移距离
        dataSet.setSelectionShift(5.0)

        // 添加颜色
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

        // 生成图表数据
        let data: PieData = PieData(dataSet)
        // 将数据与图表配置类绑定
        this.model.setData(data)
    }

    func build() {
        Column {
            PieChart(model: this.model)
        }.width(100.percent).height(70.percent).backgroundColor(Color.WHITE)
    }
}
