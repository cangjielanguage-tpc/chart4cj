<div align="center">
<h1>Chart4Ohos</h1>
</div>

<p align="center">
<img alt="" src="https://img.shields.io/badge/release-v0.0.1-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/build-pass-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjc-v0.51.4-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjcov-0%25-red" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/project-open-brightgreen" style="display: inline-block;" />
</p>

## 介绍

chart4Ohos 是一个包含各种类型图表的图表库，主要用于业务数据汇总，例如销售数据走势图，股价走势图等场景中使用，方便开发者快速实现图表UI，chart4Ohos主要包括线形图、柱状图、饼状图、蜡烛图、气泡图、雷达图、瀑布图等自定义图表库。

### 特性

- 支持饼状图
- 支持动画显示
- 支持图例
- 支持柱状图（水平、垂直）
- 支持气泡图
- 支持瀑布图

## 软件架构

### 源码目录

```shell
├─doc                         // API 文档
├─entry                       // UI模块
│  └─src
│      └─main
│          ├─cangjie          // UI测试代码 
│          │  └─src
│          └─resources        // UI测试资源 
├─mpchart                     // 核心代码模块      
│  └─src
│      └─main
│          ├─cangjie          // 核心代码
│          │  └─src
│          └─resources
```
### 接口说明

主要类和函数接口说明详见 [API](doc/feature_api.md)

## 使用说明

### 编译构建

DevEco Studio 编译构建

### 功能示例

#### 饼状图

