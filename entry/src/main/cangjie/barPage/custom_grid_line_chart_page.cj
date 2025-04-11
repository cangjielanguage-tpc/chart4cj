/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package ohos_app_cangjie_entry.barPage

//import ohos.base.*
//import ohos.component.*
//import ohos.state_manage.*
import ohos.state_macro_manage.*

public  class ColorArray {
    public ColorArray(
        let colorText: String,
        let color: Color,
        let colorVal: String
    ) {}
}

@Component
public class CustomGridLineChartPage {
    private var title: String = "custom grid line"
    private var model: BarChartModel = BarChartModel.build()
    private var leftAxis: ?YAxis = Option<YAxis>.None
    private var rightAxis: ?YAxis = Option<YAxis>.None
    private var xAxis: ?XAxis = Option<XAxis>.None
    private var barData: BarData = BarData()
    var pageInfo: NavPathStack = NavPathStack()

    @State
    var eventText: String = ""
    @State
    var colorSetter: Array<ColorArray> = [
        ColorArray("红色:", Color.RED, "red"),
        ColorArray("蓝色:", Color.BLUE, "blue")
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
    func getArrData(): ArrayList<ColorArray> {
        var list: ArrayList<ColorArray> = ArrayList<ColorArray>()
        list.append(ColorArray("红色:", Color.RED, "red"))
        list.append(ColorArray("蓝色:", Color.BLUE, "blue"))
        return list
    }

    // 网格线设置
    @Builder
    func gridLineSettings() {
        Row() {
            Text("默认网格线设置： ")
            ForEach([ColorArray("红色:", Color.RED, "red"), ColorArray("蓝色:", Color.BLUE, "blue")],
                itemGeneratorFunc: {
                item: ColorArray, _: Int64 => Row() {
                    Text(item.colorText)
                    Radio(value: item.colorText, group: "gridValue").checked(false).onChange(
                        {
                        isChecked: Bool => if (isChecked) {
                            //if (this.model) {
                            let yAxis = this.model.getAxisLeft()
                            if (let Some(yAxis) <- yAxis) {
                                yAxis.setGridColor(item.color)
                                yAxis.setGridLineWidth(1.0)
                                yAxis.setGridDashedLine(DashPathEffect([2.0, 2.0]))
                                this.model.invalidate()
                            }
                            //}
                        }
                    })
                }
            })
        }.alignSelf(ItemAlign.Start)

        Row() {
            Text("自定义网格线:")
            Checkbox(name: "customGridLine", group: "gridLine").select(false).onChange(
                {
                    isChecked: Bool =>
                    if (this.leftAxis.isNone() || this.xAxis.isNone()) {
                        return
                    }
                    if (isChecked) {
                        this.xAxis().addGridLine(GridLineConfig(8.0, 0x0000FF, 0.6, DashPathEffectConfig(5.0, 10.0)))
                        this.leftAxis().addGridLine(GridLineConfig(35.0, 0xFF0000, 1.0,
                            Option<DashPathEffectConfig>.None))
                        this.leftAxis().addGridLine(GridLineConfig(45.0, 0x999999, 1.0,
                            Option<DashPathEffectConfig>.None))
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
        NavDestination() {
            Column {
                Column {
                    Text(this.title).fontSize(21).fontColor(Color.WHITE).fontWeight(FontWeight.W600).layoutWeight(1).
                        maxLines(1)
                    BarChart(model: this.model)
                }.width(100.percent).height(70.percent).backgroundColor(Color.WHITE)
                Scroll() {
                    Stack() {
                        Column() {
                            this.gridLineSettings()
                        }
                    }.align(Alignment.TopEnd)
                }
            }
        }.onReady({
            context => pageInfo = context.pathStack
        }).onBackPressed({
            => false
        })
    }
}
