/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
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
import chart.charts.*
import chart.components.*
import chart.scatter.*

@Entry
@Component
class ScatterChartPageReadme {
    private var model: ScatterChartModel = ScatterChartModel.build()

    protected override func aboutToAppear() {
        let l: ?Legend = this.model.getLegend()
        if (let Some(legend) <- l) {
            legend.setEnabled(true) // 启用图例
            legend.setOrientation(LegendOrientation.HORIZONTAL)
            legend.setVerticalAlignment(LegendVerticalAlignment.BOTTOM)
            legend.setHorizontalAlignment(LegendHorizontalAlignment.CENTER)
            legend.setDrawInside(false) // 设置图例绘制在图表外部
        }

        let description: Description = this.model.getDescription() // 获取描述对象
        description.setEnabled(true)

        // 设置图表最大可见数值数量、是否支持缩放、是否绘制网格背景
        this.model.setMaxVisibleValueCount(160)
        this.model.setDrawGridBackground(false)
        this.model.animateXY(2000, 2000)

        let xAxis: ?XAxis = this.model.getXAxis() // 获取X轴对象
        if (let Some(xAxis) <- xAxis) {
            xAxis.setPosition(XAxisPosition.BOTTOM) // 设置X轴位置在底部
            xAxis.setDrawGridLines(false) // 不绘制X轴网格线
            xAxis.setLabelCount(7, false) // 设置X轴标签数量为7
        }

        let leftAxis: ?YAxis = this.model.getAxisLeft() // 获取左侧Y轴对象
        if (let Some(leftAxis) <- leftAxis) {
            leftAxis.setLabelCount(8, false) // 设置左侧Y轴标签数量为8，不强制使用整数标签
            leftAxis.setPosition(YAxisLabelPosition.OUTSIDE_CHART) // 设置左侧Y轴标签位置在图表外部
            leftAxis.setSpaceTop(15.0) // 设置左侧Y轴顶部空白区域大小
            leftAxis.setAxisMinimum(0.0) // 设置左侧Y轴的最小值为0
        }

        let rightAxis: ?YAxis = this.model.getAxisRight() // 获取右侧Y轴对象
        if (let Some(rightAxis) <- rightAxis) {
            rightAxis.setLabelCount(8, false) // 设置右侧Y轴标签数量为8
            rightAxis.setDrawGridLines(false) //不绘制右侧Y轴网格线
            rightAxis.setSpaceTop(15.0) // 设置右侧Y轴顶部空白区域大小
            rightAxis.setAxisMinimum(0.0) // 设置右侧Y轴的最小值为0
        }

        this.setData(20.0, 100.0)
        this.model.notifyDataSetChanged()
    }

    private func setData(xRange: Float64, yRange: Float64): Unit {
        // 生成随机数据集合
        let values1 = this.generateRandomData(xRange, yRange)
        let values2 = this.generateRandomData(xRange, yRange)
        let values3 = this.generateRandomData(xRange, yRange)

        // 创建散点图数据集1
        let set1 = ScatterDataSet(values1, "DS 1")
        set1.setScatterShape(ChartShape.SQUARE)
        set1.setColorByColor(0x2b89ab)

        // 创建散点图数据集2
        let set2 = ScatterDataSet(values2, "DS 2")
        set2.setScatterShape(ChartShape.CIRCLE)
        set2.setScatterShapeHoleRadius(3.0)
        set2.setColorByColor(0xcd4e2e)

        // 创建散点图数据集3
        let set3 = ScatterDataSet(values3, "DS 3")
        set3.setShapeRenderer(CustomScatterShapeRenderer())
        set3.setColorByColor(0xacc045)

        // 设置散点图数据集形状大小
        set1.setScatterShapeSize(8.0)
        set2.setScatterShapeSize(8.0)
        set3.setScatterShapeSize(8.0)

        // 创建散点图数据集合
        let dataSets: ArrayList<IScatterDataSet> = ArrayList<IScatterDataSet>()
        dataSets.append(set1) // add the data sets
        dataSets.append(set2)
        dataSets.append(set3)

        // 创建散点图数据
        let dataResult: ScatterData = ScatterData(dataSets)
        dataResult.setDrawValues(true)
        dataResult.setValueTextSize(8.0) // 设置数据项文本大小
        dataResult.setHighlightEnabled(true)
        dataResult.setValueTextSize(10.0)

        this.model.setData(dataResult) // 设置图表数据
        dataResult.notifyDataChanged()
    }

    private func generateRandomData(xRange: Float64, yRange: Float64): ArrayList<EntryOhos> {
        let values = ArrayList<EntryOhos>()

        for (i in 0..Int64(xRange)) {
            let x = Float64(i)
            let y = Random().nextFloat64() * yRange
            values.append(EntryOhos(x, y))
        }
        return values
    }

    func build() {
        Column() {
            // 为组件设置配置构建类，如果需要在页面初始化就显示图表，则需要在 aboutToAppear 方法中完成图表数据构建
            // 如果在之后通过事件触发，
            // 可通过dataResult.notifyDataSetChanged() 来触发数据更新，
            // 可通过this.model.notifyDataSetChanged() 来触发坐标轴数据更新，
            // 可通过this.model.invalidate() 来触发绘制更新。
            ScatterChart(model: this.model)
        }.width(100.percent).height(70.percent).backgroundColor(Color.WHITE)

    }
}

// 自定义散点形状
public class CustomScatterShapeRenderer <: IShapeRenderer {
    public func renderShape(c: CanvasRenderingContext2D, dataSet: IScatterDataSet, viewPortHandler: ViewPortHandler,
        posX: Float64, posY: Float64, renderPaint: ChartPaint): Unit {
        let shapeHalf: Float64 = dataSet.getScatterShapeSize() / 2.0

        renderPaint.setStyle(Style.STROKE)
        renderPaint.setStrokeWidth(Utils.handleDataValues(1.0))
        Utils.resetContext2DStyle(c, renderPaint)
        c.beginPath()
        c.moveTo(posX - shapeHalf, posY - shapeHalf)
        c.lineTo(posX + shapeHalf, posY + shapeHalf)
        c.stroke()
        c.closePath()
    }
}
