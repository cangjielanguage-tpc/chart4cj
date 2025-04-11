/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package ohos_app_cangjie_entry.readmeTest

//import ohos.base.*
//import ohos.component.*
//import ohos.state_manage.*
import tpc.UIKit.*
import ohos.state_macro_manage.*
import std.collection.{ArrayList}
import std.math.*
import std.random.*
import chart.pie.*
import chart.utils.*
import chart.bubble.*
import chart.charts.*
import chart.components.*


@Component
public class BubbleChartPageReadme {
    private var model: BubbleChartModel = BubbleChartModel.build()
    var isDrawValuesEnable: Bool = true
    var pageInfo: NavPathStack = NavPathStack()

    protected override func aboutToAppear() {
        let l: ?Legend = this.model.getLegend() //设置图例
        if (let Some(v) <- l) {
            v.setEnabled(true) //设置图例显示
            v.setOrientation(LegendOrientation.HORIZONTAL) // 设置图例方向为水平
            v.setVerticalAlignment(LegendVerticalAlignment.BOTTOM) // 设置图例垂直对齐方式为底部
            v.setHorizontalAlignment(LegendHorizontalAlignment.CENTER) // 设置图例水平对齐方式为居中
            v.setDrawInside(false) // 设置图例绘制在图表外部
        }

        let description: Description = this.model.getDescription() // 获取描述对象
        description.setEnabled(false) // 禁用图表描述

        this.model.setMaxVisibleValueCount(60) // 设置图表最大可见数值数量
        this.model.setDrawGridBackground(false) // 设置不绘制网格背景

        let xAxis: ?XAxis = this.model.getXAxis() // 获取 X 轴对象
        if (let Some(x) <- xAxis) {
            x.setPosition(XAxisPosition.BOTTOM) // 设置X轴位置在底部
            x.setDrawGridLines(false) // 不绘制X轴网格线
            x.setLabelCount(7, false) // 设置X轴标签数量为7
        }

        let leftAxis: ?YAxis = this.model.getAxisLeft() // 获取左侧Y轴对象
        if (let Some(ly) <- leftAxis) {
            ly.setLabelCount(8, false) // 设置左侧 Y 轴标签数量为 8，不强制使用整数标签
            ly.setPosition(YAxisLabelPosition.OUTSIDE_CHART) // 设置左侧 Y 轴标签位置在图表外部
            ly.setSpaceTop(15.0) // 设置左侧 Y 轴顶部空白区域大小
            ly.setAxisMinimum(0.0) // 设置左侧 Y 轴的最小值为 0
        }

        let rightAxis: ?YAxis = this.model.getAxisRight() // 获取右侧Y轴对象
        if (let Some(ry) <- rightAxis) {
            ry.setLabelCount(8, false) // 设置右侧Y轴标签数量为 8
            ry.setDrawGridLines(false) //，不绘制右侧Y轴网格线
            ry.setSpaceTop(15.0) // 设置右侧Y轴顶部空白区域大小
            ry.setAxisMinimum(0.0) // 设置右侧Y轴的最小值为 0
        }

        let start: Int64 = 1
        let values: ArrayList<BubblesEntry> = ArrayList<BubblesEntry>()
        for (i in start..20) {
            let val = (Random().nextFloat64() * 41.0)

            if (Random().nextFloat64() * 100.0 < 25.0) {
                values.append(BubblesEntry(Float64(i), val))
            } else {
                values.append(BubblesEntry(Float64(i), val))
            }
        }
        // 创建散点图数据集
        let dataSet: BubbleDataSet = BubbleDataSet(values, "DataSet")
        dataSet.setDrawIcons(false)

        // 创建散点图数据集合
        let dataSetList: ArrayList<BubbleDataSet> = ArrayList<BubbleDataSet>()
        dataSetList.append(dataSet)

        // 设置图表数据
        this.setData(5, 50.0)
        this.model.notifyDataSetChanged()
        this.model.setVisibleXRangeMaximum(7.0)
    }

    private func setData(count: Int64, range: Float64): Unit {
        // 生成随机数据集合
        let values1 = ArrayList<BubblesEntry>()
        let values2 = ArrayList<BubblesEntry>()
        let values3 = ArrayList<BubblesEntry>()

        for (i in 0..count) {
            values1.append(BubblesEntry(Float64(i), Random().nextFloat64() * range, size: Random().nextFloat64() * range
            ))
            values2.append(BubblesEntry(Float64(i), Random().nextFloat64() * range, size: Random().nextFloat64() * range
            ))
            values3.append(BubblesEntry(Float64(i), Random().nextFloat64() * range, size: Random().nextFloat64() * range
            ))
        }
        // 创建散点图数据集1
        let set1: BubbleDataSet = BubbleDataSet(values1, "DS 1")
        set1.setDrawIcons(false)
        set1.setColorByColor(0x2b89ab)
        set1.setIconsOffset(MPPointF(0.0, 0.0))
        set1.setDrawValues(this.isDrawValuesEnable)

        // 创建散点图数据集2
        let set2: BubbleDataSet = BubbleDataSet(values2, "DS 2")
        set2.setDrawIcons(false)
        set2.setIconsOffset(MPPointF(0.0, 0.0))
        set2.setColorByColor(0xcd4e2e)
        set2.setDrawValues(this.isDrawValuesEnable)

        // 创建散点图数据集3
        let set3: BubbleDataSet = BubbleDataSet(values3, "DS 3")
        set3.setDrawIcons(false)
        set3.setIconsOffset(MPPointF(0.0, 0.0))
        set3.setColorByColor(0xacc045)
        set3.setDrawValues(this.isDrawValuesEnable)

        // 创建散点图数据集合
        let dataSets = ArrayList<IBubbleDataSet>()
        dataSets.append(set1)
        dataSets.append(set2)
        dataSets.append(set3)

        // 创建散点图数据
        let dataResult: BubbleData = BubbleData(dataSets)
        dataResult.setDrawValues(this.isDrawValuesEnable) // 设置显示数据项文本
        dataResult.setValueTextSize(8.0) // 设置数据项文本大小
        dataResult.setValueTextColor(0xffffff) // 设置数据项文本颜色
        dataResult.notifyDataChanged()

        this.model.setData(dataResult)
    }

    func build() {
        NavDestination() {
            Column() {
                // 为组件设置配置构建类，如果需要在页面初始化就显示图表，则需要在 aboutToAppear 方法中完成图表数据构建
                // 如果在之后通过事件触发，
                // 可通过dataResult.notifyDataSetChanged() 来触发数据更新，
                // 可通过this.model.notifyDataSetChanged() 来触发坐标轴数据更新，
                // 可通过this.model.invalidate() 来触发绘制更新。
                BubbleChart(model: this.model)
            }.width(100.percent).height(70.percent).backgroundColor(Color.WHITE)

        }.onReady({
            context => pageInfo = context.pathStack
        }).onBackPressed({
            => false
        })
    }
}