```cangjie
from ohos import base.LengthProp
from ohos import component.Column
from ohos import component.Row
from ohos import component.Button
from ohos import component.Text
from ohos import component.CustomView
from ohos import component.CJEntry
from ohos import component.loadNativeView
from ohos import state_manage.SubscriberManager
from ohos import state_manage.ObservedProperty
from ohos import state_macro_manage.Entry
from ohos import state_macro_manage.Component
from ohos import state_macro_manage.State
from ohos import state_macro_manage.r
from ohos import base.*
from ohos import component.*

from std import collection.{ArrayList}
from std import math.*
from std import random.*
from mpchart import core.pie.*
from mpchart import core.utils.*
from mpchart import core.components.*


@Entry
@Component
class PieChartPage {
    //标题栏标题
    private var title: String = "PieChart"

    // 图表数据初始化
    // Step1:必须：初始化图表配置构建类
    private var model: PieChartModel = PieChartModel.build()
    protected let parties: Array<String> = ["Party A", "Party B", "Party C", "Party D", "Party E", "Party F", "Party G",
    "Party H", "Party I", "Party J", "Party K", "Party L", "Party M", "Party N", "Party O", "Party P", "Party Q",
    "Party R", "Party S", "Party T", "Party U", "Party V", "Party W", "Party X", "Party Y", "Party Z"]

    var pieData: PieData = PieData()

    func aboutToAppear(): PieChartModel {
        // Step2：配置图表的特定样式，各部件间没有先后之分
        let l: ?Legend = this.model.getLegend()
        if (let Some(v) <- l) {
            v.setEnabled(true)
            v.setOrientation(LegendOrientation.VERTICAL)
            v.setVerticalAlignment(LegendVerticalAlignment.BOTTOM)
            v.setHorizontalAlignment(LegendHorizontalAlignment.LEFT)
        }

        this.model.animateX(1000, easing: "Sharp"); // 启用X轴动画效果，动画持续时间为1000毫秒
        this.model.setUsePercentValues(true);  // 使用百分比值
        this.model.getDescription().setEnabled(false)  // 禁用描述信息
        this.model.setExtraOffsets(5.0, 10.0, 5.0, 5.0); // 设置额外偏移量

        this.model.setDragDecelerationFrictionCoef(0.95); // 设置拖动减速摩擦系数

        this.model.setCenterText("mpchart"); // 设置中心文本
        this.model.setCenterTextSize(22.0) // 设置中心文本大小

        this.model.setDrawHoleEnabled(true); // 启用绘制中心孔
        this.model.setHoleColor(0xff000000);  // 设置中心孔颜色

        this.model.setTransparentCircleColor(0xff000000); // 设置透明圆环颜色
        this.model.setTransparentCircleAlpha(110.0); // 设置透明圆环透明度

        this.model.setHoleRadius(58.0); // 设置中心孔半径
        this.model.setTransparentCircleRadius(61.0);  // 设置透明圆环半径

        this.model.setDrawCenterText(true); // 绘制中心文本

        this.model.setRotationAngle(0.0);  // 设置旋转角度
     
        // 通过触摸启用图表的旋转
        this.model.setRotationEnabled(true);
        this.model.setHighlightPerTapEnabled(true); // 启用点击高亮效果

        this.setData(4, 10);  // 设置图表数据
        return this.model
    }

    //初始化饼状图数据
    private func setData(count: Int64, range: Int64): Unit {
        var entries: ArrayList<PiEntry> = ArrayList<PiEntry>()
        for (i in 0..count) {
            entries.append(
                PiEntry((Random().nextFloat64() * Float64 (range)) + Float64 (range) / 5.0, this.parties[i % this.parties.size]))
        }

        // 创建饼状图数据集对象，设置数据项和数据集名称
        var dataSet: PieDataSet = PieDataSet(entries, "Election Results")
        // 设置是否绘制数据项图标
        dataSet.setDrawIcons(false)
        // 设置数据项之间的间隙
        dataSet.setSliceSpace(1.0)
        // 设置数据项图标的偏移量
        dataSet.setIconsOffset(MPPointF(0.0, 40.0))
        // 设置选中时数据项的偏移距离
        dataSet.setSelectionShift(5.0)
        // 设置数据项文本颜色
        dataSet.setValueTextColor(UInt32(0XFFFFFF))

        // 添加颜色
        var colors: ArrayList<UInt32> = ArrayList<UInt32>()
        for (i in 0..ColorTemplate.COLORFUL_COLORS.size) {
            colors.append(UInt32(ColorTemplate.COLORFUL_COLORS[i]))
        }

        for (i in 0..ColorTemplate.VORDIPLOM_COLORS.size) {
            colors.append(UInt32(ColorTemplate.VORDIPLOM_COLORS[i]))
        }

        for (i in 0..ColorTemplate.JOYFUL_COLORS.size) {
            colors.append(UInt32(ColorTemplate.JOYFUL_COLORS[i]))
        }

        for (i in 0..ColorTemplate.LIBERTY_COLORS.size) {
            colors.append(UInt32(ColorTemplate.LIBERTY_COLORS[i]))
        }
        for (i in 0..ColorTemplate.PASTEL_COLORS.size) {
            colors.append(UInt32(ColorTemplate.PASTEL_COLORS[i]))
        }
        colors.append(UInt32(ColorTemplate.getHoloBlue()))
        dataSet.setColorsByList(colors)

        // 生成图表数据
        let data: PieData = PieData(dataSet)
        // 将数据与图表配置类绑定
        this.model.setData(data)
    }

func render() {
        Column {
            //图表显示
            // 可通过dataSet.notifyDataSetChanged();来触发数据更新，
            // 可通过this.model.notifyDataSetChanged();来触发坐标轴数据更新，
            // 可通过this.model.invalidate();来触发绘制更新。
            
            PieChart(model: aboutToAppear())
        }.width(100.percent).height(70.percent).backgroundColor(Color.WHITE)
    }
}
```

#### 柱状图

