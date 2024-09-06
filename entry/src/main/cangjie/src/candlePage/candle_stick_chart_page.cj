/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package ohos_app_cangjie_entry.candlePage

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*

@Entry
@Component
class CandlestickChartPage {
    private var model: CandleStickChartModel = CandleStickChartModel.build()

    protected override func aboutToAppear() {
        let l: ?Legend = this.model.getLegend()
        if (let Some(legend) <- l) {
            legend.setEnabled(true)
        }
        this.model.animateXY(2000, 2000)
        let description: Description = this.model.getDescription()
        description.setEnabled(true)

        this.model.setMaxVisibleValueCount(60)
        this.model.setPinchZoom(false)
        this.model.setDrawGridBackground(true)
        this.model.setGridBackgroundColor(0xffffff)

        let xAxis: ?XAxis = this.model.getXAxis()
        if (let Some(x) <- xAxis) {
            x.setPosition(XAxisPosition.BOTTOM)
            x.setDrawGridLines(true)
        }

        let leftAxis: ?YAxis = this.model.getAxisLeft()
        if (let Some(ly) <- leftAxis) {
            ly.setLabelCount(7, false)
            ly.setDrawGridLines(true)
            ly.setDrawAxisLine(true)
        }

        let rightAxis: ?YAxis = this.model.getAxisRight()
        if (let Some(ry) <- rightAxis) {
            ry.setLabelCount(7, false)
            ry.setDrawGridLines(true)
            ry.setDrawAxisLine(true)
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

        this.setData(40, 100.0)
        this.model.notifyDataSetChanged()
    }

    private func setData(count: Int64, range: Float64): Unit {
        let values = ArrayList<CandleEntry>()

        for (i in 0..count) {
            let val: Float64 = (Random().nextFloat64() * 40.0) + (range + 3.0)

            let high: Float64 = (Random().nextFloat64() * 9.0) + 8.0
            let low: Float64 = (Random().nextFloat64() * 9.0) + 8.0

            let open: Float64 = (Random().nextFloat64() * 6.0) + 1.0
            let close: Float64 = (Random().nextFloat64() * 6.0) + 1.0

            let even: Bool = i % 2 == 0

            values.append(
                CandleEntry(
                    Float64(i),
                    shadowH: val + high,
                    shadowL: val - low,
                    open: if (even) {
                        val + open
                    } else {
                        val - open
                    },
                    close: if (even) {
                        val - close
                    } else {
                        val + close
                    },
                )
            )
        }

        let dataSet: CandleDataSet = CandleDataSet(values, "candle data set")
        dataSet.setDrawIcons(false)
        dataSet.setAxisDependency(AxisDependency.LEFT)
        dataSet.setShadowColor(0x808080)
        dataSet.setShadowWidth(0.7)
        dataSet.setDecreasingPaintStyle(Style.FILL)
        dataSet.setDecreasingColor(0xff0000)
        dataSet.setIncreasingColor(0x008000)
        dataSet.setIncreasingPaintStyle(Style.STROKE)
        dataSet.setNeutralColor(0x0000ff)

        let data: CandleData = CandleData([dataSet])
        data.setValueTextSize(7.0)

        this.model.resetTracking()
        this.model.setData(data)
        this.model.invalidate()
    }

    func build() {
        Column() {
            CandleStickChart(model: this.model)
        }.width(100.percent).height(70.percent).backgroundColor(Color.WHITE)

    }
}
