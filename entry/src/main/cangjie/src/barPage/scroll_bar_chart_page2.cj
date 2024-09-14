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
public class LineWidthSetter {
    var text: String
    var lineWidth: Float64
    var lineWidthValue: String
    public init(text: String, lineWidth: Float64, lineWidthValue: String) {
        this.text = text
        this.lineWidth = lineWidth
        this.lineWidthValue = lineWidthValue
    }
    public func getColor(): String {
        this.text
    }
    public func getLineWidth(): Float64 {
        this.lineWidth
    }
    public func getLineWidthValue(): String {
        this.lineWidthValue
    }
}

@Entry
@Component
class ScrollBarChartPage2 {
    private var title: String = "BarChart Extension"
    private var model: BarChartModel = BarChartModel.build()
    private var leftAxis: ?YAxis = Option<YAxis>.None
    private var rightAxis: ?YAxis = Option<YAxis>.None
    private var xAxis: ?XAxis = Option<XAxis>.None
    private var barData: BarData = BarData()

    @State
    var eventText: String = ""
    @State
    var colorSetter: Array<XAxisColorSetter> = [
        XAxisColorSetter("红色:", UInt32(0xff00000), UInt32(0xff00000)),
        XAxisColorSetter("蓝色:", UInt32(0x00ff000), UInt32(0xff00000))
    ]

    protected override func aboutToAppear() {
        this.model.setDragEnabled(false)
        this.model.setScaleEnabled(false)

        this.model.setMaxVisibleValueCount(40)

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
        dataSet.setDrawIcons(false)
        dataSet.setColorByColor(0xFFC0CB)

        let dataSetList: ArrayList<IBarDataSet> = ArrayList<IBarDataSet>()
        dataSetList.append(dataSet)

        let barData: BarData = BarData(dataSetList)
        barData.setBarWidth(0.85)
        return barData
    }
    func getArrData(): ArrayList<GridColorSetter> {
        var list: ArrayList<GridColorSetter> = ArrayList<GridColorSetter>()
        list.append(GridColorSetter("红色:", UInt32(0xFF0000), "red"))
        list.append(GridColorSetter("蓝色:", UInt32(0x0000FF), "blue"))
        return list
    }

    @Builder
    func yAxisExtensionLineSettings() {
        Row() {
            Text("y轴延伸是否开启： ")
            Row() {
                Checkbox(name: "yExtensionLine", group: "YE").select(this.model.yAxisExtensionLineIsEnable()).onChange(
                    {
                        isChecked: Bool =>
                        this.model.setYAxisExtensionLine(isChecked)
                        this.model.invalidate()
                    }
                )
            }
        }.alignSelf(ItemAlign.Start)
    }

    @Builder
    func yAxisVisibleSettings() {
        Row() {
            Text("y轴是否显示： ")
            Row() {
                Text("左y轴： ")
                Checkbox(name: "leftYAxis", group: "yAxis").select(true).onChange(
                    {
                    isChecked: Bool => if (this.leftAxis.isSome()) {
                        this.leftAxis().setEnabled(isChecked)
                        this.model.invalidate()
                    }
                })
            }

            Row() {
                Text("右y轴：")
                Checkbox(name: "rightYAxis", group: "yAxis").onChange(
                    {
                    isChecked: Bool => if (this.rightAxis.isSome()) {
                        this.rightAxis().setEnabled(isChecked)
                        this.model.invalidate()
                    }
                })
            }
        }.alignSelf(ItemAlign.Start)
    }

    @Builder
    func axisColorSettings() {
        Row() {
            Text("轴线文字和颜色: ")
            ForEach(
                this.colorSetter,
                itemGeneratorFunc: {
                    item: XAxisColorSetter, idx: Int64 => Row() {
                        Text(item.colorText)
                        Radio(value: item.colorVal.toString(), group: "axisColor").checked(true).onChange(
                            {
                            isChecked: Bool => if (isChecked) {
                                var xAxis = this.model.getXAxis()
                                var leftYAxis = this.model.getAxisLeft()
                                var rightYAxis = this.model.getAxisRight()
                                if (xAxis.isSome()) {
                                    xAxis().setTextColor(Color(item.color))
                                    xAxis().setTextSize(24.0)
                                    xAxis().setAxisLineColor(Color(item.color))
                                }
                                if (leftYAxis.isSome()) {
                                    leftYAxis().setTextColor(Color(item.color))
                                    leftYAxis().setTextSize(24.0)
                                    leftYAxis().setAxisLineColor(Color(item.color))
                                }
                                if (rightYAxis.isSome()) {
                                    rightYAxis().setTextColor(Color(item.color))
                                    rightYAxis().setTextSize(24.0)
                                    rightYAxis().setAxisLineColor(Color(item.color))
                                }
                                this.model.invalidate()
                            }
                        })
                    }
                }
            )
        }.alignSelf(ItemAlign.Start)
    }

