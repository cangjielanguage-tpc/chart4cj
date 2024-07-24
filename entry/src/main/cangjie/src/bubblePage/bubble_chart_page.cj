/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package ohos_app_cangjie_entry.bubblePage

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*

class MyOnChartValueSelectedListener <: OnChartValueSelectedListener {
    public func onValueSelected(e: EntryOhos, h: Highlight): Unit {
        AppLog.info("BubbleChartPage onValueSelected: ${e.getX()}")
    }

    public func onNothingSelected(): Unit {
        AppLog.info("MyOnChartValueSelectedListener onNothingSelected")
    }
}

@Entry
@Component
class BubbleChartPage {
    private var menuItemArr: Array<String> = ["Animate X", "Animate Y", "Animate XY"]
    private var title: String = "BubbleChartPage"
    private var model: BubbleChartModel = BubbleChartModel.build()

    private var valueSelectedListener: OnChartValueSelectedListener = MyOnChartValueSelectedListener()
    var isDrawValuesEnable: Bool = true
    var titleSelcetString: String = "X"

    public func animate() {
        if (this.titleSelcetString == "X") {
            this.model.animateX(2000)
        } else if (this.titleSelcetString == "Y") {
            this.model.animateY(2000)
        } else if (this.titleSelcetString == "XY") {
            this.model.animateXY(2000, 2000)
        }
    }

    func aboutToAppear(): BubbleChartModel {
        let l: ?Legend = this.model.getLegend()
        if (let Some(legend) <- l) {
            legend.setEnabled(true)
        }
        this.model.setOnChartValueSelectedListener(this.valueSelectedListener)

        let description: Description = this.model.getDescription()
        description.setEnabled(false)

        this.model.setMaxVisibleValueCount(60)
        this.model.setPinchZoom(false)
        this.model.setDrawGridBackground(false)

        let xAxis: ?XAxis = this.model.getXAxis()
        if (let Some(x) <- xAxis) {
            x.setPosition(XAxisPosition.BOTTOM)
            x.setDrawGridLines(false)
            x.setGranularity(1.0)
            x.setLabelCount(7, false)
        }

        let leftAxis: ?YAxis = this.model.getAxisLeft()
        if (let Some(ly) <- leftAxis) {
            ly.setLabelCount(8, false)
            ly.setPosition(YAxisLabelPosition.OUTSIDE_CHART)
            ly.setSpaceTop(15.0)
            ly.setAxisMinimum(0.0)
        }

        let rightAxis: ?YAxis = this.model.getAxisRight()
        if (let Some(ry) <- rightAxis) {
            ry.setLabelCount(8, false)
            ry.setDrawGridLines(false)
            ry.setSpaceTop(15.0)
            ry.setAxisMinimum(0.0)
        }

        let start: Int64 = 1
        let values: ArrayList<BubblesEntry> = ArrayList<BubblesEntry>()
        for (i in start..20) {
            let val = (Random().nextFloat64() * 41.0)

            if (Random().nextFloat64() * 100.0 < 25.0) {
                values.append(BubblesEntry(Float64(i), val))
            } else {
                values.append(BubblesEntry(Float64(i), val))
            }
        }

        let dataSet: BubbleDataSet = BubbleDataSet(values, "DataSet")
        dataSet.setHighLightColor(0x000000)
        dataSet.setDrawIcons(false)

        let dataSetList: ArrayList<BubbleDataSet> = ArrayList<BubbleDataSet>()
        dataSetList.append(dataSet)

        this.setData(5, 50.0)
        this.model.notifyDataSetChanged()
        this.model.setVisibleXRangeMaximum(7.0)
        return this.model
    }

    /**
     * 初始化数据
     * @param count  曲线图点的个数
     * @param range  y轴范围
     */
    private func setData(count: Int64, range: Float64): Unit {
        let values1 = ArrayList<BubblesEntry>()
        let values2 = ArrayList<BubblesEntry>()
        let values3 = ArrayList<BubblesEntry>()

        for (i in 0..count) {
            values1.append(BubblesEntry(Float64(i), Random().nextFloat64() * range, size: Random().nextFloat64() * range)
            )
            values2.append(BubblesEntry(Float64(i), Random().nextFloat64() * range, size: Random().nextFloat64() * range)
            )
            values3.append(BubblesEntry(Float64(i), Random().nextFloat64() * range, size: Random().nextFloat64() * range)
            )
        }

        let set1: BubbleDataSet = BubbleDataSet(values1, "DS 1")
        set1.setDrawIcons(false)
        set1.setColorByColor(0x88c12552)
        set1.setIconsOffset(MPPointF(0.0, 0.0))
        set1.setDrawValues(this.isDrawValuesEnable)

        let set2: BubbleDataSet = BubbleDataSet(values2, "DS 2")
        set2.setDrawIcons(false)
        set2.setIconsOffset(MPPointF(0.0, 0.0))
        set2.setColorByColor(0x88ff6600)
        set2.setDrawValues(this.isDrawValuesEnable)

        let set3: BubbleDataSet = BubbleDataSet(values3, "DS 3")
        set3.setDrawIcons(false)
        set3.setIconsOffset(MPPointF(0.0, 0.0))
        set3.setColorByColor(0x88f5c700)
        set3.setDrawValues(this.isDrawValuesEnable)

        let dataSets = ArrayList<IBubbleDataSet>()
        dataSets.append(set1)
        dataSets.append(set2)
        dataSets.append(set3)
        let dataResult: BubbleData = BubbleData(dataSets)
        dataResult.setDrawValues(this.isDrawValuesEnable)
        dataResult.setValueTextSize(8.0)
        dataResult.setValueTextColor(0xffffff)
        dataResult.setHighlightCircleWidth(1.5)
        dataResult.setHighlightEnabled(true)
        dataResult.notifyDataChanged()

        this.model.setData(dataResult)
    }

    func build() {
        Column() {
            Column() {
                BubbleChart(model: aboutToAppear())
            }
        }
    }
}
