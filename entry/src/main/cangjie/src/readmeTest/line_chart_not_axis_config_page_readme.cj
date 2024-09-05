/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package ohos_app_cangjie_entry.readmeTest

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import std.collection.*
import std.math.*
import std.random.*
import mpchart.pie.*
import mpchart.utils.{Mode, AxisDependency, ColorTemplate, ChartColor}
import mpchart.charts.*
import mpchart.line.*
import mpchart.components.*

@Entry
@Component
class LineChartNotAxisConfigPageReadme {
    private var model: LineChartModel = LineChartModel.build()
    var minOffset: Float64 = 15.0
    var leftAxis: ?YAxis = None
    var rightAxis: ?YAxis = None
    var lineData: LineData = LineData()

    protected override func aboutToAppear() {
        let legend: ?Legend = this.model.getLegend() //设置图例
        if (let Some(v) <- legend) {
            v.setEnabled(true) //设置图例显示
            v.setOrientation(LegendOrientation.HORIZONTAL) // 设置图例方向为水平
            v.setVerticalAlignment(LegendVerticalAlignment.BOTTOM) // 设置图例垂直对齐方式为底部
            v.setHorizontalAlignment(LegendHorizontalAlignment.CENTER) // 设置图例水平对齐方式为居中
            v.setDrawInside(true) // 设置图例绘制在图表内侧
            v.setYOffset(-10.0) // 设置 Y 轴方向的偏移量
        }

        this.model.setExtraOffsets(15.0, 0.0, 30.0, 0.0) // 设置图表整体偏移
        this.lineData = this.setData(10, 100.0)
        this.model.setData(this.lineData)
    }

    private func setData(count: Int64, range: Float64): LineData {
        let values1 = ArrayList<EntryOhos>()
        let values2 = ArrayList<EntryOhos>()
        let values3 = ArrayList<EntryOhos>()

        for (i in 0..count) {
            let val: Float64 = Random().nextFloat64() * range + 3.0
            values1.append(EntryOhos(Float64(i), val))
        }

        for (i in 0..count) {
            let val: Float64 = Random().nextFloat64() * range + 3.0
            values2.append(EntryOhos(Float64(i), val))
        }

        for (i in 0..count) {
            let val: Float64 = Random().nextFloat64() * range + 3.0
            values3.append(EntryOhos(Float64(i), val))
        }

        let dataSet = ArrayList<ILineDataSet>()

        let gradientFillColor = ArrayList<ChartColorStop>()
        gradientFillColor.append((0xffffff, 0.3))
        gradientFillColor.append((0x00ffff, 1.0))

        let set1 = LineDataSet(values1, "DataSet 1")
        set1.setDrawFilled(false) //设置不渐变色填充
        set1.setDrawValues(true) //设置数据标签显示
        set1.setDrawCircles(true) //折线点画圆圈
        set1.setCircleColor(0x2b89ab) // 设置数据点的颜色
        set1.setCircleRadius(4.0) // 设置半径大小
        set1.setMode(Mode.LINEAR) //直线模式
        set1.setColorByColor(0x2b89ab) //设置折线颜色
        set1.setLineWidth(2.5) //设置线宽
        dataSet.append(set1)

        let set2 = LineDataSet(values2, "DataSet 2")
        set2.setDrawFilled(false) //设置不渐变色填充
        set2.setDrawValues(true) //设置数据标签显示
        set2.setDrawCircles(true) //折线点画圆圈
        set2.setCircleColor(0xcd4e2e) // 设置数据点的颜色
        set2.setCircleRadius(4.0) // 设置半径大小
        set2.setMode(Mode.STEPPED) //90度线模式
        set2.setColorByColor(0xcd4e2e) //设置折线颜色
        set2.setLineWidth(2.5) //设置线宽
        dataSet.append(set2)

        let set3 = LineDataSet(values3, "DataSet 3")
        set3.setDrawFilled(false) //设置不渐变色填充
        set3.setDrawValues(true) //设置数据标签显示
        set3.setDrawCircles(true) //折线点画圆圈
        set3.setCircleColor(0xacc045) // 设置数据点的颜色
        set3.setCircleRadius(4.0) // 设置半径大小
        set3.setMode(Mode.LINEAR) //直线模式
        set3.setColorByColor(0xacc045) //设置折线颜色
        set3.setLineWidth(2.5) //设置线宽
        dataSet.append(set3)

        let lineData: LineData = LineData(dataSet)

        return lineData
    }

    func build() {
        Column {
            // 为组件设置配置构建类，如果需要在页面初始化就显示图表，则需要在 aboutToAppear 方法中完成图表数据构建
            // 如果在之后通过事件触发，
            // 可通过lineData.notifyDataSetChanged() 来触发数据更新，
            // 可通过this.model.notifyDataSetChanged() 来触发坐标轴数据更新，
            // 可通过this.model.invalidate() 来触发绘制更新。
            LineChart(model: this.model)
        }.width(100.percent).height(70.percent).backgroundColor(Color.WHITE)
    }
}
