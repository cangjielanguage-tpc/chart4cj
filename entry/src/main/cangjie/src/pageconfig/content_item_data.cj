/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
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
        ContentItemData.itemData.append(ContentItem("Line Charts"))

        ContentItemData.itemData.append(ContentItem("Basic  ", d: "Simple line chart.", pagePath: "LineChartPage"))
        ContentItemData.itemData.append(
            ContentItem("Multiple  ", d: "Show multiple data sets.", pagePath: "MultiplePage"))
        ContentItemData.itemData.append(
            ContentItem("No Axis Config ", d: "No axis config line chart.", pagePath: "LineChartNotAxisConfigPage"))
        ContentItemData.itemData.append(
            ContentItem("Dual Axis  ", d: "Line chart with dual y-axes.", pagePath: "DualAxisPage"))
        ContentItemData.itemData.append(
            ContentItem("Inverted Axis  ", d: "Inverted y-axis.", pagePath: "InvertedAxisPage"))
        ContentItemData.itemData.append(
            ContentItem("Filled", d: "Colored area between two lines.", pagePath: "FilledAxisPage"))
        ContentItemData.itemData.append(
            ContentItem("Colorful", d: "Colorful line chart.", pagePath: "ColorfulPage"))

        //Bar Charts
        ContentItemData.itemData.append(ContentItem("Bar Charts"))

        ContentItemData.itemData.append(ContentItem("Basic ", d: "Simple bar chart.", pagePath: "ScrollBarChartPage"))
        ContentItemData.itemData.append(
            ContentItem("Basic Extension ", d: "Simple bar chart.", pagePath: "ScrollBarChartPage2"))
        ContentItemData.itemData.append(
            ContentItem("Multiple", d: "Show multiple data sets.", pagePath: "BarChartMultiplePage"))
        ContentItemData.itemData.append(
            ContentItem("CustomGridLine ", d: "CustomGridLine", pagePath: "CustomGridLineChartPage"))
        ContentItemData.itemData.append(
            ContentItem("Horizontal", d: "Render bar chart horizontally.", pagePath: "HorizontalBarChartPage"))
        ContentItemData.itemData.append(
            ContentItem("Negative ", d: "Positive and negative values with unique colors.",
            pagePath: "BarChartNegativePage"))
        ContentItemData.itemData.append(
            ContentItem("Negative Horizontal",
            d: "demonstrates how to create a HorizontalBarChart with positive and negative values.",
            pagePath: "HorizontalBarNegativeChartPage"))
        ContentItemData.itemData.append(
            ContentItem("Sine", d: "Sine function in bar chart format.", pagePath: "SineBarChartPage"))
        ContentItemData.itemData.append(
            ContentItem("Stacked", d: "Stacked bar chart", pagePath: "StackedBarChartPage"))
        ContentItemData.itemData.append(
            ContentItem("Stacked 2", d: "Stacked bar chart with negative values", pagePath: "StackedNegativePage"))

        //Pie Charts
        ContentItemData.itemData.append(ContentItem("Pie Charts"))

        ContentItemData.itemData.append(ContentItem("Basic", d: "Simple pie1 chart.", pagePath: "PieChartPage"))
        ContentItemData.itemData.append(ContentItem("Value Lines", d: "180° (half) pie chart.", pagePath: "HalfPieChartPage"))
        ContentItemData.itemData.append(ContentItem("Half Pie", d: "Stylish lines drawn outward from slices.", pagePath: "PiePolylineChartPage"))

        //Other Charts
        ContentItemData.itemData.append(ContentItem("Other Charts"))

        ContentItemData.itemData.append(
            ContentItem("Combined Chart", d: "Bar and line chart together.", pagePath: "CombinedChartPage"))
        ContentItemData.itemData.append(
            ContentItem("Scatter Plot", d: "Simple scatter plot.", pagePath: "ScatterChartPage"))
        ContentItemData.itemData.append(
            ContentItem("Bubble Chart", d: "Simple bubble chart.", pagePath: "BubbleChartPage"))
        ContentItemData.itemData.append(
            ContentItem("Candlestick", d: "Simple financial chart.", pagePath: "CandlestickChartPage"))
        ContentItemData.itemData.append(ContentItem("Radar Chart", d: "Simple web chart.", pagePath: "RadarChartPage"))

         //Scrolling Charts
        ContentItemData.itemData.append(ContentItem("Scrolling Charts"))

        ContentItemData.itemData.append(
            ContentItem("Multiple   ", d: "Various types of charts as fragments.", pagePath: "ListViewMultiChartPage"))

        //Even More Line Charts
        ContentItemData.itemData.append(ContentItem("Even More Line Charts"))

        ContentItemData.itemData.append(
            ContentItem("Dynamic", d: "Build a line chart by pushing points and sets.", pagePath: "DynamicPage"))


        //readme
        ContentItemData.itemData.append(ContentItem("Readme Charts"))

        ContentItemData.itemData.append(ContentItem("Bar chart", d: "Simple plot.", pagePath: "BarChartPageReadme"))
        ContentItemData.itemData.append(
            ContentItem("Bubble Chart", d: "Simple chart.", pagePath: "BubbleChartPageReadme"))
        ContentItemData.itemData.append(
            ContentItem("Line Chart", d: "Simple chart.", pagePath: "LineChartNotAxisConfigPageReadme"))
        ContentItemData.itemData.append(ContentItem("Pie Chart", d: "Simple chart.", pagePath: "PieChartPageReadme"))
        ContentItemData.itemData.append(
            ContentItem("Waterfall Chart", d: "Simple chart.", pagePath: "WaterfallChartPageReadme"))
        ContentItemData.itemData.append(
            ContentItem("Scatter Chart", d: "Simple chart.", pagePath: "ScatterChartPageReadme"))

        ContentItemData.itemData.append(
            ContentItem("Candle Chart", d: "Simple chart.", pagePath: "CandleChartPageReadme"))

        ContentItemData.itemData.append(
            ContentItem("Radar Chart", d: "Simple chart.", pagePath: "RadarChartPageReadme"))
        ContentItemData.itemData.append(
            ContentItem("Combined Chart", d: "Combined chart.", pagePath: "CombinedChartPageReadme"))


        return ContentItemData.itemData
    }
}
