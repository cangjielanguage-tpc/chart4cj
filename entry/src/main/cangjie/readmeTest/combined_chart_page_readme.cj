/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package ohos_app_cangjie_entry.readmeTest

import ohos.state_macro_manage.*


@Entry
@Component
class CombinedChartPageReadme {
    private var model: CombinedChartModel = CombinedChartModel.build() //初始化图表配置构建类
    var combinedData: ?CombinedData = None
    var count: Int64 = 12

    protected override func aboutToAppear() {
        this.model.getDescription().setEnabled(false) // 禁用图表描述

        let l = this.model.getLegend() // 获取图例对象
        if (let Some(l) <- l) {
            l.setEnabled(true) // 启用图例
            l.setWordWrapEnabled(true) // 启用图例文字自动换行
            l.setHorizontalAlignment(LegendHorizontalAlignment.LEFT) // 设置图例水平对齐方式为左侧
            l.setVerticalAlignment(LegendVerticalAlignment.BOTTOM) // 设置图例垂直对齐方式为底部
            l.setDrawInside(false) // 设置图例不绘制在图表内部
            l.setOrientation(LegendOrientation.HORIZONTAL) // 设置图例水平方向显示
        }

        this.model.setMaxVisibleValueCount(60) // 设置图表最大可见数值数量为 60
        this.model.setDrawGridBackground(false) // 禁用图表绘制网格背景

        let xAxis: ?XAxis = this.model.getXAxis() // 获取X轴对象
        if (let Some(xAxis) <- xAxis) {
            xAxis.setPosition(XAxisPosition.BOTTOM) // 设置X轴位置在底部
            xAxis.setDrawGridLines(false) // 不绘制 X 轴网格线
            xAxis.setLabelCount(7, false) // 设置 X 轴标签数量为 7
            xAxis.setAxisMinimum(0.0) // 设置X轴最小值为 0.0
        }

        let leftAxis: ?YAxis = this.model.getAxisLeft() // 获取左侧 Y 轴对象
        if (let Some(leftAxis) <- leftAxis) {
            leftAxis.setLabelCount(8, false) // 设置左侧 Y 轴标签数量为8，不强制使用整数标签
            leftAxis.setPosition(YAxisLabelPosition.OUTSIDE_CHART) // 设置左侧 Y 轴标签位置在图表外部
            leftAxis.setSpaceTop(15.0) // 设置顶部空白区域为 15 个单位
            leftAxis.setAxisMinimum(0.0) // 设置左侧 Y 轴的最小值为 0
        }

        let rightAxis: ?YAxis = this.model.getAxisRight() // 获取右侧Y轴对象
        if (let Some(rightAxis) <- rightAxis) {
            rightAxis.setLabelCount(8, false) // 设置右侧Y轴标签数量为 8，不强制使用整数标签
            rightAxis.setDrawGridLines(false) // 不绘制右侧 Y 轴网格线
            rightAxis.setSpaceTop(15.0) // 设置顶部空白区域为 15 个单位
            rightAxis.setAxisMinimum(0.0) // 设置右侧 Y 轴的最小值为 0
        }

        let data: CombinedData = CombinedData() // 创建组合图表数据对象
        this.generateLineData(data) // 生成线形图数据
        this.generateWaterfallData(data) // 生成瀑布图数据
        this.generateBubbleData(data) // 生成气泡图数据
        this.generateScatterData(data) // 生成散点图数据
        this.generateCandleData(data) // 生成蜡烛图数据
        this.generateBarData(data) // 生成柱状图数据
        this.model.setData(data) // 设置图表数据
        this.model.invalidate() // 重绘图表
    }

    // 生成线形图数据
    private func generateLineData(data: CombinedData): Unit {
        let d: LineData = LineData() // 创建线形图表数据对象

        var entries: ArrayList<EntryOhos> = ArrayList()

        for (index in 0..this.count) {
            entries.add(EntryOhos(Float64(index) + 0.5, this.getRandom(15.0, 5.0)))
        }

        let set: LineDataSet = LineDataSet(entries, "Line DataSet") //创建线形图数据集合
        set.setColorByColor(0xca4443) //设置折线颜色
        set.setLineWidth(2.5) //设置折线宽度
        set.setCircleColor(0xca4443) //设置数据点的颜色
        set.setCircleRadius(3.0) // 设置半径大小
        set.setMode(Mode.LINEAR) //直线模式
        set.setDrawValues(false) //不绘制值
        set.setValueTextSize(8.0) //设置值大小
        set.setValueTextColor(0xca4443) //设置值颜色
        set.setAxisDependency(AxisDependency.LEFT) //设置数据集的轴依赖为左侧 Y 轴
        d.addDataSet(set)
        data.setLineData(d)
    }

    private func generateWaterfallData(data: CombinedData): Unit {
        var values: ArrayList<WaterfallEntry> = ArrayList<WaterfallEntry>()

        for (i in 0..this.count - 1) {
            values.add(WaterfallEntry(Float64(i) + 0.5, 35.0, 50.0))
        }

        let dataSet = WaterfallDataSet(values, "Waterfall")
        dataSet.setDrawIcons(false) //不设置显示自定义图标
        dataSet.setColorByColor(UInt32(ColorTemplate.COLORFUL_COLORS[0])) //设置图颜色
        dataSet.setValueTextSize(8.0) //设置值大小
        dataSet.setDrawValues(false) //不绘制值

        let dataSetList: ArrayList<IWaterfallDataSet> = ArrayList<IWaterfallDataSet>()
        dataSetList.add(dataSet)

        let waterfallData: WaterfallData = WaterfallData(dataSetList)
        waterfallData.setBarWidth(0.6) //设置瀑布图宽度
        data.setWaterfallData(waterfallData)
    }

