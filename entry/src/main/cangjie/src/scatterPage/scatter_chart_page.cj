/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package ohos_app_cangjie_entry.scatterPage

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*

@Entry
@Component
class ScatterChartPage {
    private var model: ScatterChartModel = ScatterChartModel.build()

    func aboutToAppear(): ScatterChartModel {
        let l: ?Legend = this.model.getLegend()
        if (let Some(legend) <- l) {
            legend.setEnabled(true)
        }

        let description: Description = this.model.getDescription()
        description.setEnabled(true)

        this.model.setMaxVisibleValueCount(160);
        this.model.setPinchZoom(false);
        this.model.setDrawGridBackground(false);
        this.model.animateXY(2000, 2000)

        let xAxis: ?XAxis = this.model.getXAxis()
        if (let Some(xAxis) <- xAxis) {
            xAxis.setPosition(XAxisPosition.BOTTOM);
            xAxis.setDrawGridLines(false);
            xAxis.setGranularity(1.0);
            xAxis.setLabelCount(7, false);
        }

        let leftAxis: ?YAxis = this.model.getAxisLeft()
        if (let Some(leftAxis) <- leftAxis) {
            leftAxis.setLabelCount(8, false);
            leftAxis.setPosition(YAxisLabelPosition.OUTSIDE_CHART)
            leftAxis.setSpaceTop(15.0);
            leftAxis.setAxisMinimum(0.0);
        }

        let rightAxis: ?YAxis = this.model.getAxisRight()
        if (let Some(rightAxis) <- rightAxis) {
            rightAxis.setLabelCount(8, false);
            rightAxis.setDrawGridLines(false);
            rightAxis.setSpaceTop(15.0);
            rightAxis.setAxisMinimum(0.0);
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

        this.setData(20.0, 10.0)
        this.model.notifyDataSetChanged()
        return this.model
    }

    private func setData(xRange: Float64, yRange: Float64): Unit {
        let values1 = this.generateRandomData(xRange, yRange);
        let values2 = this.generateRandomData(xRange, yRange);
        let values3 = this.generateRandomData(xRange, yRange);

        let set1 = ScatterDataSet(values1, "DS 1");
        set1.setScatterShape(ChartShape.SQUARE);
        set1.setColorByColor(0x008000);

        let set2 = ScatterDataSet(values2, "DS 2");
        set2.setScatterShape(ChartShape.CIRCLE);
        set2.setScatterShapeHoleColor(0xD2691E);
        set2.setScatterShapeHoleRadius(3.0);
        set2.setColorByColor(0x3333CC);

        let set3 = ScatterDataSet(values3, "DS 3");
        set3.setShapeRenderer(CustomScatterShapeRenderer());
        set3.setColorByColor(0xFF0000);

        set1.setScatterShapeSize(8.0);
        set2.setScatterShapeSize(8.0);
        set3.setScatterShapeSize(8.0);

        let dataSets: ArrayList<IScatterDataSet> = ArrayList<IScatterDataSet>()
        dataSets.append(set1); // add the data sets
        dataSets.append(set2);
        dataSets.append(set3);

        let dataResult: ScatterData = ScatterData(dataSets);
        dataResult.setDrawValues(true);
        dataResult.setValueTextSize(8.0);
        dataResult.setHighlightEnabled(true);
        dataResult.setValueTextSize(10.0);

        this.model.setData(dataResult)
        dataResult.notifyDataChanged();
    }

    private func generateRandomData(xRange: Float64, yRange: Float64): ArrayList<EntryOhos> {
        let values = ArrayList<EntryOhos>();

        for (i in 0..Int64(xRange)) {
            let x = Float64(i); // Random x value within specified count.
            let y = Random().nextFloat64() * yRange; // Random y value within specified range.
            values.append(EntryOhos(x, y));
        }
        return values;
    }

    func build() {
        Column() {
            Column() {
                ScatterChart(model: aboutToAppear())
            }
        }
    }
}