    @Builder
    func axisLineWidthSettings() {
        Row() {
            Text("y轴线宽： ")
            ForEach(
                [
                    LineWidthSetter("0.5", 0.5, "l1"),
                    LineWidthSetter("1", 1.0, "l2")
                ],
                {
                    item: LineWidthSetter, idx: Int64 => Row() {
                        Text(item.text)
                        Radio(value: item.lineWidthValue, group: "lineWidth").checked(false).onChange(
                            {
                            isChecked: Bool => if (isChecked) {
                                let yAxis = this.model.getAxisLeft()
                                if (yAxis.isSome()) {
                                    yAxis().setAxisLineWidth(item.lineWidth)
                                    this.model.invalidate()
                                }
                            }
                        })
                    }
                }
            )
        }.alignSelf(ItemAlign.Start)
    }

    @Builder
    func gridLineSettings() {
        Row() {
            Text("y轴延伸是否开启： ")
            ForEach(
                getArrData(),
                itemGeneratorFunc: {
                    item: GridColorSetter, idx: Int64 => Row() {
                        Text(item.colorText)
                        Radio(value: item.colorVal.toString(), group: "gridValue").checked(false).onChange(
                            {
                            isChecked: Bool => if (isChecked) {
                                let yAxis = this.model.getAxisLeft()
                                if (let Some(y) <- yAxis) {
                                    y.setGridColor(Color(UInt32.parse(item.color)))
                                    y.setGridLineWidth(0.6)
                                    y.setGridDashedLine(DashPathEffect([2, 2]))
                                    this.model.invalidate()
                                }
                            }
                        })
                    }
                }
            )
        }.alignSelf(ItemAlign.Start)

        Row() {
            Text("自定义网格线:")
            Checkbox(name: "customGridLine", group: "gridLine").select(false).onChange(
                {
                    isChecked: Bool =>
                    if (isChecked) {
                        // 竖向网格线，x轴刻度为8的位置
                        this.xAxis().addGridLine(GridLineConfig(8.0, 0x0000FF, 0.6, DashPathEffectConfig(5, 10)))
                        // 横向网格线，y轴刻度为35的位置
                        this.leftAxis().addGridLine(
                            GridLineConfig(35.0, 0xFF0000, 1.0, Option<DashPathEffectConfig>.None))

                        this.leftAxis().addGridLine(
                            GridLineConfig(45.0, 0x999999, 1.0, Option<DashPathEffectConfig>.None))
                        this.leftAxis().addGridLine(
                            GridLineConfig(55.0, 0x0000FF, 1.0, Option<DashPathEffectConfig>.None))
                    } else {
                        let verticalLines = this.xAxis().getGridLines()
                        let horizontalLines = this.leftAxis().getGridLines()
                        verticalLines.clear()
                        horizontalLines.clear()
                    }
                    this.model.invalidate()
                }
            )
        }.alignSelf(ItemAlign.Start)
    }

    func build() {
        Column {
            Text(this.title).fontSize(21).fontColor(Color.WHITE).fontWeight(FontWeight.W600).layoutWeight(1).maxLines(1)
            BarChart(model: this.model)
            Divider().width(1).padding(top: 5)

            Scroll() {
                Column() {
                    //                    this.yAxisExtensionLineSettings()
                    //                    this.yAxisVisibleSettings()
                    //                    this.axisColorSettings()
                    //                    this.axisLineWidthSettings()
                }
            }
        }.width(100.percent).height(70.percent).backgroundColor(Color.WHITE)
    }
}
