/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package ohos_app_cangjie_entry

import ohos.state_macro_manage.*
import ohos.state_manage.*

import cj_res_entry.app

import tpc.UIKit.*

import std.time.Duration
import std.collection.ArrayList

import ohos_app_cangjie_entry.pageconfig.*
import ohos_app_cangjie_entry.scrollingCharts.*
import ohos_app_cangjie_entry.piePage.*
import ohos_app_cangjie_entry.barPage.*
import ohos_app_cangjie_entry.scatterPage.*
import ohos_app_cangjie_entry.candlePage.*
import ohos_app_cangjie_entry.radarPage.*
import ohos_app_cangjie_entry.eventMoreLineCharts.*
import ohos_app_cangjie_entry.readmeTest.*
import ohos_app_cangjie_entry.readmeTest.*
import ohos_app_cangjie_entry.linePage.*
import ohos_app_cangjie_entry.combinedPage.*
import ohos_app_cangjie_entry.bubblePage.*
import ohos_app_cangjie_entry.combinedPage.*

@HybridComponentEntry
@Component
class Index {
    private let title: String = "chart Example"
    var scroller: Scroller = Scroller()
     @State
    var pageItemArr: ArrayList<ContentItem> = ContentItemData.getData()

    var routerStack: NavPathStack = NavPathStack()

    @Builder
    func pageMap(name: String) {

        if(name == "LineChartPage") {
            LineChartPage()
        } else if(name == "MultiplePage" ){
            MultiplePage()
        } else if(name == "LineChartNotAxisConfigPage" ){
            LineChartNotAxisConfigPage()
        } else if(name == "DualAxisPage" ){
            DualAxisPage()
        } else if(name == "InvertedAxisPage" ){
            InvertedAxisPage()
        } else if(name == "FilledAxisPage" ){
            FilledAxisPage()
        } else if(name == "ColorfulPage" ){
            ColorfulPage()
        } else if(name == "ScrollBarChartPage" ){
            ScrollBarChartPage()
        } else if(name == "ScrollBarChartPage2" ){
            ScrollBarChartPage2()
        } else if(name == "BarChartMultiplePage" ){
            BarChartMultiplePage()
        } else if(name == "CustomGridLineChartPage" ){
            CustomGridLineChartPage()
        } else if(name == "HorizontalBarChartPage" ){
            HorizontalBarChartPage()
        } else if(name == "BarChartNegativePage" ){
            BarChartNegativePage()
        } else if(name == "HorizontalBarNegativeChartPage" ){
            HorizontalBarNegativeChartPage()
        } else if(name == "SineBarChartPage" ){
            SineBarChartPage()
        } else if(name == "StackedBarChartPage" ){
            StackedBarChartPage()
        } else if(name == "StackedNegativePage" ){
            StackedNegativePage()
        } else if(name == "PieChartPage" ){
            PieChartPage()
        } else if(name == "HalfPieChartPage" ){
            HalfPieChartPage()
        }else if(name == "PiePolylineChartPage" ){
            PiePolylineChartPage()
        }else if(name == "CombinedChartPage" ){
            CombinedChartPage()
        }else if(name == "ScatterChartPage" ){
            ScatterChartPage()
        }else if(name == "BubbleChartPage" ){
            BubbleChartPage()
        }else if(name == "CandlestickChartPage" ){
            CandlestickChartPage()
        }else if(name == "RadarChartPage" ){
            RadarChartPage()
        }else if(name == "ListViewMultiChartPage" ){
            ListViewMultiChartPage()
        }else if(name == "ViewPagerPage"){
            ViewPagerPage()
        }else if(name == "ManyBarChartsPage" ){
            ManyBarChartsPage()
        }else if(name == "TallBarChartPage" ){
            TallBarChartPage()
        }else if(name == "DynamicPage" ){
            DynamicPage()
        }else if(name == "HourlyPage" ){
            HourlyPage()
        }else if (name == "BarChartPageReadme") {
            BarChartPageReadme()
        } else if (name == "BubbleChartPageReadme") {
            BubbleChartPageReadme()
        } else if (name == "CandleChartPageReadme") {
            CandleChartPageReadme()
        } else if (name == "CombinedChartPageReadme") {
            CombinedChartPageReadme()
        } else if (name == "LineChartNotAxisConfigPageReadme") {
            LineChartNotAxisConfigPageReadme()
        } else if (name == "PieChartPageReadme") {
            PieChartPageReadme()
        } else if (name == "RadarChartPageReadme") {
            RadarChartPageReadme()
        } else if (name == "ScatterChartPageReadme") {
            ScatterChartPageReadme()
        } else if (name == "WaterfallChartPageReadme") {
            WaterfallChartPageReadme()
        } else {

        }
    }

    public func build() {
        Navigation(routerStack) {
            Row {
                Column {
                    Scroll(this.scroller) {
                        Column() {
                            ForEach(this.pageItemArr,
                                itemGeneratorFunc: {
                                item: ContentItem, _: Int64 => if (item.getIsSection()) {
                                    ItemTitle(itemData: item)
                                } else {
                                    Flex() {
                                        Item(itemData: item);
                                    }.onClick {
                                        e => routerStack.pushPath(NavPathInfo(name: item.getPagePath(), param: ""))
                                    }
                                }
                            })
                        }.width(100.percent).padding(bottom: 80)
                    }.height(100.percent).scrollable(ScrollDirection.Vertical).scrollBarWidth(0).backgroundColor(
                        Color.WHITE)
                }.width(100.percent)
            }.height(100.percent)
         }.navDestination(bind<String>(pageMap, this))
    }
}
@Component
class ItemTitle {
    @State
    var itemData: ContentItem = ContentItem("title");
    @State
    var backGroundTitle: Color = Color.WHITE

    func build() {
        Column() {
            Text(this.itemData.getName()).fontSize(21).padding(16).fontColor(Color.GRAY)
            Blank().width(100.percent).height(1).color(0xdddddd)
        }.backgroundColor(this.backGroundTitle)
    }
}

@Component
class Item {
    @State
    var itemData: ContentItem = ContentItem("title");
    @State
    var backGround: Color = Color.WHITE

    func build() {
        Column() {
            Text(this.itemData.getName()).fontSize(16).fontColor(Color.BLACK).margin(left: 4).padding(8).alignSelf(
                ItemAlign.Start).width(100.percent)
            Text(this.itemData.getDesc()).fontSize(12).fontColor(Color.GRAY).margin(left: 4).padding(top: 0, right: 8,
                bottom: 8, left: 8).alignSelf(ItemAlign.Start).width(100.percent)
            Blank().width(100.percent).height(1).backgroundColor(0xdddddd)
        }.backgroundColor(this.backGround)
    }
}