```cangjie
@Entry
@Component
class BarChartMultiplePage {
    private var title: String = "Negative"
    private var model: BarChartModel = BarChartModel.build()
    private var leftAxis: ?YAxis = Option<YAxis>.None
    private var rightAxis: ?YAxis = Option<YAxis>.None
    private var xAxis: ?XAxis = Option<XAxis>.None
    private var barData: BarData = BarData()
    private var normalMarker: MarkerView = MarkerView()

    func aboutToAppear(): BarChartModel {
        let description: Description = this.model.getDescription()
        description.setEnabled(false)

        let l: ?Legend = this.model.getLegend()
        if (let Some(v) <- l) {
            v.setEnabled(true)
            v.setOrientation(LegendOrientation.VERTICAL)
            v.setVerticalAlignment(LegendVerticalAlignment.TOP)
            v.setHorizontalAlignment(LegendHorizontalAlignment.RIGHT)
            v.setDrawInside(true)
        }

        // if more than 40 entries are displayed in the this.model, no values will be drawn
        this.model.setMaxVisibleValueCount(60)

        // scaling can now only be done on x- and y-axis separately
        this.model.setPinchZoom(false)

        this.model.setDrawGridBackground(false)
        this.model.setGridBackgroundColor(0x500000ff)
        this.model.setDrawBarShadow(false)

        this.model.setDrawValueAboveBar(true)
        this.model.setHighlightFullBarEnabled(false)

        this.leftAxis = this.model.getAxisLeft()
        if (let Some(leftaxis) <- this.leftAxis) {
            leftaxis.setAxisMinimum(0.0)
            leftaxis.setDrawLimitLinesBehindData(false)
            leftaxis.setSpaceTop(30.0)
            leftaxis.enableGridDashedLine(10, 10, 0)
        }

        this.rightAxis = this.model.getAxisRight()
        if (let Some(rightaxis) <- this.rightAxis) {
            rightaxis.setEnabled(false)
            rightaxis.setDrawGridLines(false)
            rightaxis.setLabelCount(6, false)
            rightaxis.setSpaceTop(11.0)
        }

        this.xAxis = this.model.getXAxis()
        if (let Some(xaxis) <- this.xAxis) {
            xaxis.setLabelCount(5, false)
            xaxis.setPosition(XAxisPosition.BOTTOM)
        }

        this.normalMarker = MarkerView()
        this.model.setMarker(this.normalMarker)

        if (this.xAxis.isSome() && this.leftAxis.isSome()) {
            this.setData(5, 110)
        }

        return this.model
    }

    private func setData(count: Int64, range: Int64): Unit {
        let groupSpace: Float64 = 0.08
        let barSpace: Float64 = 0.03
        let barWidth: Float64 = 0.2

        let startYear: Int64 = 1980
        let endYear: Int64 = startYear + count

        let values1: ArrayList<BarEntry> = ArrayList<BarEntry>()
        let values2: ArrayList<BarEntry> = ArrayList<BarEntry>()
        let values3: ArrayList<BarEntry> = ArrayList<BarEntry>()
        let values4: ArrayList<BarEntry> = ArrayList<BarEntry>()

        let randomMultiplier: Int64 = range

        for (i in startYear..endYear) {
            values1.append(BarEntry(Float64(i), (Random().nextFloat64() * Float64(randomMultiplier))))
            values2.append(BarEntry(Float64(i), (Random().nextFloat64() * Float64(randomMultiplier))))
            values3.append(BarEntry(Float64(i), (Random().nextFloat64() * Float64(randomMultiplier))))
            values4.append(BarEntry(Float64(i), (Random().nextFloat64() * Float64(randomMultiplier))))
        }

        var set1: ?BarDataSet
        var set2: ?BarDataSet
        var set3: ?BarDataSet
        var set4: ?BarDataSet

        if (this.model.getBarData().isSome() && this.model.getBarData()().getDataSetCount() > 0) {
            set1 = this.model.getBarData()().getDataSetByIndex(0) as BarDataSet
            set2 = this.model.getBarData()().getDataSetByIndex(1) as BarDataSet
            set3 = this.model.getBarData()().getDataSetByIndex(2) as BarDataSet
            set4 = this.model.getBarData()().getDataSetByIndex(3) as BarDataSet
            set1().setEntries(values1)
            set2().setEntries(values2)
            set3().setEntries(values3)
            set4().setEntries(values4)
            this.model.getBarData()().notifyDataChanged()
            this.model.notifyDataSetChanged()
        } else {
            set1 = BarDataSet(values1, "Company A")
            set1().setColorsByArr([UInt32(ChartColor.rgb(104, 241, 175))])
            set2 = BarDataSet(values2, "Company B")
            set2().setColorsByArr([UInt32(ChartColor.rgb(164, 228, 251))])
            set3 = BarDataSet(values3, "Company C")
            set3().setColorsByArr([UInt32(ChartColor.rgb(242, 247, 158))])
            set4 = BarDataSet(values4, "Company D")
            set4().setColorsByArr([UInt32(ChartColor.rgb(255, 102, 0))])

            let dataSets: ArrayList<IBarDataSet> = ArrayList<IBarDataSet>()
            dataSets.append(set1())
            dataSets.append(set2())
            dataSets.append(set3())
            dataSets.append(set4())

            let data: BarData = BarData(dataSets)
            this.model.setData(data)
        }

        this.model.getBarData()().setBarWidth(barWidth)
        this.xAxis().setAxisMinimum(Float64(startYear))
        this.xAxis().setAxisMaximum(
            Float64(startYear) + this.model.getBarData()().getGroupWidth(groupSpace, barSpace) * Float64(count))
        this.model.groupBars(Float64(startYear), groupSpace, barSpace)
        this.model.invalidate()
    }

    func render() {
        Column {
            Text(this.title).fontSize(21).fontColor(Color.WHITE).fontWeight(FontWeight.W600).layoutWeight(1).maxLines(1)
            BarChart(model: aboutToAppear())
        }.width(100.percent).height(70.percent).backgroundColor(Color.WHITE)
    }
}

```

