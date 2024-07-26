/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package ohos_app_cangjie_entry.linePage
import ohos.state_macro_manage.*

@Entry
@Component
class LineChartNotAxisConfigPage {
    private var model: LineChartModel = LineChartModel.build()
    private var dataSet: LineDataSet = LineDataSet(ArrayList<EntryOhos>(), "Data Set")

    func aboutToAppear(): LineChartModel {
        let l: ?Legend = this.model.getLegend()
        if (let Some(v) <- l) {
            v.setEnabled(true)
            v.setOrientation(LegendOrientation.VERTICAL)
            v.setVerticalAlignment(LegendVerticalAlignment.BOTTOM)
            v.setHorizontalAlignment(LegendHorizontalAlignment.LEFT)
            v.setDrawInside(true)
            v.setYOffset(-10.0)
        }

        this.model.setMaxVisibleValueCount(60)
        let lineData: LineData = this.getLineData()
        lineData.setValueTextSize(10.0)
        this.model.setData(lineData)
//        this.model.setVisibleXRangeMaximum(7.0)
//        this.model.moveViewToX(10.0)
        this.model.invalidate()
        return this.model
    }

    private func getLineData(): LineData {
        let start: Int64 = 1
        let values: ArrayList<EntryOhos> = ArrayList<EntryOhos>()
        for (i in start..20) {
            let val = (Random().nextFloat64() * 141.0)

            if (Random().nextFloat64() * 100.0 < 25.0) {
                values.append(EntryOhos(Float64(i), val))
            } else {
                values.append(EntryOhos(Float64(i), val))
            }
        }

        this.dataSet = LineDataSet(values, "DataSet")
        this.dataSet.setHighLightColor(0x000000)
        this.dataSet.setDrawIcons(false)

        this.dataSet.setMode(Mode.LINEAR)
        this.dataSet.setDrawCircles(true) //折线点画圆圈
        this.dataSet.setDrawCircleHole(false) //设置内部孔
        this.dataSet.setColorByColor(0x3333FF) //设置折线颜色

        // 设置数据点的颜色
        this.dataSet.setCircleColor(0x3333FF)

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
            LineChart(model: aboutToAppear())
        }.width(100.percent).height(70.percent).backgroundColor(Color.WHITE)
    }
}
