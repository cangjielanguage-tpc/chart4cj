/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package ohos_app_cangjie_entry.scrollingCharts.viewPageItems

import ohos.hilog.*
import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*
import chart.pie.*
import chart.utils.*
import chart.components.*
import chart.charts.*
import chart.line.*
import std.collection.{ArrayList}
import ohos_app_cangjie_entry.scrollingCharts.data.Cosine
import ohos_app_cangjie_entry.scrollingCharts.data.Sine

@Entry
@Component
public class fragSimpleLineIndex {
    var minOffset: Float64 = 15.0;
    @State
    var lineChartModel: LineChartModel = LineChartModel.build()
    var lineData: LineData = LineData()

    protected override func aboutToAppear() {
        this.lineData = this.initCurveData(45, 100.0)
        this.lineChartModel.setData(this.lineData);

        let xAxis = this.lineChartModel.getXAxis();
        if (let Some(xAxis) <- xAxis) {
            xAxis.setLabelCount(5, false);
            xAxis.setPosition(XAxisPosition.TOP);
            xAxis.setAxisMinimum(0.0);
            xAxis.setAxisMaximum(this.lineData.getXMax());
            xAxis.setDrawAxisLine(false);
            xAxis.setDrawLabels(false);
            xAxis.setDrawGridLines(false);
        }

        let leftAxis = this.lineChartModel.getAxisLeft();
        if (let Some(leftAxis) <- leftAxis) {
            leftAxis.setLabelCount(10, false);
            leftAxis.setPosition(YAxisLabelPosition.OUTSIDE_CHART);
            leftAxis.setAxisMinimum(this.lineData.getYMin() - 0.3);
            leftAxis.setAxisMaximum(this.lineData.getYMax() + 0.3);
            leftAxis.setDrawGridLines(true);
            leftAxis.setDrawAxisLine(true);
            leftAxis.setSpaceTop(15.0);
            leftAxis.setAxisLineColor(Color(0x80333333));
            leftAxis.setDrawLabels(true);
        }

        let rightAxis = this.lineChartModel.getAxisRight();
        if (let Some(rightAxis) <- rightAxis) {
            rightAxis.setDrawGridLines(false);
            rightAxis.setAxisMinimum(this.lineData.getYMin());
            rightAxis.setAxisMaximum(this.lineData.getYMax());
            rightAxis.setDrawAxisLine(true);
            rightAxis.setDrawLabels(true);
        }
    }

    private func initCurveData(count: Int64, range: Float64): LineData {
        let valuesSine = ArrayList<EntryOhos>();
        let sine: Array<Float64> = Sine().data;
        for (i in 0..sine.size) {
            valuesSine.append(EntryOhos(Float64(i), sine[i]));
        }

        let valuesCosine = ArrayList<EntryOhos>();
        let cosine: Array<Float64> = Cosine().data;
        for (i in 0..cosine.size) {
            valuesCosine.append(EntryOhos(Float64(i), cosine[i]));
        }

        let dataSet = ArrayList<ILineDataSet>();

        let set1 = LineDataSet(valuesSine, "Sine function");
        set1.setLineWidth(2.0);
        set1.setDrawFilled(false);
        set1.setDrawValues(false);
        set1.setMode(Mode.LINEAR);
        set1.setColorByColor(0xc0ff8c);
        set1.setDrawCircles(false);

        let set2 = LineDataSet(valuesCosine, "Cosine function");
        set2.setLineWidth(2.0);
        set2.setDrawFilled(false);
        set2.setDrawValues(false);
        set2.setMode(Mode.LINEAR);
        set2.setColorByColor(0xfff78c);
        set2.setDrawCircles(false);

        dataSet.append(set1);
        dataSet.append(set2);

        return LineData(dataSet)
    }

    func build() {
        Column {
            LineChart(model: this.lineChartModel)
        }.width(100.percent).height(70.percent).backgroundColor(Color.WHITE)
    }
}
