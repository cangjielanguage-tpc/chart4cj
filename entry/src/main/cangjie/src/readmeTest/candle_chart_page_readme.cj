/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package ohos_app_cangjie_entry.readmeTest

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import std.collection.{ArrayList}
import std.math.*
import std.random.*
import chart.pie.*
import chart.utils.*
import chart.candle.*
import chart.charts.*
import chart.components.*

@Entry
@Component
class CandleChartPageReadme {
    private var model: CandleStickChartModel = CandleStickChartModel.build()

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
        description.setEnabled(true) // 禁用图表描述

        this.model.setMaxVisibleValueCount(60) // 设置图表最大可见数值数量
        this.model.setDrawGridBackground(true) // 设置绘制网格背景
        this.model.setGridBackgroundColor(0xffffff) // 设置绘制网格背景颜色

        let xAxis: ?XAxis = this.model.getXAxis() // 获取 X 轴对象
        if (let Some(x) <- xAxis) {
            x.setPosition(XAxisPosition.BOTTOM) // 设置X轴位置在底部
            x.setDrawGridLines(true) // 绘制 X 轴网格线
        }

        let leftAxis: ?YAxis = this.model.getAxisLeft() // 获取左侧Y轴对象
        if (let Some(ly) <- leftAxis) {
            ly.setLabelCount(7, false) // 设置左侧 Y 轴标签数量为 7，不强制使用整数标签
            ly.setDrawGridLines(true) // 绘制左侧 Y 轴网格线
            ly.setDrawAxisLine(true) // 绘制左侧 Y 轴线
        }

        let rightAxis: ?YAxis = this.model.getAxisRight() // 获取右侧Y轴对象
        if (let Some(ry) <- rightAxis) {
            ry.setLabelCount(7, false) // 设置右侧 Y 轴标签数量为 7，不强制使用整数标签
            ry.setDrawGridLines(true) // 绘制右侧 Y 轴网格线
            ry.setDrawAxisLine(true) // 绘制右侧 Y 轴线
        }

        this.setData(40, 100.0)
        this.model.notifyDataSetChanged()
    }

    private func setData(count: Int64, range: Float64): Unit {
        // 生成随机数据集合
        let values = ArrayList<CandleEntry>()

        for (i in 0..count) {
            let val: Float64 = (Random().nextFloat64() * 40.0) + (range + 3.0)

            let high: Float64 = (Random().nextFloat64() * 9.0) + 8.0
            let low: Float64 = (Random().nextFloat64() * 9.0) + 8.0

            let open: Float64 = (Random().nextFloat64() * 6.0) + 1.0
            let close: Float64 = (Random().nextFloat64() * 6.0) + 1.0

            let even: Bool = i % 2 == 0

            values.append(
                CandleEntry(
                    Float64(i),
                    shadowH: val + high,
                    shadowL: val - low,
                    open: if (even) {
                        val + open
                    } else {
                        val - open
                    },
                    close: if (even) {
                        val - close
                    } else {
                        val + close
                    },
                )
            )
        }
        // 创建蜡烛图数据集，并设置数据集的名称为 "candle data set"
        let dataSet: CandleDataSet = CandleDataSet(values, "candle data set")
        dataSet.setDrawIcons(false) // 设置是否绘制图标为 false
        dataSet.setAxisDependency(AxisDependency.LEFT) // 设置数据集的轴依赖为左侧Y轴
        dataSet.setShadowColor(0x808080) // 设置蜡烛图阴影颜色
        dataSet.setShadowWidth(0.7) // 设置蜡烛图阴影宽度为 0.7
        dataSet.setDecreasingPaintStyle(Style.FILL) // 设置蜡烛图下跌蜡烛的绘制样式为填充
        dataSet.setDecreasingColor(0x2b89ab) // 设置蜡烛图下跌蜡烛的颜色
        dataSet.setIncreasingColor(0xcd4e2e) // 设置蜡烛图上涨蜡烛的颜色
        dataSet.setIncreasingPaintStyle(Style.STROKE) // 设置蜡烛图上涨蜡烛的绘制样式为描边
        dataSet.setNeutralColor(0x0000ff) // 设置蜡烛图中性蜡烛的颜色

        // 创建蜡烛图数据
        let data: CandleData = CandleData([dataSet])
        data.setValueTextSize(7.0)

        this.model.setData(data)
        this.model.invalidate()
    }

    func build() {
        Column() {
            CandleStickChart(model: this.model)
        }.width(100.percent).height(70.percent).backgroundColor(Color.WHITE)

    }
}