    private func generateBarData(data: CombinedData): Unit {
        var entries1: ArrayList<BarEntry> = ArrayList()
        var entries2: ArrayList<BarEntry> = ArrayList()

        for (index in 0..this.count) {
            // 普通柱状图
            entries1.add(BarEntry(0.0, this.getRandom(10.0, 6.0)))

            // 堆叠
            entries2.add(BarEntry(0.0, [this.getRandom(10.0, 6.0), this.getRandom(10.0, 6.0)]))
        }

        let set1: BarDataSet = BarDataSet(entries1, "Bar 1")
        set1.setColorByAlpha(0x328fb8, 200.0) // 设置柱状图颜色和透明度
        set1.setValueTextColor(0x328fb8) //设置值颜色
        set1.setValueTextSize(8.0) //设置值大小
        set1.setAxisDependency(AxisDependency.LEFT) //设置数据集的轴依赖为左侧Y轴
        set1.setDrawValues(false) // 不绘制值

        let set2: BarDataSet = BarDataSet(entries2, "")
        set2.setStackLabels(["Stack 1", "Stack 2"])
        set2.setColorsByArrAndAlpha([0x219ea4, 0x46dcc1], 200.0) // 设置堆叠柱状图颜色和透明度
        set2.setValueTextColor(0x219ea4) //设置值颜色
        set2.setValueTextSize(8.0) //设置值大小
        set2.setAxisDependency(AxisDependency.LEFT) //设置数据集的轴依赖为左侧Y轴
        set2.setDrawValues(false) // 不绘制值

        let groupSpace = 0.06 // 组间距
        let barSpace = 0.02 // 组内图间距
        let barWidth = 0.45 // 柱状图宽度

        let set: ArrayList<IBarDataSet> = ArrayList()
        set.add(set1)
        set.add(set2)
        let d: BarData = BarData(set)
        d.setBarWidth(barWidth) //设置柱状图宽度

        // 柱状图分组
        d.groupBars(0.0, groupSpace, barSpace)
        data.setBarData(d)
    }

    private func generateScatterData(data: CombinedData): Unit {
        let d: ScatterData = ScatterData()

        var entries: ArrayList<EntryOhos> = ArrayList<EntryOhos>()

        for (index in 0..this.count) {
            entries.add(EntryOhos(Float64(index) + 0.25, this.getRandom(10.0, 55.0)))
        }

        let set: ScatterDataSet = ScatterDataSet(entries, "Scatter DataSet")
        set.setColorsByArr([0x2ecc71, 0xf1c40f, 0xe74c3c, 0x3498db]) // 设置散点图颜色
        set.setScatterShapeSize(7.5) // 设置散点图大小
        set.setDrawValues(false) // 不绘制值
        set.setValueTextSize(10.0) //设置值大小
        d.addDataSet(set)
        data.setScatterData(d)
    }

    private func generateCandleData(data: CombinedData): Unit {
        let d: CandleData = CandleData()

        var entries: ArrayList<CandleEntry> = ArrayList()

        for (index in 0..this.count : 2) {
            entries.add(CandleEntry(Float64(index + 1), shadowH: 90.0, shadowL: 70.0, open: 85.0, close: 75.0))
        }

        let set: CandleDataSet = CandleDataSet(entries, "Candle DataSet")
        set.setDecreasingColor(0x4f506c) // 设置蜡烛图下跌蜡烛的颜色
        set.setShadowColor(ColorTemplate.DKGRAY) // 设置蜡烛图阴影颜色为灰色
        set.setBarSpace(0.3) // 设置蜡烛间距
        set.setValueTextSize(10.0) //设置值大小
        set.setDrawValues(false) // 不绘制值
        d.addDataSet(set)
        data.setCandleData(d)
    }

    private func generateBubbleData(data: CombinedData): Unit {
        let bd: BubbleData = BubbleData()

        let entries: ArrayList<BubblesEntry> = ArrayList<BubblesEntry>()

        for (index in 0..this.count) {
            let y = this.getRandom(10.0, 105.0)
            let size = this.getRandom(20.0, 30.0)
            entries.add(BubblesEntry(Float64(index) + 0.5, y, size: size))
        }

        let set: BubbleDataSet = BubbleDataSet(entries, "Bubble DataSet")
        set.setColorsByArr(
            [UInt32(ChartColor.rgb(192, 255, 140)), UInt32(ChartColor.rgb(255, 247, 140)),
        UInt32(ChartColor.rgb(255, 208, 140)), UInt32(ChartColor.rgb(140, 234, 255)),
        UInt32(ChartColor.rgb(255, 140, 157))]) //设置气泡图颜色
        set.setValueTextSize(8.0) //设置值大小
        set.setValueTextColor(0xffffff) // 设置值颜色
        set.setDrawValues(false) // 不绘制值
        bd.addDataSet(set)
        data.setBubbleData(bd)
    }

    func getRandom(range: Float64, start: Float64): Float64 {
        return (Random().nextFloat64() * range) + start
    }

    func build() {
        Column() {
            // 为组件设置配置构建类，如果需要在页面初始化就显示图表，则需要在 aboutToAppear 方法中完成图表数据构建
            // 如果在之后通过事件触发，
            // 可通过 data.notifyDataSetChanged() 来触发数据更新，
            // 可通过 this.model.notifyDataSetChanged() 来触发坐标轴数据更新，
            // 可通过 this.model.invalidate() 来触发绘制更新。
            CombinedChart(model: this.model)
        }.width(100.percent).height(70.percent).backgroundColor(Color.WHITE)
    }
}
