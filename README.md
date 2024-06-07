<div align="center">
<h1>Chart4Ohos</h1>
</div>

<p align="center">
<img alt="" src="https://img.shields.io/badge/release-v0.0.1-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/build-pass-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjc-v0.51.3-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjcov-0%25-red" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/project-open-brightgreen" style="display: inline-block;" />
</p>

## 介绍

chart4Ohos 是一个包含各种类型图表的图表库，主要用于业务数据汇总，例如销售数据走势图，股价走势图等场景中使用，方便开发者快速实现图表UI，chart4Ohos主要包括线形图、柱状图、饼状图、蜡烛图、气泡图、雷达图、瀑布图等自定义图表库。

### 特性

- 支持饼状图
- 支持动画显示
- 支持图例

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
    private var model: PieChartModel = PieChartModel()
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

## 约束与限制

在下述版本验证通过：

DevEco Studio: 5.0.3.300, cangjie SDK 0.4.5

## 开源协议

Apache License 2.0

## 参与贡献

欢迎给我们提交PR，欢迎给我们提交Issue，欢迎参与任何形式的贡献。
