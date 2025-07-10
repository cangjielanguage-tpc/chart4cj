/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package ohos_app_cangjie_entry.pageconfig

import std.collection.*

public class ContentItemData {
    private static var itemData: ArrayList<ContentItem> = ArrayList<ContentItem>()

    public static func getData(): ArrayList<ContentItem> {
        if (ContentItemData.itemData.size > 0) {
            return ContentItemData.itemData
        }

        return ContentItemData.addData()
    }

    /**
     * 添加页面跳转路径
     */
    public static func addData(): ArrayList<ContentItem> {
        //Line Charts
        ContentItemData.itemData.add(ContentItem("Line Charts"))

        ContentItemData.itemData.add(ContentItem("Basic  ", d: "Simple line chart.", pagePath: "LineChartPage"))
        ContentItemData.itemData.add(
            ContentItem("Multiple  ", d: "Show multiple data sets.", pagePath: "MultiplePage"))
        ContentItemData.itemData.add(
            ContentItem("No Axis Config ", d: "No axis config line chart.", pagePath: "LineChartNotAxisConfigPage"))
        ContentItemData.itemData.add(
            ContentItem("Dual Axis  ", d: "Line chart with dual y-axes.", pagePath: "DualAxisPage"))
        ContentItemData.itemData.add(
            ContentItem("Inverted Axis  ", d: "Inverted y-axis.", pagePath: "InvertedAxisPage"))
        ContentItemData.itemData.add(
            ContentItem("Filled", d: "Colored area between two lines.", pagePath: "FilledAxisPage"))
        ContentItemData.itemData.add(
            ContentItem("Colorful", d: "Colorful line chart.", pagePath: "ColorfulPage"))

        //Bar Charts
        ContentItemData.itemData.add(ContentItem("Bar Charts"))

        ContentItemData.itemData.add(ContentItem("Basic ", d: "Simple bar chart.", pagePath: "ScrollBarChartPage"))
        ContentItemData.itemData.add(
            ContentItem("Basic Extension ", d: "Simple bar chart.", pagePath: "ScrollBarChartPage2"))
        ContentItemData.itemData.add(
            ContentItem("Multiple", d: "Show multiple data sets.", pagePath: "BarChartMultiplePage"))
        ContentItemData.itemData.add(
            ContentItem("CustomGridLine ", d: "CustomGridLine", pagePath: "CustomGridLineChartPage"))
        ContentItemData.itemData.add(
            ContentItem("Horizontal", d: "Render bar chart horizontally.", pagePath: "HorizontalBarChartPage"))
        ContentItemData.itemData.add(
            ContentItem("Negative ", d: "Positive and negative values with unique colors.",
            pagePath: "BarChartNegativePage"))
        ContentItemData.itemData.add(
            ContentItem("Negative Horizontal",
            d: "demonstrates how to create a HorizontalBarChart with positive and negative values.",
            pagePath: "HorizontalBarNegativeChartPage"))
        ContentItemData.itemData.add(
            ContentItem("Sine", d: "Sine function in bar chart format.", pagePath: "SineBarChartPage"))
        ContentItemData.itemData.add(
            ContentItem("Stacked", d: "Stacked bar chart", pagePath: "StackedBarChartPage"))
        ContentItemData.itemData.add(
            ContentItem("Stacked 2", d: "Stacked bar chart with negative values", pagePath: "StackedNegativePage"))

        //Pie Charts
        ContentItemData.itemData.add(ContentItem("Pie Charts"))

        ContentItemData.itemData.add(ContentItem("Basic", d: "Simple pie1 chart.", pagePath: "PieChartPage"))
        ContentItemData.itemData.add(ContentItem("Value Lines", d: "180° (half) pie chart.", pagePath: "HalfPieChartPage"))
        ContentItemData.itemData.add(ContentItem("Half Pie", d: "Stylish lines drawn outward from slices.", pagePath: "PiePolylineChartPage"))

        //Other Charts
        ContentItemData.itemData.add(ContentItem("Other Charts"))

        ContentItemData.itemData.add(
            ContentItem("Combined Chart", d: "Bar and line chart together.", pagePath: "CombinedChartPage"))
        ContentItemData.itemData.add(
            ContentItem("Scatter Plot", d: "Simple scatter plot.", pagePath: "ScatterChartPage"))
        ContentItemData.itemData.add(
            ContentItem("Bubble Chart", d: "Simple bubble chart.", pagePath: "BubbleChartPage"))
        ContentItemData.itemData.add(
            ContentItem("Candlestick", d: "Simple financial chart.", pagePath: "CandlestickChartPage"))
        ContentItemData.itemData.add(ContentItem("Radar Chart", d: "Simple web chart.", pagePath: "RadarChartPage"))

         //Scrolling Charts
        ContentItemData.itemData.add(ContentItem("Scrolling Charts"))

        ContentItemData.itemData.add(
            ContentItem("Multiple   ", d: "Various types of charts as fragments.", pagePath: "ListViewMultiChartPage"))
         ContentItemData.itemData.add(
            ContentItem("View Pager", d: "Swipe through different charts.", pagePath: "ViewPagerPage"))
        ContentItemData.itemData.add(
            ContentItem("Many Bar Charts", d: "More bars than your screen can handle!", pagePath: "ManyBarChartsPage"))
        ContentItemData.itemData.add(
            ContentItem("Tall Bar Chart", d: "Bars bigger than your screen!", pagePath: "TallBarChartPage"))

        //Even More Line Charts
        ContentItemData.itemData.add(ContentItem("Even More Line Charts"))

        ContentItemData.itemData.add(
            ContentItem("Dynamic", d: "Build a line chart by pushing points and sets.", pagePath: "DynamicPage"))
         ContentItemData.itemData.add(
            ContentItem("Hourly", d: "Uses the current time to push a data point for each hour.", pagePath: "HourlyPage"))





        //readme
        ContentItemData.itemData.add(ContentItem("Readme Charts"))

        ContentItemData.itemData.add(ContentItem("Bar chart", d: "Simple plot.", pagePath: "BarChartPageReadme"))
        ContentItemData.itemData.add(
            ContentItem("Bubble Chart", d: "Simple chart.", pagePath: "BubbleChartPageReadme"))
        ContentItemData.itemData.add(
            ContentItem("Line Chart", d: "Simple chart.", pagePath: "LineChartNotAxisConfigPageReadme"))
        ContentItemData.itemData.add(ContentItem("Pie Chart", d: "Simple chart.", pagePath: "PieChartPageReadme"))
        ContentItemData.itemData.add(
            ContentItem("Waterfall Chart", d: "Simple chart.", pagePath: "WaterfallChartPageReadme"))
        ContentItemData.itemData.add(
            ContentItem("Scatter Chart", d: "Simple chart.", pagePath: "ScatterChartPageReadme"))

        ContentItemData.itemData.add(
            ContentItem("Candle Chart", d: "Simple chart.", pagePath: "CandleChartPageReadme"))

        ContentItemData.itemData.add(
            ContentItem("Radar Chart", d: "Simple chart.", pagePath: "RadarChartPageReadme"))
        ContentItemData.itemData.add(
            ContentItem("Combined Chart", d: "Combined chart.", pagePath: "CombinedChartPageReadme"))


        return ContentItemData.itemData
    }
}
