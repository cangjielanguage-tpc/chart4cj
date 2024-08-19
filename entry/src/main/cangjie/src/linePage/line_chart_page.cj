/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package ohos_app_cangjie_entry.linePage
import ohos.state_macro_manage.*

class customFormatter <: IAxisValueFormatter {
    public func getFormattedValue(value: Float64, axis: AxisBase): String {
        if (Int64(value) % 2 == 0) {
            return value.toString() + value.toString() + value.toString()
        }
        return value.toString()
    }
}

@Entry
@Component
class LineChartPage {
    private var model: LineChartModel = LineChartModel.build()
    private var leftAxis: ?YAxis = Option<YAxis>.None
    private var rightAxis: ?YAxis = Option<YAxis>.None
    private var xAxis: ?XAxis = Option<XAxis>.None
    private var mCurrentMaxVisibleXCount: String = "20"
    private var mLastMaxVisibleXCount: String = "20"
    private var mBackgroundColor: UInt32 = 0x50000ff
    private var mLineWidth: String = "85"
    private var limitLine1: LimitLine = LimitLine(0.0, "")
    private var limitLine2: LimitLine = LimitLine(0.0, "")
    private var dataSet: LineDataSet = LineDataSet(ArrayList<EntryOhos>(EntryOhos(0.0, 0.0)), "")
    private var lineData: LineData = LineData()

    protected override func aboutToAppear() {
        let description: Description = this.model.getDescription()
        description.setEnabled(true)
        description.setText("this is line chart")

        this.model.setMaxVisibleValueCount(60)
        this.model.setPinchZoom(false)
        this.model.setDrawGridBackground(false)

        this.limitLine1 = LimitLine(120.0, "Upper Limit")
        this.limitLine1.setLineWidth(4.0)
        this.limitLine1.enableDashedLine(10, 10, 0)
        this.limitLine1.setLabelPosition(LimitLabelPosition.RIGHT_TOP)
        this.limitLine1.setTextSize(10.0)

        this.limitLine2 = LimitLine(50.0, "Lower Limit")
        this.limitLine2.setLineWidth(4.0)
        this.limitLine2.enableDashedLine(10, 10, 0)
        this.limitLine2.setLineColor(0xFFFF00)
        this.limitLine2.setLabelPosition(LimitLabelPosition.RIGHT_BOTTOM)
        this.limitLine2.setTextSize(10.0)

        this.xAxis = this.model.getXAxis()
        if (let Some(x) <- this.xAxis) {
            x.setPosition(XAxisPosition.BOTTOM)
            x.setDrawGridLines(false)
            x.setGranularity(1.0) //放大时为轴设置最小间隔
            x.setLabelCount(7, false)
            x.setValueFormatter(DefaultAxisValueFormatter(1))
        }

        this.leftAxis = this.model.getAxisLeft()
        if (let Some(ly) <- this.leftAxis) {
            ly.setLabelCount(8, false)
            ly.setPosition(YAxisLabelPosition.OUTSIDE_CHART)
            ly.setSpaceTop(15.0)
            ly.setAxisMinimum(0.0)
            ly.setAxisMaximum(200.0)
        }

        this.rightAxis = this.model.getAxisRight()
        if (let Some(ry) <- this.rightAxis) {
            ry.setLabelCount(8, false)
            ry.setDrawGridLines(false)
            ry.setSpaceTop(15.0)
            ry.setAxisMinimum(0.0)
            ry.setAxisMaximum(200.0)
            ry.setEnabled(false)
        }

        let legend: ?Legend = this.model.getLegend()
        if (let Some(l) <- legend) {
            l.setEnabled(true)
            l.setForm(LegendForm.LINE)
        }

        let lineData: LineData = this.getLineData()
        lineData.setValueTextSize(10.0)
        this.model.setData(lineData)
        this.model.setVisibleXRangeMaximum(7.0) //x 轴显示最大数量
    }

