/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package ohos_app_cangjie_entry.barPage

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*

public class XAxisColorSetter {
    var colorText: String
    var colorVal: UInt32
    var color: UInt32
    public init(colorText: String, colorVal: UInt32, color: UInt32) {
        this.colorText = colorText
        this.colorVal = colorVal
        this.color = color
    }
}

public class GridColorSetter {
    var colorText: String
    var colorVal: UInt32
    var color: String
    public init(colorText: String, colorVal: UInt32, color: String) {
        this.colorText = colorText
        this.colorVal = colorVal
        this.color = color
    }
    public func getColor(): String {
        this.color
    }
    public func getColorVal(): UInt32 {
        this.colorVal
    }
    public func getColorText(): String {
        this.colorText
    }
}

@Entry
@Component
class CustomGridLineChartPage {
    private var title: String = "custom grid line"
    private var model: BarChartModel = BarChartModel.build()
    private var leftAxis: ?YAxis = Option<YAxis>.None
    private var rightAxis: ?YAxis = Option<YAxis>.None
    private var xAxis: ?XAxis = Option<XAxis>.None
    private var barData: BarData = BarData()

    @State
    var eventText: String = ""
    @State
    var colorSetter: Array<XAxisColorSetter> = [
        XAxisColorSetter("红色:", UInt32 (0xff00000), UInt32 (0xff00000)),
        XAxisColorSetter("蓝色:", UInt32 (0x00ff000), UInt32 (0x00ff000))
    ]

    func aboutToAppear(): BarChartModel {
        this.model.setDragEnabled(false)
        this.model.setScaleEnabled(false)

        this.model.setMaxVisibleValueCount(40)

        this.model.setPinchZoom(false)

        this.model.setDrawGridBackground(false)
        this.model.setGridBackgroundColor(0x500000ff)
        this.model.setDrawBarShadow(false)

        this.model.setDrawValueAboveBar(false)
        this.model.setHighlightFullBarEnabled(false)

        this.leftAxis = this.model.getAxisLeft()
        if (let Some(leftaxis) <- this.leftAxis) {
            leftaxis.setAxisMinimum(0.0)
        }

        this.rightAxis = this.model.getAxisRight()
        if (let Some(rightaxis) <- this.rightAxis) {
            rightaxis.setEnabled(false)
            rightaxis.setAxisMinimum(0.0)
        }

        this.xAxis = this.model.getXAxis()
        if (let Some(xaxis) <- this.xAxis) {
            xaxis.setPosition(XAxisPosition.BOTTOM)
        }

        this.barData = this.getNormalData()
        this.model.setData(this.barData)
        this.model.setVisibleXRangeMaximum(20.0)

        return this.model
    }

    private func getNormalData(): BarData {
        let values: ArrayList<BarEntry> = ArrayList<BarEntry>()
        values.append(BarEntry(1.0, 73.3))
        values.append(BarEntry(2.0, 5.4))
        values.append(BarEntry(3.0, 73.9))
        values.append(BarEntry(4.0, 79.9))
        values.append(BarEntry(5.0, 69.3))
        values.append(BarEntry(6.0, 70.7))
        values.append(BarEntry(7.0, 81.2))
        values.append(BarEntry(8.0, 13.1))
        values.append(BarEntry(9.0, 34.2))
        values.append(BarEntry(10.0, 58.4))
        values.append(BarEntry(11.0, 44.7))
        values.append(BarEntry(12.0, 10.5))
        values.append(BarEntry(13.0, 15.6))
        values.append(BarEntry(14.0, 95.8))
        values.append(BarEntry(15.0, 57.4))
        values.append(BarEntry(16.0, 64.5))
        values.append(BarEntry(17.0, 21.4))
        values.append(BarEntry(18.0, 33.2))
        values.append(BarEntry(19.0, 96.9))

        let dataSet: BarDataSet = BarDataSet(values, "DataSet")
        dataSet.setHighLightColor(0x000000)
        dataSet.setDrawIcons(false)
        dataSet.setColorByColor(0xFFC0CB)

        let dataSetList: ArrayList<IBarDataSet> = ArrayList<IBarDataSet>()
        dataSetList.append(dataSet)

        let barData: BarData = BarData(dataSetList)
        barData.setBarWidth(0.85)
        return barData
    }

    func build() {
        Column {
            Text(this.title).fontSize(21).fontColor(Color.WHITE).fontWeight(FontWeight.W600).layoutWeight(1).maxLines(1)
            BarChart(model: aboutToAppear())
        }.width(100.percent).height(70.percent).backgroundColor(Color.WHITE)
    }
}
