/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package ohos_app_cangjie_entry.linePage

import ohos.state_macro_manage.*

@Entry
@Component
class ColorfulPage {
    var lineChartModel1: LineChartModel = LineChartModel.build()
    var lineChartModel2: LineChartModel = LineChartModel.build()
    var lineChartModel3: LineChartModel = LineChartModel.build()
    var lineChartModel4: LineChartModel = LineChartModel.build()

    func aboutToAppear() {
        this.initialLineChartModel(this.lineChartModel1)

        this.initialLineChartModel(this.lineChartModel2)

        this.initialLineChartModel(this.lineChartModel3)

        this.initialLineChartModel(this.lineChartModel4)
    }

    // 初始化折线图数据模型
    private func initialLineChartModel(model: LineChartModel) {
        let description: Description = model.getDescription()

        description.setEnabled(false)

        model.setMaxVisibleValueCount(50)
        model.setPinchZoom(false)
        model.setDrawGridBackground(false)

        let xAxis: ?XAxis = model.getXAxis()
        if (let Some(xAxis) <- xAxis) {
            xAxis.setEnabled(false)
            xAxis.setXOffset(0.0)
            xAxis.setPosition(XAxisPosition.BOTTOM)
            xAxis.setDrawGridLines(false)
            xAxis.setGranularity(1.0)
            xAxis.setLabelCount(7, false)
        }

        let leftAxis: ?YAxis = model.getAxisLeft()
        if (let Some(leftAxis) <- leftAxis) {
            leftAxis.setEnabled(false)
            leftAxis.setLabelCount(8, false)
            leftAxis.setPosition(YAxisLabelPosition.OUTSIDE_CHART)
            leftAxis.setSpaceTop(15.0)
            leftAxis.setAxisMinimum(0.0)
        }

        let rightAxis: ?YAxis = model.getAxisRight()
        if (let Some(rightAxis) <- rightAxis) {
            rightAxis.setEnabled(false)

            rightAxis.setLabelCount(8, false)
            rightAxis.setDrawGridLines(false)
            rightAxis.setSpaceTop(15.0)
            rightAxis.setAxisMinimum(0.0)
        }

        let legend: ?Legend = model.getLegend()
        if (let Some(legend) <- legend) {
            legend.setEnabled(false)
        }

        let values: ArrayList<EntryOhos> = ArrayList<EntryOhos>()
        for (i in 1..40) {
            let val = Random().nextFloat64() * 41.0

            if (Random().nextFloat64() * 100.0 < 25.0) {
                values.append(EntryOhos(Float64(i), val))
            } else {
                values.append(EntryOhos(Float64(i), val))
            }
        }

        let dataSet: LineDataSet = LineDataSet(values, "DataSet")
        dataSet.setHighlightEnabled(false)
        dataSet.setDrawIcons(false)

        dataSet.setMode(Mode.LINEAR)
        dataSet.setDrawCircles(true)
        dataSet.setDrawCircleHole(true) //设置内部孔
        dataSet.setCircleHoleColor(0x008000)
        dataSet.setDrawValues(false)
        dataSet.setColorByColor(0xffffff) //设置折线颜色

        // 设置数据点的颜色
        dataSet.setCircleColor(0xffffff) // 可以将圆环设置为你想要的颜色

        // dataSet.enableDashedLine(5, 5, 0)//虚折线
        // 设置数据点的半径
        dataSet.setCircleRadius(5.0) // 设置半径大小
        dataSet.setCircleHoleRadius(2.5) //设置内径

        let dataSetList: ArrayList<ILineDataSet> = ArrayList<ILineDataSet>()
        dataSetList.append(dataSet)

        let lineData: LineData = LineData(dataSetList)
        lineData.setValueTextSize(10.0)
        model.setData(lineData)
    }

    func build() {
        Column {
            Stack(Alignment.TopStart) {
                LineChart(model: this.lineChartModel1)
            }

            Stack(Alignment.TopStart) {
                LineChart(model: this.lineChartModel2)
            }

            Stack(Alignment.TopStart) {
                LineChart(model: this.lineChartModel3)
            }

            Stack(Alignment.TopStart) {
                LineChart(model: this.lineChartModel4)
            }
        }.width(100.percent).height(70.percent).backgroundColor(Color.WHITE)
    }
}