    private func getLineData(): LineData {
        let start: Int64 = 0
        let values: ArrayList<EntryOhos> = ArrayList<EntryOhos>()
        let val: Array<Float64> = [58.2, 103.8, 94.4, 62.0, 31.6, 33.3, 27.8, 114.4, 76.0, 81.8, 43.2]
        for (i in start..=10) {
            values.append(EntryOhos(Float64(i), val[i]))
        }

        this.dataSet = LineDataSet(values, "DataSet")
        this.dataSet.setHighLightColor(0x000000)
        this.dataSet.setDrawIcons(false)

        this.dataSet.setMode(Mode.LINEAR)
        this.dataSet.setDrawCircles(true) //折线点画圆圈
        this.dataSet.setDrawCircleHole(false) //设置内部孔
        this.dataSet.setColorByColor(0x000000) //设置折线颜色

        let gradientFillColor = ArrayList<ChartColorStop>()
        gradientFillColor.append((0x0C0099CC, 0.2))
        gradientFillColor.append((0x7F0099CC, 0.4))
        gradientFillColor.append((0x0099CC, 1.0))
        this.dataSet.setGradientFillColor(gradientFillColor) // 设置图表填充颜色
        this.dataSet.setDrawFilled(true)

        // 设置数据点的颜色
        this.dataSet.setCircleColor(0x0000FF) // 可以设置为你想要的颜色

        // 设置数据点的半径
        this.dataSet.setCircleRadius(4.0) // 设置半径大小
        this.dataSet.setCircleHoleRadius(2.0) //设置内径

        let dataSetList: ArrayList<ILineDataSet> = ArrayList<ILineDataSet>()
        dataSetList.append(this.dataSet)

        let lineData: LineData = LineData(dataSetList)
        return lineData
    }

