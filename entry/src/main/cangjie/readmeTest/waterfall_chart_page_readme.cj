/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package ohos_app_cangjie_entry.readmeTest

import ohos.state_macro_manage.*


@Entry
@Component
class WaterfallChartPageReadme {
    private var model: WaterfallChartModel = WaterfallChartModel.build()
    private var dataSet: WaterfallDataSet = WaterfallDataSet(ArrayList<WaterfallEntry>(), "")
    private var leftAxis: ?YAxis = Option<YAxis>.None
    private var rightAxis: ?YAxis = Option<YAxis>.None
    private var xAxis: ?XAxis = Option<XAxis>.None
    private var data: WaterfallData = WaterfallData()
    private var normalMarker: MarkerView = MarkerView()

    protected override func aboutToAppear() {
        // 获取图表描述部件，设置图表描述部件不可用，即图表不进行绘制描述部件
        let description: ?Description = this.model.getDescription()
        if (let Some(des) <- description) {
            des.setEnabled(false)
        }

        // 获取图表图例部件，设置图表图例部件不可用
        let l: ?Legend = this.model.getLegend()
        if (let Some(v) <- l) {
            v.setEnabled(true)
            v.setOrientation(LegendOrientation.HORIZONTAL)
            v.setVerticalAlignment(LegendVerticalAlignment.BOTTOM)
            v.setHorizontalAlignment(LegendHorizontalAlignment.CENTER)
            v.setDrawInside(false) // 设置图例绘制在图表外部
        }

        // 设置图表数据最大的绘制数，如果超过该数值，则不进行绘制图表的数值标签
        this.model.setMaxVisibleValueCount(40)
        // 是否绘制图表的背景色，绘制范围为图表瀑布图的绘制范围，不包含轴线之外的部分
        this.model.setDrawGridBackground(false)
        // 设置图表的背景色
        this.model.setGridBackgroundColor(0x500000ff)
        // 设置不绘制瀑布图的柱体阴影背景
        this.model.setDrawBarShadow(false)
        // 设置瀑布图的数值在柱体上方
        this.model.setDrawValueAboveBar(true)

        this.leftAxis = this.model.getAxisLeft()
        if (let Some(laxis) <- this.leftAxis) {
            laxis.setAxisMinimum(0.0)
            laxis.setDrawLimitLinesBehindData(false)
            laxis.setValueFormatter(CustomFormatter())
        }

        this.rightAxis = this.model.getAxisRight()
        if (let Some(r) <- this.rightAxis) {
            r.setEnabled(false)
            r.setAxisMinimum(0.0)
        }

        this.xAxis = this.model.getXAxis()
        if (let Some(x) <- this.xAxis) {
            x.setPosition(XAxisPosition.BOTTOM)
        }

        this.normalMarker = MarkerView()
        this.model.setMarker(this.normalMarker)

        this.data = this.getNormalData()
        this.model.setData(this.data)
        this.model.setVisibleXRangeMaximum(5.0)
    }

    private func getNormalData(): WaterfallData {
        let values: ArrayList<WaterfallEntry> = ArrayList<WaterfallEntry>()
        // 设置标记点位置及颜色
        let h1 = WaterfallHighlight(20.0, 30.0, color: 0xcd4e2e)
        let h2 = WaterfallHighlight(30.0, 40.0, color: 0xacc045)
        let h3 = WaterfallHighlight(40.0, 60.0, color: 0x339933)
        let h4 = WaterfallHighlight(60.0, 70.0, color: 0xacc045)

        values.add(WaterfallEntry(1.0, 10.0, 30.0, highlights: [h1]))
        values.add(WaterfallEntry(2.0, 15.0, 50.0))
        values.add(WaterfallEntry(3.0, 20.0, 90.0))
        values.add(WaterfallEntry(4.0, 5.0, 95.0, highlights: [h2, h3, h4]))
        values.add(WaterfallEntry(5.0, 5.0, 50.0))
        values.add(WaterfallEntry(6.0, 45.0, 80.0, highlights: [h2, h3]))
        values.add(WaterfallEntry(7.0, 60.0, 70.0))

        this.dataSet = WaterfallDataSet(values, "DataSet")
        this.dataSet.setDrawIcons(false)
        // 为柱体添加颜色信息
        this.dataSet.setColorByColor(0x2b89ab)
        this.dataSet.setValueTextSize(10.0)

        let dataSetList: ArrayList<IWaterfallDataSet> = ArrayList<IWaterfallDataSet>()
        dataSetList.add(this.dataSet)

        let data: WaterfallData = WaterfallData(dataSetList)
        data.setBarWidth(0.3)
        return data
    }

    func build() {
        Column() {
            WaterfallChart(model: this.model)
        }.width(100.percent).height(70.percent).backgroundColor(Color.WHITE)

    }
}

class CustomFormatter <: IAxisValueFormatter {
    public func getFormattedValue(value: Float64, axis: AxisBase): String {
        let str = value.format(".0").split(".")
        return "${str[0]}%"
    }
}
