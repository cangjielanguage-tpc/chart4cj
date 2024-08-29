/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package ohos_app_cangjie_entry.readmeTest

import ohos.state_macro_manage.*
import ohos.base.LengthProp
import ohos.component.Column
import ohos.component.Row
import ohos.component.Button
import ohos.component.Text
import ohos.component.CustomView
import ohos.component.CJEntry
import ohos.component.loadNativeView
import ohos.state_manage.SubscriberManager
import ohos.state_manage.ObservedProperty
import ohos.state_macro_manage.Entry
import ohos.state_macro_manage.Component
import ohos.state_macro_manage.State
import ohos.state_macro_manage.r
import ohos.base.*
import ohos.component.*
import std.collection.{ArrayList}
import std.math.*
import std.random.*
import mpchart.pie.*
import mpchart.utils.*
import mpchart.components.*

@Entry
@Component
class ScatterChartPageReadme {
    private var model: ScatterChartModel = ScatterChartModel.build()

    protected override func aboutToAppear() {
        let l: ?Legend = this.model.getLegend()
        if (let Some(legend) <- l) {
            legend.setEnabled(true)
            legend.setOrientation(LegendOrientation.HORIZONTAL)
            legend.setVerticalAlignment(LegendVerticalAlignment.BOTTOM)
            legend.setHorizontalAlignment(LegendHorizontalAlignment.RIGHT)
        }

        let description: Description = this.model.getDescription()
        description.setEnabled(true)

        this.model.setMaxVisibleValueCount(160)
        this.model.setDrawGridBackground(false)
        this.model.animateXY(2000, 2000)

        let xAxis: ?XAxis = this.model.getXAxis()
        if (let Some(xAxis) <- xAxis) {
            xAxis.setPosition(XAxisPosition.BOTTOM)
            xAxis.setDrawGridLines(false)
            xAxis.setLabelCount(7, false)
        }

        let leftAxis: ?YAxis = this.model.getAxisLeft()
        if (let Some(leftAxis) <- leftAxis) {
            leftAxis.setLabelCount(8, false)
            leftAxis.setPosition(YAxisLabelPosition.OUTSIDE_CHART)
            leftAxis.setSpaceTop(15.0)
            leftAxis.setAxisMinimum(0.0)
        }

        let rightAxis: ?YAxis = this.model.getAxisRight()
        if (let Some(rightAxis) <- rightAxis) {
            rightAxis.setLabelCount(8, false)
            rightAxis.setDrawGridLines(false)
            rightAxis.setSpaceTop(15.0)
            rightAxis.setAxisMinimum(0.0)
        }

        let start: Int64 = 1
        let values: ArrayList<EntryOhos> = ArrayList<EntryOhos>()

        for (i in start..20) {
            let val = (Random().nextFloat64() * 41.0)

            if (Random().nextFloat64() * 100.0 < 25.0) {
                values.append(EntryOhos(Float64(i), val))
            } else {
                values.append(EntryOhos(Float64(i), val))
            }
        }

        this.setData(20.0, 100.0)
        this.model.notifyDataSetChanged()
    }

    private func setData(xRange: Float64, yRange: Float64): Unit {
        let values1 = this.generateRandomData(xRange, yRange)
        let values2 = this.generateRandomData(xRange, yRange)
        let values3 = this.generateRandomData(xRange, yRange)

        let set1 = ScatterDataSet(values1, "DS 1")
        set1.setScatterShape(ChartShape.SQUARE)
        set1.setColorByColor(0x2b89ab)

        let set2 = ScatterDataSet(values2, "DS 2")
        set2.setScatterShape(ChartShape.CIRCLE)
        set2.setScatterShapeHoleRadius(3.0)
        set2.setColorByColor(0xcd4e2e)

        let set3 = ScatterDataSet(values3, "DS 3")
        set3.setShapeRenderer(CustomScatterShapeRenderer())
        set3.setColorByColor(0xacc045)

        set1.setScatterShapeSize(8.0)
        set2.setScatterShapeSize(8.0)
        set3.setScatterShapeSize(8.0)

        let dataSets: ArrayList<IScatterDataSet> = ArrayList<IScatterDataSet>()
        dataSets.append(set1) // add the data sets
        dataSets.append(set2)
        dataSets.append(set3)

        let dataResult: ScatterData = ScatterData(dataSets)
        dataResult.setDrawValues(true)
        dataResult.setValueTextSize(8.0)
        dataResult.setHighlightEnabled(true)
        dataResult.setValueTextSize(10.0)

        this.model.setData(dataResult)
        dataResult.notifyDataChanged()
    }

    private func generateRandomData(xRange: Float64, yRange: Float64): ArrayList<EntryOhos> {
        let values = ArrayList<EntryOhos>()

        for (i in 0..Int64(xRange)) {
            let x = Float64(i)
            let y = Random().nextFloat64() * yRange
            values.append(EntryOhos(x, y))
        }
        return values
    }

    func build() {
        Column() {
            Column() {
                ScatterChart(model: this.model)
            }
        }
    }
}

public class CustomScatterShapeRenderer <: IShapeRenderer {
    public func renderShape(c: CanvasRenderingContext2D, dataSet: IScatterDataSet, viewPortHandler: ViewPortHandler,
        posX: Float64, posY: Float64, renderPaint: Paint): Unit {
        let shapeHalf: Float64 = dataSet.getScatterShapeSize() / 2.0

        renderPaint.setStyle(Style.STROKE)
        renderPaint.setStrokeWidth(Utils.handleDataValues(1.0))
        Utils.resetContext2DStyle(c, renderPaint)
        c.beginPath()
        c.moveTo(posX - shapeHalf, posY - shapeHalf)
        c.lineTo(posX + shapeHalf, posY + shapeHalf)
        c.stroke()
        c.closePath()
    }
}