    func build() {
        Column {
            LineChart(model: this.model)
            Divider().width(1).padding(top: 5)

            Scroll() {
                Stack() {
                    Column() {
                        Row() {
                            Text("数据类型： ")
                            Row() {
                                Text("普通: ")
                                Radio(value: "CUBIC_BEZIER", group: "dataType").checked(true).onChange(
                                    {
                                    isChecked: Bool => if (isChecked) {
                                        this.lineData = this.getLineData()
                                        this.dataSet.setMode(Mode.LINEAR)
                                        this.model.setData(this.lineData)
                                    }
                                })
                            }

                            Row() {
                                Text("贝塞尔曲线: ")
                                Radio(value: "gradient", group: "dataType").checked(false).onChange(
                                    {
                                    isChecked: Bool => if (isChecked) {
                                        this.lineData = this.getLineData()
                                        this.dataSet.setMode(Mode.CUBIC_BEZIER)
                                        this.model.setData(this.lineData)
                                    }
                                })
                            }.alignSelf(ItemAlign.Start)

                            Row() {
                                Text("Y轴是否显示： ")
                                Row() {
                                    Text("左Y轴: ")
                                    Checkbox(name: "leftYAxis", group: "yAxis").select(true).onChange(
                                        {
                                        isChecked: Bool => if (let Some(l) <- this.leftAxis) {
                                            l.setEnabled(isChecked)
                                        }
                                    })
                                }

                                Row() {
                                    Text("右Y轴: ")
                                    Checkbox(name: "rightYAxis", group: "yAxis").onChange(
                                        {
                                        isChecked: Bool => if (let Some(r) <- this.rightAxis) {
                                            r.setEnabled(isChecked)
                                        }
                                    })
                                }
                            }.alignSelf(ItemAlign.Start)

                            Row() {
                                Text("左Y轴位置： ")
                                Row() {
                                    Text("表外: ")
                                    Radio(value: "outSideChart", group: "leftYAxisLabelPosition").checked(true).onChange(
                                        {
                                        isChecked: Bool => if (this.leftAxis.isSome() && isChecked) {
                                            this.leftAxis().setPosition(YAxisLabelPosition.OUTSIDE_CHART)
                                        }
                                    })
                                }

                                Row() {
                                    Text("表内: ")
                                    Radio(value: "inSideChart", group: "leftYAxisLabelPosition").checked(false).onChange(
                                        {
                                        isChecked: Bool => if (this.leftAxis.isSome() && isChecked) {
                                            this.leftAxis().setPosition(YAxisLabelPosition.INSIDE_CHART)
                                        }
                                    })
                                }.padding(left: 20)
                            }.alignSelf(ItemAlign.Start)

                            Row() {
                                Text("右Y轴位置： ")
                                Row() {
                                    Text("表外: ")
                                    Radio(value: "outSideChart", group: "rightYAxisLabelPosition").checked(true).
                                        onChange(
                                        {
                                        isChecked: Bool => if (this.rightAxis.isSome() && isChecked) {
                                            this.rightAxis().setPosition(YAxisLabelPosition.OUTSIDE_CHART)
                                        }
                                    })
                                }

                                Row() {
                                    Text("表内: ")
                                    Radio(value: "inSideChart", group: "rightYAxisLabelPosition").checked(false).
                                        onChange(
                                        {
                                        isChecked: Bool => if (this.rightAxis.isSome() && isChecked) {
                                            this.rightAxis().setPosition(YAxisLabelPosition.INSIDE_CHART)
                                        }
                                    })
                                }.padding(left: 20)
                            }.alignSelf(ItemAlign.Start)

                            Row() {
                                Text("X轴是否显示： ")
                                Row() {
                                    Text("X轴: ")
                                    Checkbox(name: "isShowXAxis", group: "xAxis").select(true).onChange(
                                        {
                                        isChecked: Bool => if (let Some(x) <- this.xAxis) {
                                            x.setEnabled(isChecked)
                                        }
                                    })
                                }
                            }.alignSelf(ItemAlign.Start)

                            Text("X轴位置").alignSelf(ItemAlign.Start)

                            Row() {
                                Column() {
                                    Text("top")
                                    Radio(value: "top", group: "xAxisLabelPosition").checked(false).onChange(
                                        {
                                        isChecked: Bool => if (this.xAxis.isSome() && isChecked) {
                                            this.xAxis().setPosition(XAxisPosition.TOP)
                                        }
                                    })
                                }.layoutWeight(1)

                                Column() {
                                    Text("bottom")
                                    Radio(value: "bottom", group: "xAxisLabelPosition").checked(true).onChange(
                                        {
                                        isChecked: Bool => if (this.xAxis.isSome() && isChecked) {
                                            this.xAxis().setPosition(XAxisPosition.BOTTOM)
                                        }
                                    })
                                }.layoutWeight(1)

                                Column() {
                                    Text("both side")
                                    Radio(value: "both", group: "xAxisLabelPosition").checked(false).onChange(
                                        {
                                        isChecked: Bool => if (this.xAxis.isSome() && isChecked) {
                                            this.xAxis().setPosition(XAxisPosition.BOTH_SIDED)
                                        }
                                    })
                                }.layoutWeight(1)

                                Column() {
                                    Text("top")
                                    Text("InSide")
                                    Radio(value: "topInSide", group: "xAxisLabelPosition").checked(false).onChange(
                                        {
                                        isChecked: Bool => if (this.xAxis.isSome() && isChecked) {
                                            this.xAxis().setPosition(XAxisPosition.TOP_INSIDE)
                                        }
                                    })
                                }.layoutWeight(1)

                                Column() {
                                    Text("bottom")
                                    Text("InSide")
                                    Radio(value: "bottomInSide", group: "xAxisLabelPosition").checked(false).onChange(
                                        {
                                        isChecked: Bool => if (this.xAxis.isSome() && isChecked) {
                                            this.xAxis().setPosition(XAxisPosition.BOTTOM_INSIDE)
                                        }
                                    })
                                }.layoutWeight(1)
                            }.alignSelf(ItemAlign.Start)

                            Text("X轴标签样式").alignSelf(ItemAlign.Start)

                            Row() {
                                Column() {
                                    Text("普通")
                                    Radio(value: "top", group: "xAxisLabelStyle").checked(true).onChange(
                                        {
                                        isChecked: Bool => if (this.xAxis.isSome() && isChecked) {
                                            this.xAxis().setLabelRotationAngle(0)
                                            this.xAxis().setValueFormatter(DefaultAxisValueFormatter(1))
                                            this.model.notifyDataSetChanged()
                                            this.model.invalidate()
                                        }
                                    })
                                }.layoutWeight(1)

                                Column() {
                                    Text("加长、旋转")
                                    Radio(value: "bottom", group: "xAxisLabelStyle").checked(false).onChange(
                                        {
                                        isChecked: Bool => if (this.xAxis.isSome() && isChecked) {
                                            this.xAxis().setLabelRotationAngle(30)
                                            this.xAxis().setValueFormatter(customFormatter())
                                            this.model.notifyDataSetChanged()
                                            this.model.invalidate()
                                        }
                                    })
                                }.layoutWeight(1)
                            }.alignSelf(ItemAlign.Start)

                            Row() {
                                Text("是否绘制背景色：")
                                Checkbox(name: "isDrawBackground", group: "isDrawBackground").select(false).onChange(
                                    {
                                    isChecked: Bool => this.model.setDrawGridBackground(isChecked)
                                })
                            }.alignSelf(ItemAlign.Start)

                            Row() {
                                Text("LimitLine是否在数据后： ")
                                Checkbox(name: "isShowLimitLineBehindData", group: "isShowLimitLineBehindData").select(
                                    false).onChange(
                                    {
                                    isChecked: Bool => if (let Some(l) <- this.leftAxis) {
                                        l.setDrawLimitLinesBehindData(isChecked)
                                    }
                                })
                            }.alignSelf(ItemAlign.Start)

                            Row() {
                                Column() {
                                    Text("左Y轴")
                                    Text("LimitLine")
                                    Text("位置")
                                }

                                Column() {
                                    Text("both")
                                    Radio(value: "both", group: "limitLinePosition").checked(true).onChange(
                                        {
                                        isChecked: Bool => if (this.leftAxis.isSome() && isChecked) {
                                            this.leftAxis().removeAllLimitLines()
                                            this.leftAxis().addLimitLine(this.limitLine1)

                                            this.leftAxis().addLimitLine(this.limitLine2)
                                        }
                                    })
                                }.layoutWeight(1)

                                Column() {
                                    Text("none")
                                    Radio(value: "none", group: "limitLinePosition").checked(false).onChange(
                                        {
                                        isChecked: Bool => if (this.leftAxis.isSome() && isChecked) {
                                            this.leftAxis().removeAllLimitLines()
                                        }
                                    })
                                }.layoutWeight(1)

                                Column() {
                                    Text("upper")
                                    Radio(value: "upper", group: "limitLinePosition").checked(false).onChange(
                                        {
                                        isChecked: Bool => if (this.leftAxis.isSome() && isChecked) {
                                            this.leftAxis().removeAllLimitLines()

                                            this.leftAxis().addLimitLine(this.limitLine1)
                                        }
                                    })
                                }.layoutWeight(1)

                                Column() {
                                    Text("lower")
                                    Radio(value: "lower", group: "limitLinePosition").checked(false).onChange(
                                        {
                                        isChecked: Bool => if (this.leftAxis.isSome() && isChecked) {
                                            this.leftAxis().removeAllLimitLines()

                                            this.leftAxis().addLimitLine(this.limitLine2)
                                        }
                                    })
                                }.layoutWeight(1)
                            }.alignSelf(ItemAlign.Start)
                        }
                        Button("刷新").margin(top: 100).onClick(
                            {
                                =>
                                this.model.notifyDataSetChanged()
                                this.model.invalidate()
                            }
                        )
                    }
                }
            }
        }.width(100.percent).height(70.percent).backgroundColor(Color.WHITE)
    }
}
