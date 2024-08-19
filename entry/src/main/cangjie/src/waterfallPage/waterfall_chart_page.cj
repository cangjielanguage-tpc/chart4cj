/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package ohos_app_cangjie_entry.waterfallPage

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
class SimpleWaterfallChartPage {
    private var model: WaterfallChartModel = WaterfallChartModel.build()
    private var dataSet: WaterfallDataSet = WaterfallDataSet(ArrayList<WaterfallEntry>(), "")
    private var leftAxis: ?YAxis = Option<YAxis>.None
    private var rightAxis: ?YAxis = Option<YAxis>.None
    private var xAxis: ?XAxis = Option<XAxis>.None
    private var limitLine1: LimitLine = LimitLine(100.0, "100")
    private var limitLine2: LimitLine = LimitLine(120.0, "Average")
    private var data: WaterfallData = WaterfallData()
    private var normalMarker: MarkerView = MarkerView()

    private var valueSelectedListener: OnChartValueSelectedListener = MyOnChartValueSelectedListener()

    protected override func aboutToAppear() {
        this.model.setOnChartValueSelectedListener(this.valueSelectedListener);

        let description: ?Description = this.model.getDescription()
        if (let Some(des) <- description) {
            des.setEnabled(false);
        }

        let l: ?Legend = this.model.getLegend();
        if (let Some(legend) <- l) {
            legend.setEnabled(false);
        }

        // if more than 40 entries are displayed in the this.model, no values will be drawn
        this.model.setMaxVisibleValueCount(40);

        // scaling can now only be done on x- and y-axis separately
        this.model.setPinchZoom(false);

        this.model.setDrawGridBackground(false);
        this.model.setGridBackgroundColor(0x500000ff)
        this.model.setDrawBarShadow(false);

        this.model.setDrawValueAboveBar(false);
        this.model.setHighlightFullBarEnabled(false);

        this.limitLine1 = LimitLine(120.0, "Upper Limit")
        this.limitLine1.setLineWidth(4.0);
        this.limitLine1.enableDashedLine(10, 10, 0);
        this.limitLine1.setLabelPosition(LimitLabelPosition.RIGHT_TOP);
        this.limitLine1.setTextSize(10.0);

        this.limitLine2 = LimitLine(50.0, "Lower Limit")
        this.limitLine2.setLineWidth(4.0);
        this.limitLine2.enableDashedLine(10, 10, 0);
        this.limitLine2.setLineColor(0xFFFF00);
        this.limitLine2.setLabelPosition(LimitLabelPosition.RIGHT_BOTTOM);
        this.limitLine2.setTextSize(10.0);

        // change the position of the y-labels
        this.leftAxis = this.model.getAxisLeft()
        if (let Some(laxis) <- this.leftAxis) {
            laxis.setAxisMinimum(0.0);
            laxis.setDrawLimitLinesBehindData(false);
            laxis.setValueFormatter(CustomFormatter());

            // add limit lines
            laxis.addLimitLine(this.limitLine1);
            laxis.addLimitLine(this.limitLine2);
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

    private func getNormalData2(): WaterfallData {
        let values: ArrayList<WaterfallEntry> = ArrayList<WaterfallEntry>();

        values.append(WaterfallEntry(1.0, 10.0, 70.0));
        values.append(WaterfallEntry(2.0, 15.0, 80.0));
        values.append(WaterfallEntry(3.0, 20.0, 90.0));
        values.append(WaterfallEntry(4.0, 5.0, 80.0));
        values.append(WaterfallEntry(5.0, 5.0, 50.0));
        values.append(WaterfallEntry(6.0, 45.0, 80.0));
        values.append(WaterfallEntry(7.0, 60.0, 70.0));

        this.dataSet = WaterfallDataSet(values, "DataSet")
        this.dataSet.setHighLightColor(0x999999);
        this.dataSet.setDrawIcons(false);
        this.dataSet.setColorByColor(0xFFC0CB);
        this.dataSet.setValueTextSize(10.0)

        // 根据Y刻度范围设置颜色
        let highlightList: ArrayList<WaterfallHighlight> = ArrayList<WaterfallHighlight>();
        highlightList.append(WaterfallHighlight(0.0, 40.0, color: 0x008000));
        highlightList.append(WaterfallHighlight(40.0, 60.0, color: 0xFFA500));
        highlightList.append(WaterfallHighlight(60.0, 100.0, color: 0xFFC0CB));
        this.dataSet.setYAxisSegmentationColors(highlightList.toArray());

        let dataSetList: ArrayList<IWaterfallDataSet> = ArrayList<IWaterfallDataSet>();
        dataSetList.append(this.dataSet);

        let data: WaterfallData = WaterfallData(dataSetList);
        data.setBarWidth(0.3);
        return data;
    }

    private func getNormalData3(): WaterfallData {
        let values: ArrayList<WaterfallEntry> = ArrayList<WaterfallEntry>();

        values.append(WaterfallEntry(1.0, 10.0, 90.0));
        values.append(WaterfallEntry(2.0, 15.0, 80.0));
        values.append(WaterfallEntry(3.0, 20.0, 90.0));
        values.append(WaterfallEntry(4.0, 5.0, 80.0));
        values.append(WaterfallEntry(5.0, 5.0, 50.0));
        values.append(WaterfallEntry(6.0, 45.0, 80.0));
        values.append(WaterfallEntry(7.0, 60.0, 70.0));

        this.dataSet = WaterfallDataSet(values, "DataSet")
        this.dataSet.setHighLightColor(0x999999);
        this.dataSet.setDrawIcons(false);
        this.dataSet.setColorByColor(0xFFC0CB);
        this.dataSet.setValueTextSize(10.0)
        // 根据Y刻度范围设置颜色
        let highlightList: ArrayList<WaterfallHighlight> = ArrayList<WaterfallHighlight>();
        highlightList.append(WaterfallHighlight(0.0, 40.0, color: 0xcddc39));
        highlightList.append(WaterfallHighlight(40.0, 60.0, color: 0x00bcd4));
        highlightList.append(WaterfallHighlight(60.0, 100.0, color: 0xff9800));
        this.dataSet.setYAxisSegmentationColors(highlightList.toArray());
        // 最高点最低点高亮时颜色设置
        this.dataSet.setEnableMaxOrMinHighlightColor(true);
        this.dataSet.setMaxyHighlightColor(0xA52A2A);
        this.dataSet.setMinyHighlightColor(0xFFFF00);
        let dataSetList: ArrayList<IWaterfallDataSet> = ArrayList<IWaterfallDataSet>();
        dataSetList.append(this.dataSet);

        let data: WaterfallData = WaterfallData(dataSetList);
        data.setBarWidth(0.3);
        return data;
    }

    func build() {
        Column() {
            Column() {
                WaterfallChart(model: this.model)
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

                Row() {
                    Text("通过Y轴分段: ")
                    Radio(value: "CUBIC_BEZIER", group: "dataType").checked(false).onChange(
                        {
                        isChecked: Bool => if (isChecked) {
                            this.data = this.getNormalData2()
                            this.model.setData(this.data);
                        }
                    })
                }
                Row() {
                    Text("最高最低点高亮: ")
                    Radio(value: "CUBIC_BEZIER", group: "dataType").checked(false).onChange(
                        {
                        isChecked: Bool => if (isChecked) {
                            this.data = this.getNormalData3()

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
