/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package ohos_app_cangjie_entry.readmeTest

//import ohos.base.*
//import ohos.component.*
//import ohos.state_manage.*
import tpc.UIKit.*
import ohos.state_macro_manage.*
import std.collection.*
import std.math.*
import std.random.*
import chart.utils.*
import chart.charts.*
import chart.radar.*
import chart.components.*
import chart.pie.*


@Component
public class RadarChartPageReadme {
    private var model: RadarChartModel = RadarChartModel.build()
    var pageInfo: NavPathStack = NavPathStack()

    protected override func aboutToAppear() {
        let description: Description = this.model.getDescription()
        description.setEnabled(false)

        let l: ?Legend = this.model.getLegend() //设置图例
        if (let Some(legend) <- l) {
            legend.setEnabled(true) //设置图例显示
            legend.setOrientation(LegendOrientation.HORIZONTAL) // 设置图例方向为水平
            legend.setVerticalAlignment(LegendVerticalAlignment.BOTTOM) // 设置图例垂直对齐方式为底部
            legend.setHorizontalAlignment(LegendHorizontalAlignment.CENTER) // 设置图例水平对齐方式为居中
            legend.setTextColor(Color(0xffffff)) // 设置文本颜色
            legend.setDrawInside(false) // 设置图例绘制在图表外部
        }

        // 设置雷达图网格线宽度、颜色和透明度
        this.model.setWebLineWidth(0.3)
        this.model.setWebColor(0xFFCCCCCC)
        this.model.setWebLineWidthInner(0.3)
        this.model.setWebColorInner(0xFFCCCCCC)

        let xAxis: ?XAxis = this.model.getXAxis() // 获取 X 轴对象
        if (let Some(xAxis) <- xAxis) {
            xAxis.setPosition(XAxisPosition.BOTTOM) // 设置X轴位置在底部
            xAxis.setDrawGridLines(false) // 不绘制X轴网格线
            xAxis.setLabelCount(7, false) // 设置X轴标签数量为7
            xAxis.setYOffset(0.0)
            xAxis.setXOffset(0.0)
            xAxis.setValueFormatter(valueFormatter()) // 设置X轴标签值格式
            xAxis.setTextColor(Color(0xffffff)) // 设置X轴标签颜色
        }

        let leftAxis: ?YAxis = this.model.getYAxis() // 获取左侧Y轴对象
        if (let Some(yAxis) <- leftAxis) {
            yAxis.setLabelCount(5, false) // 设置Y轴标签数量为5，不强制使用整数标签
            yAxis.setDrawLabels(false) // 不绘制Y轴标签
            yAxis.setAxisMinimum(0.0)
            yAxis.setAxisMaximum(80.0)
        }

        // 设置雷达图数据
        this.setData()
    }

    private func setData(): Unit {
        let mul = 80.0 // 随机值的放大倍数
        let min = 20.0 // 随机值的最小基准
        let cnt = 5 // 数据点数量

        // 创建雷达图数据点集合
        let entries1: ArrayList<RadarEntry> = ArrayList<RadarEntry>()
        let entries2: ArrayList<RadarEntry> = ArrayList<RadarEntry>()

        // 注意: 将数据点添加到数据点数组中的顺序决定它们在图表中心周围的位置。
        for (i in 0..cnt) {
            let val1 = (Random().nextFloat64() * mul) + min
            entries1.append(RadarEntry(val1))

            let val2 = (Random().nextFloat64() * mul) + min
            entries2.append(RadarEntry(val2))
        }

        // 创建雷达图数据集
        let set1: RadarDataSet = RadarDataSet(entries1, "Last Week")
        set1.setColorByColor(UInt32(ChartColor.rgb(103, 110, 129)))
        set1.setLineWidth(2.0)
        set1.setDrawFilled(true)

        // 创建雷达图数据集
        let set2: RadarDataSet = RadarDataSet(entries2, "This Week")
        set2.setColorByColor(UInt32(ChartColor.rgb(121, 162, 175)))
        set2.setLineWidth(2.0)

        // 创建雷达图数据集合
        let sets: ArrayList<IRadarDataSet> = ArrayList<IRadarDataSet>()
        sets.append(set1)
        sets.append(set2)
        


        // 创建雷达图数据对象
        let data: RadarData = RadarData(sets)
        data.setDrawValues(false) // 不绘制数据值

        data.setValueTextColor(0xffffff) // 设置数据值文字颜色为白色
        this.model.setData(data) // 设置图表数据
    }

    func build() {
        NavDestination() {
            Column() {
                RadarChart(model: this.model)
            }.backgroundColor(0x3C4152).width(100.percent).height(70.percent)
        }.onReady({
            context => pageInfo = context.pathStack
        }).onBackPressed({
            => false
        })
    }
}

public class valueFormatter <: IAxisValueFormatter {
    private var mActivities: Array<String> = ["Burger", "Steak", "Salad", "Pasta", "Pizza"]

    public func getFormattedValue(value: Float64, axis: AxisBase): String {
        return this.mActivities[Int64(floor(Float64(Int64(value) % (this.mActivities.size))))]
    }
}
