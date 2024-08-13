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
class WaterfallChartPageReadme {
    private var model: WaterfallChartModel = WaterfallChartModel.build()
    private var dataSet: WaterfallDataSet = WaterfallDataSet(ArrayList<WaterfallEntry>(), "")
    private var leftAxis: ?YAxis = Option<YAxis>.None
    private var rightAxis: ?YAxis = Option<YAxis>.None
    private var xAxis: ?XAxis = Option<XAxis>.None
//    private var limitLine1: LimitLine = LimitLine(100.0, "100")
//    private var limitLine2: LimitLine = LimitLine(120.0, "Average")
    private var data: WaterfallData = WaterfallData()
    private var normalMarker: MarkerView = MarkerView()

    func aboutToAppear(): WaterfallChartModel {

        let description: ?Description = this.model.getDescription()
        if (let Some(des) <- description) {
            des.setEnabled(false);
        }

        let l: ?Legend = this.model.getLegend()
        if (let Some(v) <- l) {
            v.setEnabled(true)
            v.setOrientation(LegendOrientation.VERTICAL)
            v.setVerticalAlignment(LegendVerticalAlignment.BOTTOM)
            v.setHorizontalAlignment(LegendHorizontalAlignment.LEFT)
            v.setDrawInside(true)
            v.setYOffset(-10.0)
        }

        this.model.setMaxVisibleValueCount(40);

        this.model.setPinchZoom(false);

        this.model.setDrawGridBackground(false);
        this.model.setGridBackgroundColor(0x500000ff)
        this.model.setDrawBarShadow(false);

        this.model.setDrawValueAboveBar(false);
        this.model.setHighlightFullBarEnabled(false);
        this.model.setExtraOffsets(20.0,20.0,20.0,20.0)

//        this.limitLine1 = LimitLine(120.0, "Upper Limit")
//        this.limitLine1.setLineWidth(4.0);
//        this.limitLine1.enableDashedLine(10, 10, 0);
//        this.limitLine1.setLabelPosition(LimitLabelPosition.RIGHT_TOP);
//        this.limitLine1.setTextSize(10.0);
//
//        this.limitLine2 = LimitLine(50.0, "Lower Limit")
//        this.limitLine2.setLineWidth(4.0);
//        this.limitLine2.enableDashedLine(10, 10, 0);
//        this.limitLine2.setLineColor(0xFFFF00);
//        this.limitLine2.setLabelPosition(LimitLabelPosition.RIGHT_BOTTOM);
//        this.limitLine2.setTextSize(10.0);

        this.leftAxis = this.model.getAxisLeft()
        if (let Some(laxis) <- this.leftAxis) {
            laxis.setAxisMinimum(0.0);
            laxis.setDrawLimitLinesBehindData(false);
            laxis.setValueFormatter(CustomFormatter());
//
//            laxis.addLimitLine(this.limitLine1);
//            laxis.addLimitLine(this.limitLine2);
        }

        this.rightAxis = this.model.getAxisRight()
        if (let Some(r) <- this.rightAxis) {
            r.setEnabled(false);
            r.setAxisMinimum(0.0);
        }

        this.xAxis = this.model.getXAxis()
        if (let Some(x) <- this.xAxis) {
            x.setPosition(XAxisPosition.BOTTOM);
        }

        this.normalMarker = MarkerView()
        this.model.setMarker(this.normalMarker);

        this.data = this.getNormalData()
        this.model.setData(this.data);
        this.model.setVisibleXRangeMaximum(5.0);
        return this.model
    }

    private func getNormalData(): WaterfallData {
        let values: ArrayList<WaterfallEntry> = ArrayList<WaterfallEntry>();
        let h1 = WaterfallHighlight(20.0, 30.0, color: 0x999999);
        let h2 = WaterfallHighlight(30.0, 40.0, color: 0x999999);
        let h3 = WaterfallHighlight(40.0, 60.0, color: 0x339933);
        let h4 = WaterfallHighlight(60.0, 70.0, color: 0xFF0000);

        values.append(WaterfallEntry(1.0, 10.0, 30.0, highlights: [h1]));
        values.append(WaterfallEntry(2.0, 15.0, 50.0));
        values.append(WaterfallEntry(3.0, 20.0, 90.0));
        values.append(WaterfallEntry(4.0, 5.0, 95.0, highlights: [h2, h3, h4]));
        values.append(WaterfallEntry(5.0, 5.0, 50.0));
        values.append(WaterfallEntry(6.0, 45.0, 80.0, highlights: [h2, h3]));
        values.append(WaterfallEntry(7.0, 60.0, 70.0));

        this.dataSet = WaterfallDataSet(values, "DataSet")
        this.dataSet.setHighLightColor(0x999999);
        this.dataSet.setDrawIcons(false);
        this.dataSet.setColorByColor(0xFFC0CB);
        this.dataSet.setValueTextSize(10.0)

        let dataSetList: ArrayList<IWaterfallDataSet> = ArrayList<IWaterfallDataSet>();
        dataSetList.append(this.dataSet);

        let data: WaterfallData = WaterfallData(dataSetList);
        data.setBarWidth(0.3);
        return data;
    }

    func build() {
        Column() {
            Column() {
                WaterfallChart(model: aboutToAppear())
            }
            Row() {
                Row() {
                    Text("普通: ")
                    Radio(value: "CUBIC_BEZIER", group: "dataType").checked(true).onChange(
                        {
                        isChecked: Bool => if (isChecked) {
                            this.data = this.getNormalData()
                            this.model.setData(this.data);
                        }
                    })
                }

            }.alignSelf(ItemAlign.Center)
        }
    }
}

class CustomFormatter <: IAxisValueFormatter {
    public func getFormattedValue(value: Float64, axis: AxisBase): String {
        let str = value.format(".0").split(".")
        return "${str[0]}%";
    }
}