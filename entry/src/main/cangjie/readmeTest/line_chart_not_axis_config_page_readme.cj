/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package ohos_app_cangjie_entry.readmeTest

import ohos.state_macro_manage.*


@Entry
@Component
class LineChartNotAxisConfigPageReadme {
    private var model: LineChartModel = LineChartModel.build()
    var minOffset: Float64 = 15.0
    var leftAxis: ?YAxis = None
    var rightAxis: ?YAxis = None
    var xAxis: ?XAxis = None
    var lineData: LineData = LineData()

    protected override func aboutToAppear() {
        let legend: ?Legend = this.model.getLegend() //设置图例
        if (let Some(v) <- legend) {
            v.setEnabled(true) //设置图例显示
            v.setOrientation(LegendOrientation.HORIZONTAL) // 设置图例方向为水平
            v.setVerticalAlignment(LegendVerticalAlignment.BOTTOM) // 设置图例垂直对齐方式为底部
            v.setHorizontalAlignment(LegendHorizontalAlignment.CENTER) // 设置图例水平对齐方式为居中
            v.setDrawInside(false) // 设置图例绘制在图表外部
        }

        this.xAxis = this.model.getXAxis()
        if (let Some(xaxis) <- this.xAxis) {
            xaxis.setPosition(XAxisPosition.BOTTOM) // 设置X轴位置在底部
        }

        this.lineData = this.setData(10, 100.0)
        this.model.setDrawMarkers(true)
        this.model.setMarker(MarkerView())
        this.model.setData(this.lineData)
    }

    private func setData(count: Int64, range: Float64): LineData {
        let values1 = ArrayList<EntryOhos>()
        let values2 = ArrayList<EntryOhos>()
        let values3 = ArrayList<EntryOhos>()

        for (i in 0..count) {
            let val: Float64 = Random().nextFloat64() * range + 3.0
            values1.add(EntryOhos(Float64(i), val))
        }

        for (i in 0..count) {
            let val: Float64 = Random().nextFloat64() * range + 3.0
            values2.add(EntryOhos(Float64(i), val))
        }

        for (i in 0..count) {
            let val: Float64 = Random().nextFloat64() * range + 3.0
            values3.add(EntryOhos(Float64(i), val))
        }


        let dataSet = ArrayList<ILineDataSet>()

        let gradientFillColor = ArrayList<ChartColorStop>()
        gradientFillColor.add((0xffffff, 0.3))
        gradientFillColor.add((0x00ffff, 1.0))

        let set1 = LineDataSet(values1, "DataSet 1")
        set1.setDrawFilled(true) //设置不渐变色填充
        set1.setFillColor(Color.PINK.toUInt32())
        set1.setDrawValues(true) //设置数据标签显示
        set1.setDrawCircles(true) //折线点画圆圈
        set1.setCircleColor(0x2b89ab) // 设置数据点的颜色
        set1.setCircleRadius(4.0) // 设置半径大小
        set1.setMode(Mode.LINEAR) //直线模式
        set1.setColorByColor(0x2b89ab) //设置折线颜色
        set1.setLineWidth(2.5) //设置线宽

        set1.setHighlightEnabled(true)
        set1.setHighLightColor(Color.RED.toUInt32())

        dataSet.add(set1)

        let set2 = LineDataSet(values2, "DataSet 2")
        set2.setDrawFilled(true) //设置不渐变色填充
        set1.setFillColor(Color.BLUE.toUInt32())
        set2.setDrawValues(true) //设置数据标签显示
        set2.setDrawCircles(true) //折线点画圆圈
        set2.setCircleColor(0xcd4e2e) // 设置数据点的颜色
        set2.setCircleRadius(4.0) // 设置半径大小
        set2.setMode(Mode.HORIZONTAL_BEZIER) //90度线模式
        set2.setColorByColor(0xcd4e2e) //设置折线颜色
        set2.setLineWidth(2.5) //设置线宽
        dataSet.add(set2)

        let set3 = LineDataSet(values3, "DataSet 3")
        set3.setDrawFilled(true) //设置不渐变色填充
        set1.setFillColor(Color.GREEN.toUInt32())
        set3.setDrawValues(true) //设置数据标签显示
        set3.setDrawCircles(true) //折线点画圆圈
        set3.setCircleColor(0xacc045) // 设置数据点的颜色
        set3.setCircleRadius(4.0) // 设置半径大小
        set3.setMode(Mode.CUBIC_BEZIER) //直线模式
        set3.setColorByColor(0xacc045) //设置折线颜色
        set3.setLineWidth(2.5) //设置线宽
        dataSet.add(set3)

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
