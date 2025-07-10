/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package ohos_app_cangjie_entry.waterfallPage

import ohos.state_macro_manage.*
import ohos.hilog.Hilog

class MyWaterfallOnChartValueSelectedListener <: OnChartValueSelectedListener {
    public func onValueSelected(e: EntryOhos, h: Highlight): Unit {
        Hilog.info(0,"","Waterfall onValueSelected: ${e.getX()}")
    }

    public func onNothingSelected(): Unit {
       Hilog.info(0,"","Waterfall MyOnChartValueSelectedListener onNothingSelected")
    }
}

class MyWaterfallOnChartGestureListener <: OnChartGestureListener {
    public func onChartGestureStart (isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>, lastPerformedGesture: ChartGesture): Unit  {
      Hilog.info(0,"","-------Waterfall----------chartGestureListener onChartGestureStart lastMode: ${lastPerformedGesture.toString()}");
    }
    public func onChartGestureEnd(isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>, lastPerformedGesture: ChartGesture): Unit  {
      Hilog.info(0,"","-------Waterfall----------chartGestureListener onChartGestureEnd lastMode: ${lastPerformedGesture.toString()}");
    }
    public func onChartLongPressed(isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>): Unit  {
      Hilog.info(0,"","-------Waterfall----------chartGestureListener onChartLongPressed");
    }
    public func onChartDoubleTapped(isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>): Unit  {
      Hilog.info(0,"","------Waterfall-----------chartGestureListener onChartDoubleTapped");
    }
    public func onChartSingleTapped(isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>) : Unit {
      Hilog.info(0,"","------Waterfall-----------chartGestureListener onChartSingleTapped");
    }
    public func onChartFling(isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>, touch: TouchEvent, velocityX: Float64, velocityY: Float64): Unit {
      Hilog.info(0,"","-----Waterfall------------chartGestureListener onChartFling velocityX: ${velocityX}  velocityY: ${velocityY}");
    }
    public func onChartScale(isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>, scaleX: Float64, scaleY: Float64): Unit  {
      Hilog.info(0,"","-----Waterfall------------chartGestureListener onChartScale scaleX: ${scaleX}  scaleY: ${scaleY}");
    }
    public func onChartTranslate(isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>, dX: Float64, dY: Float64): Unit  {
      Hilog.info(0,"","------Waterfall-----------chartGestureListener onChartTranslate dx: ${dX}  dy: ${dY}");
    }
    public func onChartMove(isTouchEvent: Bool, touchEvent: Option<TouchEvent>, gestureEvent: Option<GestureEvent>) : Unit  {
      Hilog.info(0,"","-----Waterfall------------chartGestureListener onChartTranslate moved ");
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
    private var pixelMap:ChartPixelMap= ChartPixelMap()
    private var isDrawIcons: Bool = true;

    private var valueSelectedListener: OnChartValueSelectedListener = MyWaterfallOnChartValueSelectedListener()
    private var chartGestureListener: OnChartGestureListener = MyWaterfallOnChartGestureListener()

    protected override func aboutToAppear() {
        this.model.setOnChartValueSelectedListener(this.valueSelectedListener);
        this.model.setOnChartGestureListener(this.chartGestureListener);

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
        this.model.setPinchZoom(true);

        this.model.setDrawGridBackground(false);
        this.model.setGridBackgroundColor(0x500000ff)
        this.model.setDrawBarShadow(false);
        this.model.setDragDecelerationEnabled(true);

        this.model.setDrawValueAboveBar(false);
        this.model.setHighlightFullBarEnabled(true);

        this.limitLine1 = LimitLine(120.0, "Upper Limit")
        this.limitLine1.setLineWidth(4.0);
        this.limitLine1.enableDashedLine(10, 10);
        this.limitLine1.setLabelPosition(LimitLabelPosition.RIGHT_TOP);
        this.limitLine1.setTextSize(10.0);

        this.limitLine2 = LimitLine(50.0, "Lower Limit")
        this.limitLine2.setLineWidth(4.0);
        this.limitLine2.enableDashedLine(10, 10);
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

        this.pixelMap=Util.getPixelMap(@r(app.media.star).id, globalAbilityContext())
        this.data = this.getNormalData()
        this.model.setData(this.data);
        this.model.setVisibleXRangeMaximum(6.0);
    }

    private func getNormalData(): WaterfallData {
        let pixelMap = Util.getPixelMap(@r(app.media.star).id, globalAbilityContext())
        let values: ArrayList<WaterfallEntry> = ArrayList<WaterfallEntry>();
        let h1 = WaterfallHighlight(20.0, 30.0, color: 0x999999);
        let h2 = WaterfallHighlight(30.0, 40.0, color: 0x999999);
        let h3 = WaterfallHighlight(40.0, 60.0, color: 0x339933);
        let h4 = WaterfallHighlight(60.0, 70.0, color: 0xFF0000);

        values.add(WaterfallEntry(1.0, 10.0, 30.0, highlights: [h1]));
        values.add(WaterfallEntry(2.0, 15.0, 50.0));
        values.add(WaterfallEntry(3.0, 20.0, 90.0));
        values.add(WaterfallEntry(4.0, 5.0, 95.0, highlights: [h2, h3, h4]));
        values.add(WaterfallEntry(5.0, 5.0, 50.0));
        values.add(WaterfallEntry(6.0, 45.0, 80.0, highlights: [h2, h3]));
        values.add(WaterfallEntry(7.0, 60.0, 70.0));
        values.add(WaterfallEntry(8.0, 40.0,50.0, icon: pixelMap, highlights:[h1, h3]));
        values.add(WaterfallEntry(9.0, 6.0, 78.0, icon: pixelMap));
        values.add(WaterfallEntry(10.0, 70.0, 80.0, icon: pixelMap, highlights:[ h2, h4]));
        values.add(WaterfallEntry(11.0, 10.0, 45.0, icon: pixelMap));
        values.add(WaterfallEntry(12.0, 12.0, 30.0, icon: pixelMap,highlights:[ h2, h3]));
        values.add(WaterfallEntry(13.0, 40.0, 64.0, icon: pixelMap));
        values.add(WaterfallEntry(14.0, 23.0, 56.0, icon: pixelMap, highlights:[ h1, h3]));
        values.add(WaterfallEntry(15.0, 68.0, 78.0, icon: pixelMap));

        this.dataSet = WaterfallDataSet(values, "DataSet")
        this.dataSet.setHighlightEnabled(true)
        this.dataSet.setHighLightColor(Color.GRAY.toUInt32());
        this.dataSet.setDrawIcons(true);
        this.dataSet.setDrawIcons(this.isDrawIcons);
        this.dataSet.setColorByColor(Color.PINK.toUInt32());
        this.dataSet.setValueTextSize(10.0)

        let dataSetList: ArrayList<IWaterfallDataSet> = ArrayList<IWaterfallDataSet>();
        dataSetList.add(this.dataSet);

        let data: WaterfallData = WaterfallData(dataSetList);
        data.setBarWidth(0.3);
        return data;
    }

    private func getNormalData2(): WaterfallData {
        let values: ArrayList<WaterfallEntry> = ArrayList<WaterfallEntry>();

        values.add(WaterfallEntry(1.0, 10.0, 70.0, icon: this.pixelMap));
        values.add(WaterfallEntry(2.0, 15.0, 80.0, icon: this.pixelMap));
        values.add(WaterfallEntry(3.0, 20.0, 90.0, icon: this.pixelMap));
        values.add(WaterfallEntry(4.0, 5.0, 80.0, icon: this.pixelMap));
        values.add(WaterfallEntry(5.0, 5.0, 50.0, icon: this.pixelMap));
        values.add(WaterfallEntry(6.0, 45.0, 80.0, icon: this.pixelMap));
        values.add(WaterfallEntry(7.0, 60.0, 70.0, icon: this.pixelMap));

        this.dataSet = WaterfallDataSet(values, "DataSet")
        this.dataSet.setHighLightColor(Color.GRAY.toUInt32());
        this.dataSet.setDrawIcons(true);
        this.dataSet.setDrawIcons(this.isDrawIcons);
        this.dataSet.setColorByColor(Color.PINK.toUInt32());
        this.dataSet.setValueTextSize(10.0)

        // 根据Y刻度范围设置颜色
        let highlightList: ArrayList<WaterfallHighlight> = ArrayList<WaterfallHighlight>();
        highlightList.add(WaterfallHighlight(0.0, 40.0, color: Color.GREEN.toUInt32()));
        highlightList.add(WaterfallHighlight(40.0, 60.0, color: Color.ORANGE.toUInt32()));
        highlightList.add(WaterfallHighlight(60.0, 100.0, color: Color.PINK.toUInt32()));

        this.dataSet.setYAxisSegmentationColors(highlightList.toArray());

        let dataSetList: ArrayList<IWaterfallDataSet> = ArrayList<IWaterfallDataSet>();
        dataSetList.add(this.dataSet);

        let data: WaterfallData = WaterfallData(dataSetList);
        data.setBarWidth(0.3);
        return data;
    }

    private func getNormalData3(): WaterfallData {
        let values: ArrayList<WaterfallEntry> = ArrayList<WaterfallEntry>();

        values.add(WaterfallEntry(1.0, 10.0, 90.0, icon: this.pixelMap));
        values.add(WaterfallEntry(2.0, 15.0, 80.0, icon: this.pixelMap));
        values.add(WaterfallEntry(3.0, 20.0, 90.0, icon: this.pixelMap));
        values.add(WaterfallEntry(4.0, 5.0, 80.0, icon: this.pixelMap));
        values.add(WaterfallEntry(5.0, 5.0, 50.0, icon: this.pixelMap));
        values.add(WaterfallEntry(6.0, 45.0, 80.0, icon: this.pixelMap));
        values.add(WaterfallEntry(7.0, 60.0, 70.0, icon: this.pixelMap));

        this.dataSet = WaterfallDataSet(values, "DataSet")
        this.dataSet.setHighLightColor(Color.GRAY.toUInt32());
        this.dataSet.setDrawIcons(true);
        this.dataSet.setDrawIcons(this.isDrawIcons);
        this.dataSet.setColorByColor(Color.PINK.toUInt32());
        this.dataSet.setValueTextSize(10.0)
        // 根据Y刻度范围设置颜色
        let highlightList: ArrayList<WaterfallHighlight> = ArrayList<WaterfallHighlight>();
        highlightList.add(WaterfallHighlight(0.0, 40.0, color: 0xcddc39));
        highlightList.add(WaterfallHighlight(40.0, 60.0, color: 0x00bcd4));
        highlightList.add(WaterfallHighlight(60.0, 100.0, color: 0xff9800));
        this.dataSet.setYAxisSegmentationColors(highlightList.toArray());
        // 最高点最低点高亮时颜色设置
        this.dataSet.setEnableMaxOrMinHighlightColor(true);
        this.dataSet.setMaxyHighlightColor(Color.BROWN.toUInt32());
        this.dataSet.setMinyHighlightColor(Color.YELLOW.toUInt32());
        let dataSetList: ArrayList<IWaterfallDataSet> = ArrayList<IWaterfallDataSet>();
        dataSetList.add(this.dataSet);

        let data: WaterfallData = WaterfallData(dataSetList);
        data.setBarWidth(0.3);
        return data;
    }

    private func getNormalData4(): WaterfallData {
        let values: ArrayList<WaterfallEntry> =  ArrayList<WaterfallEntry>();
        let h9 = WaterfallHighlight(-30.0, -15.0, color: Color.BLUE.toUInt32())
        let h5 = WaterfallHighlight(-15.0, 15.0, color: Color.RED.toUInt32())
        let h6 = WaterfallHighlight(15.0, 20.0, color: Color.PINK.toUInt32())
        let h1 = WaterfallHighlight(20.0, 30.0, color: Color.RED.toUInt32());
        let h7 = WaterfallHighlight(30.0, 45.0, color: Color.GREEN.toUInt32());
        let h10 = WaterfallHighlight(45.0, 60.0, color: Color.ORANGE.toUInt32());

        let h2 = WaterfallHighlight(30.0, 40.0, color: Color.PINK.toUInt32());
        let h3 = WaterfallHighlight(40.0, 60.0, color:  Color.GREEN.toUInt32());
        let h4 = WaterfallHighlight(60.0, 70.0, color: Color.RED.toUInt32());

        values.add( WaterfallEntry(1.0, -30.0, 60.0,   highlights:[h9, h5, h6, h1, h7, h10]));
        values.add( WaterfallEntry(4.0, 5.0, 95.0,  highlights: [h2, h3, h4]));
        values.add( WaterfallEntry(6.0, 45.0, 80.0,  highlights:[ h2, h3]));

        this.dataSet =  WaterfallDataSet(values, 'DataSet');
        this.dataSet.setDrawIcons(false);
        this.dataSet.setColorByColor(Color.BROWN.toUInt32());
        this.dataSet.setValueTextSize(10.0)

        let dataSetList: ArrayList<IWaterfallDataSet> =  ArrayList<IWaterfallDataSet>();
        dataSetList.add(this.dataSet);

        let data: WaterfallData =  WaterfallData(dataSetList);
        data.setBarWidth(0.3);
        return data;
    }

    func build() {
        Column() {
            Column() {
                WaterfallChart(model: this.model)
            }
            .width(100.percent)
            .height(70.percent)
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
            }.alignSelf(ItemAlign.Center)
            Row() {
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
                Row() {
                    Text("测试数据: ")
                    Radio(value: "test", group: "dataType").checked(false).onChange(
                        {
                        isChecked: Bool => if (isChecked) {
                            this.data = this.getNormalData4()
                            this.model.getAxisLeft()().setAxisMinimum(-30.0);
                            this.model.setData(this.data);
                        }
                    })
                }
            }
        }
    }
}

class CustomFormatter <: IAxisValueFormatter {
    public func getFormattedValue(value: Float64, axis: AxisBase): String {
        let str = value.format(".0").split(".")
        return "${str[0]}%";
    }
}