#### 气泡图

```cangjie
@Entry
@Component
class BubbleChartPage {
    private var menuItemArr: Array<String> = ["Animate X", "Animate Y", "Animate XY"]
    private var title: String = "BubbleChartPage"
    private var model: BubbleChartModel = BubbleChartModel.build()

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
        let values: ArrayList<BubbleEntry> = ArrayList<BubbleEntry>()
        for (i in start..20) {
            let val = (Random().nextFloat64() * 41.0)

            if (Random().nextFloat64() * 100.0 < 25.0) {
                values.append(BubbleEntry(Float64(i), val))
            } else {
                values.append(BubbleEntry(Float64(i), val))
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

    private func setData(count: Int64, range: Float64): Unit {
        let values1 = ArrayList<BubbleEntry>()
        let values2 = ArrayList<BubbleEntry>()
        let values3 = ArrayList<BubbleEntry>()

        for (i in 0..count) {
            values1.append(BubbleEntry(Float64(i), Random().nextFloat64() * range, size: Random().nextFloat64() * range)
            )
            values2.append(BubbleEntry(Float64(i), Random().nextFloat64() * range, size: Random().nextFloat64() * range)
            )
            values3.append(BubbleEntry(Float64(i), Random().nextFloat64() * range, size: Random().nextFloat64() * range)
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

    func render() {
        Column() {
            Column() {
                BubbleChart(model: aboutToAppear())
            }
        }
    }
}

```

#### 瀑布图

```cangjie
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

    func aboutToAppear(): WaterfallChartModel {

        let description: ?Description = this.model.getDescription()
        if (let Some(des) <- description) {
            des.setEnabled(false);
        }

        let l: ?Legend = this.model.getLegend();
        if (let Some(legend) <- l) {
            legend.setEnabled(false);
        }
        
        this.model.setMaxVisibleValueCount(40);
        
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
        
        this.leftAxis = this.model.getAxisLeft()
        if (let Some(laxis) <- this.leftAxis) {
            laxis.setAxisMinimum(0.0);
            laxis.setDrawLimitLinesBehindData(false);
            laxis.setValueFormatter(CustomFormatter());
            
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

    func render() {
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
```

## 约束与限制

在下述版本验证通过：

    DevEco Studio: 5.0.3.400 
    cangjie SDK: 0.5.5
    Cangjie support Plugin: 0.5.5

## 开源协议

Apache License 2.0

## 参与贡献

欢迎给我们提交PR，欢迎给我们提交Issue，欢迎参与任何形式的贡献。
