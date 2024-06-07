# chart4Ohos 特性文档

## 介绍

chart4Ohos 是一个包含各种类型图表的图表库，主要用于业务数据汇总，例如销售数据走势图，股价走势图等场景中使用，方便开发者快速实现图表 UI，chart4Ohos主要包括线形图、柱状图、饼状图、蜡烛图、气泡图、雷达图、瀑布图等自定义图表库。

## 1 生成各种类型的图表，包括：线形图、条形图、饼状图、蜡烛图、气泡图、雷达图、散点图、瀑布图、组合图、自定义图表

### 1.1 饼状图 PieChart

#### 1.1.1 PiEntry Class API Description

饼状图数据结构

```cangjie
public class PiEntry <: EntryOhos {
    
    /*
     * 构造 
     * 
     * 参数 yValue - 比例值
     */
    public init (yValue: Float64)
    
    /*
     * 构造 
     * 
     * 参数 yValue - 比例值
     * 参数 data - 额外数据
     */
    public init (yValue: Float64, data: Any)
    
    /*
     * 构造 
     * 
     * 参数 yValue - 比例值
     * 参数 icon - 图标图像 （cangjie UI ChartPixelMap）
     */
    public init (yValue: Float64, icon: ChartPixelMap)
    
    /*
     * 构造 
     * 
     * 参数 yValue - 比例值
     * 参数 icon - 图标图像 （cangjie UI ChartPixelMap）
     * 参数 data - 数据
     */
    public init (yValue: Float64, icon: ChartPixelMap, data: Any)
    
    /*
     * 构造 
     * 
     * 参数 yValue -  比例值
     * 参数 label - 标签字符
     */
    public init (yValue: Float64, label: String)
    
    /*
     * 构造 
     * 
     * 参数 yValue - 比例值
     * 参数 label - 标签字符
     * 参数 data - 附加数据
     */
    public init (yValue: Float64, label: String, data: Any)
    
    /*
     * 构造 
     * 
     * 参数 yValue -  比例值
     * 参数 label - 标签字符
     * 参数 icon - 图标图像 （cangjie UI ChartPixelMap）
     */
    public init (yValue: Float64, label: String, icon: ChartPixelMap)
    
    /*
     * 构造 
     * 
     * 参数 yValue - 比例值
     * 参数 label - 标签字符
     * 参数 icon - 图标图像 （cangjie UI ChartPixelMap）
     * 参数 data - 数据
     */
    public init (yValue: Float64, label: String, icon: ChartPixelMap, data: Any)
}
```

#### 1.1.2 IPieDataSet interface API Description

```cangjie
public interface  IPieDataSet <: IDataSet<PiEntry> {}

```

#### 1.1.3 PieDataSet Class API Description

饼状图数据集对象

```cangjie
public class PieDataSet<: DataSet<PiEntry>&IPieDataSet {
    
    /*
     * 使用它所表示的给定值(PiEntry)创建新的DataSet对象。此外，还可以指定描述DataSet的标签。
     * 
     * 参数 yVals - PiEntry集合
     * 参数 label - 饼状图描述
     */
    public init (yVals: ArrayList<PiEntry>, label: String)
       
    
    /*
     * 设置 piechart 切片之间留出的空间。默认:0.0 无空间，最大20.0
     * 
     * 参数 spaceDp - 切片之前的空间
     * 返回值 Unit - 
     */
    public func setSliceSpace (spaceDp: Float64): Unit
    
    
    /*
     * 启用后，当最小值小于切片间距本身时，切片间距将为0.0。
     * 
     * 参数 autoDisable - true/false
     * 返回值 Unit - 
     */
    public func setAutomaticallyDisableSliceSpacing (autoDisable: Bool): Unit
    
    
    /*
     * 设置此DataSet的突出显示的piechart切片从图表中心“移位”的距离，默认为12.0
     * 
     * 参数 shift - 距离
     * 返回值 Unit - 
     */
    public func setSelectionShift (shift: Float64): Unit
        
    /*
     * 设置 x 轴值的位置 *
     * 
     * 参数 xValuePosition - ValuePosition
     * 返回值 Unit - 
     */
    public func setXValuePosition (xValuePosition: ValuePosition): Unit
        
    /*
     * 设置 y 轴值的位置 *
     * 
     * 参数 yValuePosition - ValuePosition
     * 返回值 Unit - 
     */
    public func setYValuePosition (yValuePosition: ValuePosition): Unit
        
    /*
     * 设置值引导线颜色
     * 
     * 参数 valueLineColor - 颜色值
     * 返回值 Unit - 
     */
    public func setValueLineColor (valueLineColor: UInt32): Unit
    
    /*
     * 是否设置值引导线的颜色
     * 
     * 参数 enabled - true/false
     * 返回值 Unit - 
     */
    public func setUseValueColorForLine (enabled: Bool): Unit
       
    /*
     * 设置值引导线宽度
     * 
     * 参数 valueLineWidth - 行宽
     * 返回值 Unit - 
     */
    public func setValueLineWidth (valueLineWidth: Float64): Unit
       
    /*
     * 设置超出切片大小的百分比（表示偏移量）*
     * 
     * 参数 valueLinePart1OffsetPercentage - 百分比
     * 返回值 Unit - 
     */
    public func setValueLinePart1OffsetPercentage (valueLinePart1OffsetPercentage: Float64): Unit
        
    /*
     * 设置图表上半部分的长度 *
     * 
     * 参数 valueLinePart1Length - 长度
     * 返回值 Unit - 
     */
    public func setValueLinePart1Length (valueLinePart1Length: Float64): Unit
       
    /*
     * 设置图表下半部分的长度 *
     * 
     * 参数 valueLinePart2Length - 长度
     * 返回值 Unit - 
     */
    public func setValueLinePart2Length (valueLinePart2Length: Float64): Unit
    
    
    /*
     * 设置可变长度
     * 
     * 参数 valueLineVariableLength - true/false
     * 返回值 Unit - 
     */
    public func setValueLineVariableLength (valueLineVariableLength: Bool): Unit
       
    /*
     * 设置高亮显示的扇区颜色
     * 
     * 参数 color - 颜色
     * 返回值 Unit - 
     */
    public func setHighlightColor (color: UInt32): Unit

}
```

#### 1.1.4 BaseDataSet Class API Description

所有 dataSet 基类

```cangjie
public abstract class BaseDataSet<E> <: IDataSet<E> {
        
    /*
     * 设置此DataSet应使用的颜色。一旦 DataSet 表示的条目数大于颜色数组的大小，就会重用颜色。
     * 
     * 参数 colors - 颜色
     * 返回值 Unit - 
     */
    public func setColorsByList (colors: ArrayList<UInt32>): Unit
    
    /*
     * 设置此DataSet应使用的颜色。一旦DataSet表示的条目数大于颜色数组的大小，就会重用颜色。
     * 
     * 参数 colors - 颜色
     * 返回值 Unit - 
     */
    public func setColorsByVariable (colors: Array<UInt32>): Unit
    
    /*
     * 设置此DataSet应使用的颜色。一旦DataSet表示的条目数大于颜色数组的大小，就会重用颜色。
     * 
     * 参数 colors - 颜色
     * 返回值 Unit - 
     */
    public func setColorsByArr (colors: Array<UInt32>): Unit
    
    /*
     * 将新颜色添加到DataSet的颜色数组中。
     * 
     * 参数 color - 颜色
     * 返回值 Unit - 
     */
    public func addColor (color: UInt32): Unit
    
    /*
     * 设置此DataSet应使用的唯一颜色。
     * 
     * 参数 color - 颜色
     * 返回值 Unit - 
     */
    public func setColorByColor (color: UInt32): Unit
    
    /*
     * 设置具有特定alpha值的颜色
     * 
     * 参数 color - 颜色
     * 参数 alpha - 透明度（0.0-1.0）
     * 返回值 Unit - 
     */
    public func setColorByAlpha (color: UInt32, alpha: Float64): Unit
    
    /*
     * 设置具有特定alpha值的颜色组合
     * 
     * 参数 colors - 颜色组
     * 参数 alpha - 透明度（0.0-1.0）
     * 返回值 Unit - 
     */
    public func setColorsByArrAndAlpha (colors: Array<UInt32>, alpha: Float64): Unit
    
    /*
     * 重置此数据集的所有颜色并重新创建颜色数组。
     * 
     * 返回值 Unit - 
     */
    public func resetColors (): Unit
    
    /*
     * 设置图表标签
     * 
     * 参数 label - 标签
     * 返回值 Unit - 
     */
    public func setLabel (label: String): Unit

    /*
     * 设置是否高亮显示
     * 
     * 参数 enabled - true/false
     * 返回值 Unit - 
     */
    public func setHighlightEnabled (enabled: Bool): Unit
    
    
    /*
     * 设置值格式
     * 
     * 参数 f - IValueFormatter
     * 返回值 Unit - 
     */
    public func setValueFormatter (f: IValueFormatter): Unit
    
    /*
     * 设置文本颜色
     * 
     * 参数 color - 
     * 返回值 Unit - 
     */
    public func setValueTextColor (color: UInt32): Unit
    
    /*
     * 设置数据文本颜色
     * 
     * 参数 colors - 颜色
     * 返回值 Unit - 
     */
    public func setValueTextColors (colors: ArrayList<UInt32>): Unit
    
    /*
     * 设置设置数据文本字体样式
     * 
     * 参数 tf - 字体样式
     * 返回值 Unit - 
     */
    public func setValueTypeface (tf: FontFamily): Unit
    
    /*
     * 设置数据文本大小
     * 
     * 参数 size - 大小（单位像素）
     * 返回值 Unit - 
     */
    public func setValueTextSize (size: Float64): Unit
    
    /*
     * 设置启用/禁用此数据对象包含的所有DataSet的绘图值(值-文本)
     * 
     * 参数 enabled - 
     * 返回值 Unit - 
     */
    public func setDrawValues (enabled: Bool): Unit
    
    
    /*
     * 设置是否绘制数据项图标*
     * 
     * 参数 enabled - true/false
     * 返回值 Unit - 
     */
    public func setDrawIcons (enabled: Bool): Unit
    
    
    /*
     * 设置数据项图标的偏移量 *
     * 
     * 参数 offsetDp - MPPointF
     * 返回值 Unit - 
     */
    public func setIconsOffset (offsetDp: MPPointF): Unit
    
    
    /*
     * 设置此数据集的可见性。如果数据集不可见，则在刷新数据集时将不会绘制到图表中
     * 
     * 参数 visible - true/false
     * 返回值 Unit - 
     */
    public func setVisible (visible: Bool): Unit

    /*
     * 图表数据更新
     */
    public func notifyDataSetChanged(): Unit
}
```

#### 1.1.4 PieData Class API Description

饼状图数据包

```cangjie
public class PieData<: ChartData<IPieDataSet,PiEntry> {
    
    /*
     * 无参构造 
     * 
     */
    public init ()
    
    /*
     * 有参构造 
     * 
     * 参数 dataSet - IPieDataSet，这里可用 PieDataSet
     */
    public init (dataSet: IPieDataSet)
    
    /*
     * 设置数据对象(PieDataSet)。
     * 
     * 参数 dataSet - IPieDataSet，这里可用 PieDataSet
     * 返回值 Unit - 
     */
    public func setDataSet (dataSet: IPieDataSet): Unit
    
    /*
     * 返回此 PieData 对象表示的 DataSet。PieData 对象只能包含一个DataSet。
     * 
     * 返回值 IPieDataSet - IPieDataSet
     */
    public func getDataSet (): IPieDataSet
    
    /*
     * 返回此 PieData 对象表示的 DataSet集合。
     * 
     * 返回值 ArrayList<IPieDataSet> - ArrayList<IPieDataSet>
     */
    public override func getDataSets (): ArrayList<IPieDataSet>
     /*
     * 获取相应高亮显示对象的Entry
     * 
     * 参数 highlight - 高亮
     * 返回值 PiEntry - PiEntry
     */
    public override func getEntryForHighlight (highlight: Highlight): PiEntry
    
    /*
     * 返回此PieData对象中所有值的和。
     * 
     * 返回值 Float64 - 
     */
    public func getYValueSum (): Float64
}
```

#### 1.1.5 PieChartModel Class API Description

饼状图配置构建类

```cangjie
public class PieChartModel<: PieRadarChartBaseModel<PieData, IPieDataSet, PiEntry> {        
    /*
     * 检查给定索引是否设置为突出显示。
     * 
     * 参数 index - 给定索引
     * 返回值 Bool - true/false
     */
    public func needsHighlight (index: Float64): Bool
        
    /*
     * 设置在 Pie Chart中心绘制的孔的颜色(如果启用)
     * 
     * 参数 color - 颜色
     * 返回值 Unit - 
     */
    public func setHoleColor (color: UInt32): Unit
    
    /*
     * 启用或禁用孔后面切片内部尖端的可见性
     * 
     * 参数 enable - true/false
     * 返回值 Unit - 
     */
    public func setDrawSlicesUnderHole (enable: Bool): Unit
  
    
    /*
     * 将此设置为true将饼图中心画为空
     * 
     * 参数 enabled - true/false
     * 返回值 Unit - 
     */
    public func setDrawHoleEnabled (enabled: Bool): Unit
    
    
    /*
     * 设置显示在 PieChart 中心的文本 String。
     * 
     * 参数 text - 文本
     * 返回值 Unit - 
     */
    public func setCenterText (text: String): Unit
       
    /*
     * 将其设置为true以绘制显示在扇形图中心的文字
     * 
     * 参数 enabled - true/false
     * 返回值 Unit - 
     */
    public func setDrawCenterText (enabled: Bool): Unit
    
    /*
     * 设置中心文本绘制的字体
     * 
     * 参数 t - 字体
     * 返回值 Unit - 
     */
    public func setCenterTextTypeface (t: FontFamily): Unit
    
    /*
     * 设置PieChart的中心文本的大小。
     * 
     * 参数 sizeDp - 字体大小
     * 返回值 Unit - 
     */
    public func setCenterTextSize (sizeDp: Float64): Unit
    
    /*
     * 设置PieChart中心文本的大小(以像素为单位)
     * 
     * 参数 sizePixels - 大小(以像素为单位)
     * 返回值 Unit - 
     */
    public func setCenterTextSizePixels (sizePixels: Float64): Unit
    
    /*
     * 设置中心文本相对于原始位置的偏移量。默认的x=0，y=0
     * 
     * 参数 x - 
     * 参数 y - 
     * 返回值 Unit - 
     */
    public func setCenterTextOffset (x: Float64, y: Float64): Unit
    
    
    /*
     * 设置PieChart中心文本的颜色。
     * 
     * 参数 color - 
     * 返回值 Unit - 
     */
    public func setCenterTextColor (color: UInt32): Unit
    
    /*
     * 以最大半径的百分比设置图中心孔的半径(max=整个图表的半径)，默认为50%
     * 
     * 参数 percent - 百分比
     * 返回值 Unit - 
     */
    public func setHoleRadius (percent: Float64): Unit
      
    /*
     * 设置圈应有的颜色。*
     * 
     * 参数 color - 颜色
     * 返回值 Unit - 
     */
    public func setTransparentCircleColor (color: UInt32): Unit
    
    /*
     * 设置圆的半径，该圆画在图中的孔旁边，以最大半径的百分比(max=整个图表的半径)，默认为55%->表示默认比中心孔大5% *
     * 
     * 参数 percent - 百分比
     * 返回值 Unit - 
     */
    public func setTransparentCircleRadius (percent: Float64): Unit
       
    /*
     * 设置圈的透明度，0=完全透明，255=完全不透明。默认值为100。*
     * 
     * 参数 alpha - 透明度
     * 返回值 Unit - 
     */
    public func setTransparentCircleAlpha (alpha: Float64): Unit
    
    /*
     * 将此设置为true将条目标签绘制到饼图扇区中*
     * 
     * 参数 enabled - true/false
     * 返回值 Unit - 
     */
    public func setDrawSliceText (enabled: Bool): Unit
    
    /*
     * 将此设置为true则将条目标签绘制到饼图切片中*
     * 
     * 参数 enabled - true/false
     * 返回值 Unit - 
     */
    public func setDrawEntryLabels (enabled: Bool): Unit
    
    
    /*
     * 设置绘制条目标签的颜色。
     * 
     * 参数 color - 颜色
     * 返回值 Unit - 
     */
    public func setEntryLabelColor (color: UInt32): Unit
    
    /*
     * 为条目标签的绘制设置自定义字体。
     * 
     * 参数 tf - 字体
     * 返回值 Unit - 
     */
    public func setEntryLabelTypeface (tf: FontFamily): Unit
    
    /*
     * 设置条目标签的大小。默认值:14vp
     * 
     * 参数 size - 大小
     * 返回值 Unit - 
     */
    public func setEntryLabelTextSize (size: Float64): Unit
    
    /*
     * 设置是否以曲线方式绘制切片，仅在启用绘制孔且切片未在孔下绘制时起作用。*
     * 
     * 参数 enabled - true/false
     * 返回值 Unit - 
     */
    public func setDrawRoundedSlices (enabled: Bool): Unit
    
    
    /*
     * 如果启用此功能，PieChart中的值将以百分数绘制，而不是以其原始值绘制,如果为IValueFormatter，提供的格式化的值将以百分比形式提供。
     * 
     * 参数 enabled - true/false
     * 返回值 Unit - 
     */
    public func setUsePercentValues (enabled: Bool): Unit
    
    
    /*
     * 中心文本的限界框以饼状孔的百分比表示，默认值1.0(100%)
     * 
     * 参数 percent - 0.0-1.0
     * 返回值 Unit - 
     */
    public func setCenterTextRadiusPercent (percent: Float64): Unit
     
    /*
     * 设置用于计算圆饼的最大角度。360表示它是一个完整的派图，180结果是一个半派图。默认值:360
     * 
     * 参数 maxangle - 角度
     * 返回值 Unit - 
     */
    public func setMaxAngle (maxangle: Float64): Unit
    
    /* 
     * 设置角度来设置切片的最小大小，您必须调用{@link#notifyDataSetchanged()}和{@link#invalidate()}来进行更改，只有当有足够的空间让所有切片具有最小角度时才起作用。
     * 
     * 参数 minAngle - 最小大小
     * 返回值 Unit - 
     */
    public func setMinAngleForSlices (minAngle: Float64): Unit
}
```

#### 1.1.6 ChartModel Class API Description

所有图表配置构建类的基类。

```cangjie
public abstract class ChartModel<(D, S, E)> <: ChartInterface<S , E> & AnimatorUpdateListener {
          
    /*
     * 更新动画效果
     * 
     * 参数 result - ohos 的 AnimatorResult
     * 返回值 Unit
     */
    public func onAnimationUpdate (result: AnimatorResult): Unit
    
    /*
     * 清空图表的所有数据，将其置空null，并刷新图表。
     * 
     * 返回值 Unit
     */
    public func clear (): Unit
    
    /*
     * 从图表中删除所有数据集（以及条目），并刷新图表。
     * 
     * 返回值 Unit
     */
    public func clearValues (): Unit
      
    /*
     * 图表数据刷新。
     * 
     * 返回值 Unit
     */
    public func notifyDataSetChanged (): Unit
    
    /*
     * 设置最后一个手势单点
     * 
     * 返回值 Unit - 
     */
    public func setLastGestureSingleTap (): Unit
    
    /*
     * 设置最后一个手势长按
     * 
     * 返回值 Unit - 
     */
    public func setLastGestureLongPress (): Unit
    
    
    /*
     * 设置最大高亮距离*
     * 
     * 参数 distDp - 
     * 返回值 Unit - 
     */
    public func setMaxHighlightDistance (distDp: Float64): Unit
     
    /*
     * 设置是否启用每次点击高亮显示
     * 
     * 参数 enabled - true/false
     */
    public func setHighlightPerTapEnabled (enabled: Bool)
    
    /*
     * 设置是否启用每次长按高亮显示
     * 
     * 参数 enabled - true/false
     */
    public func setHighlightPerLongPressEnabled (enabled: Bool)
      
    /*
     * 突出显示给定数组值高亮显示*
     * 
     * 参数 highs - Array<Highlight>
     */
    public func highlightValuesForArray (highs: Array<Highlight>)
    
    /*
     * 高亮显示给定数据集中的给定位置*
     * 
     * 参数 x - 要突出显示的x值
     * 参数 dataSetIndex - 要搜索的数据集索引
     * 参数 dataIndex - 要搜索的数据索引
     * 返回值 Unit - 
     */
    public func highlightValue (x: Float64, dataSetIndex: Int64, dataIndex: Int64): Unit
    
    /*
     * 高亮显示给定数据集中的给定位置*
     * 
     * 参数 x - 要突出显示的x值
     * 参数 dataSetIndex - 要搜索的数据集索引
     * 返回值 Unit - 
     */
    public func highlightValue (x: Float64, dataSetIndex: Int64): Unit
    
    /*
     * 高亮显示给定数据集中的给定位置*
     * 
     * 参数 x - 要突出显示的x值
     * 参数 y - 要突出显示的y值。
     * 参数 dataSetIndex - 要搜索的数据集索引
     * 参数 dataIndex - 要搜索的数据索引
     * 返回值 Unit - 
     */
    public func highlightValue (x: Float64, y: Float64, dataSetIndex: Int64, dataIndex: Int64): Unit
    
    /*
     * 高亮显示给定数据集中的给定位置*
     * 
     * 参数 x - 要突出显示的x值
     * 参数 y - 要突出显示的y值
     * 参数 dataSetIndex - 要搜索的数据集索引
     * 返回值 Unit - 
     */
    public func highlightValue (x: Float64, y: Float64, dataSetIndex: Int64): Unit
    
    /*
     * 高亮显示给定数据集中给定x值处的任何y值*
     * 
     * 参数 x - 要突出显示的x值
     * 参数 dataSetIndex - 要搜索的数据集索引
     * 参数 dataIndex - 要搜索的数据索引
     * 参数 callListener - 是否应为此更改调用侦听器
     * 返回值 Unit - 
     */
    public func highlightValue (x: Float64, dataSetIndex: Int64, dataIndex: Int64, callListener: Bool): Unit
    
    /*
     * 高亮显示给定数据集中给定x值处的任何y值*
     * 
     * 参数 x - 要突出显示的x值
     * 参数 dataSetIndex - 要搜索的数据集索引
     * 参数 callListener - 是否应为此更改调用侦听器
     * 返回值 Unit - 
     */
    public func highlightValue (x: Float64, dataSetIndex: Int64, callListener: Bool): Unit
    
    /*
     * 高亮显示给定数据集中给定x值处的任何y值*
     * 
     * 参数 x - 要突出显示的x值
     * 参数 y - 要突出显示的y值
     * 参数 dataSetIndex - 要搜索的数据集索引
     * 参数 dataIndex - 要搜索的数据索引
     * 参数 callListener - 是否应为此更改调用侦听器
     */
    public func highlightValue (x: Float64, y: Float64, dataSetIndex: Int64, dataIndex: Int64, callListener: Bool)
    
    /*
     * 高亮显示给定数据集中给定x值处的任何y值*
     * 
     * 参数 x - 要突出显示的x值
     * 参数 y - 要突出显示的x值
     * 参数 dataSetIndex - 要搜索的数据集索引
     * 参数 callListener - 是否应为此更改调用侦听器
     * 返回值 Unit - 
     */
    public func highlightValue (x: Float64, y: Float64, dataSetIndex: Int64, callListener: Bool): Unit
    
    /*
     * 高亮显示通过触摸手势选择的值
     * 
     * 参数 high - 高亮显示对象
     * 返回值 Unit - 
     */
    public func highlightValue (high: ?Highlight): Unit
    
    /*
     * 高亮显示通过触摸手势选择的值
     * 
     * 参数 high - 高亮显示对象
     * 参数 callListener - 调用侦听器
     * 返回值 Unit - 
     */
    public func highlightValue (high: ?Highlight, callListener: Bool): Unit
    
    /*
     * 重绘图表。
     * 
     * 返回值 Unit 
     */
    public func invalidate (): Unit
    

    /*
     * 设置触摸监听器
     * 
     * 参数 l - 触摸监听事件
     * 返回值 Unit 
     */
    public func setOnTouchListener (l: ChartTouchListener<ChartModel<D,S,E>,D,S,E>): Unit
    
    /*
     * 获取触摸监听事件
     * 
     * 返回值 ?ChartTouchListener<ChartModel<D,S,E>,D,S,E>  
     */
    public func getOnTouchListener (): ?ChartTouchListener<ChartModel<D,S,E>,D,S,E>
  
    
    /*
     * 设置是否开启惯性滑动*
     * 
     * 参数 enabled - true/false
     */
    public func setDragDecelerationEnabled (enabled: Bool)
    
    
    /*
     * 设置 DragDecelerationFrictionC*
     * 
     * 参数 newValue - 
     */
    public func setDragDecelerationFrictionCoef (newValue: Float64)
    
    /*
     * 展示图表时同时带有X轴，Y轴动画
     * 
     * 参数 durationMillisX - X轴条目动画播放的时长，单位毫秒。
     * 参数 durationMillisY - Y轴条目动画播放的时长，单位毫秒。
     * 参数 easingX - X轴动画差值曲线（可选值见 animateX）
     * 参数 easingY - Y轴动画差值曲线（可选值见 animateX）
     * 返回值 Unit
     */
    public func animateXY (durationMillisX: Int32, durationMillisY: Int32, easingX: String, easingY: String): Unit
    
    /*
     * 展示图表时带有X轴动画。
     * 
     * 参数 durationMillis - 动画播放的时长，单位毫秒。
     * 参数 easing - 动画差值曲线，可选值：参考仓颉语言系统 API 参考-UI 界面-ohos.animator
     *       动画插值曲线，仅支持以下可选值：
     *       "linear"：动画线性变化。
     *       "ease"：动画开始和结束时的速度较慢，cubic-bezier(0.25、0.1、0.25、1.0)。
     *       "ease-in"：动画播放速度先慢后快，cubic-bezier(0.42, 0.0, 1.0, 1.0)。
     *       "ease-out"：动画播放速度先快后慢，cubic-bezier(0.0, 0.0, 0.58, 1.0)。
     *       "ease-in-out"：动画播放速度先加速后减速，cubic-bezier(0.42, 0.0, 0.58, 1.0)。
     *       "fast-out-slow-in"：标准曲线，cubic-bezier(0.4，0.0，0.2，1.0)。
     *       "linear-out-slow-in"：减速曲线，cubic-bezier(0.0，0.0，0.2，1.0)。
     *       "fast-out-linear-in"：加速曲线，cubic-bezier(0.4, 0.0, 1.0, 1.0)。
     *       "friction"：阻尼曲线，cubic-bezier(0.2, 0.0, 0.2, 1.0)。
     *       "extreme-deceleration"：急缓曲线，cubic-bezier(0.0, 0.0, 0.0, 1.0)。
     *       "rhythm"：节奏曲线，cubic-bezier(0.7, 0.0, 0.2, 1.0)。
     *       "sharp"：锐利曲线，cubic-bezier(0.33, 0.0, 0.67, 1.0)。
     *       "smooth"：平滑曲线，cubic-bezier(0.4, 0.0, 0.4, 1.0)。
     *       "cubic-bezier(x1,y1,x2,y2)"：三次贝塞尔曲线，x1、x2的值必须处于0-1之间。例如"cubic-bezier(0.42,0.0,0.58,1.0)"。
     *       "steps(number,step-position)"：阶梯曲线，number必须设置，为正整数，step-position参数可选，支持设置start或end，默认值为end。例如"steps(3,start)"。
     * 返回值 Unit 
     */
    public func animateX (durationMillis: Int32, easing: String): Unit
    
    /*
     * 展示图表时带有Y轴动画。
     * 
     * 参数 durationMillis - 动画播放的时长，单位毫秒。
     * 参数 easing - 动画差值曲线，可选值：参考仓颉语言系统 API 参考-UI 界面-ohos.animator
     *       动画插值曲线，仅支持以下可选值：
     *       "linear"：动画线性变化。
     *       "ease"：动画开始和结束时的速度较慢，cubic-bezier(0.25、0.1、0.25、1.0)。
     *       "ease-in"：动画播放速度先慢后快，cubic-bezier(0.42, 0.0, 1.0, 1.0)。
     *       "ease-out"：动画播放速度先快后慢，cubic-bezier(0.0, 0.0, 0.58, 1.0)。
     *       "ease-in-out"：动画播放速度先加速后减速，cubic-bezier(0.42, 0.0, 0.58, 1.0)。
     *       "fast-out-slow-in"：标准曲线，cubic-bezier(0.4，0.0，0.2，1.0)。
     *       "linear-out-slow-in"：减速曲线，cubic-bezier(0.0，0.0，0.2，1.0)。
     *       "fast-out-linear-in"：加速曲线，cubic-bezier(0.4, 0.0, 1.0, 1.0)。
     *       "friction"：阻尼曲线，cubic-bezier(0.2, 0.0, 0.2, 1.0)。
     *       "extreme-deceleration"：急缓曲线，cubic-bezier(0.0, 0.0, 0.0, 1.0)。
     *       "rhythm"：节奏曲线，cubic-bezier(0.7, 0.0, 0.2, 1.0)。
     *       "sharp"：锐利曲线，cubic-bezier(0.33, 0.0, 0.67, 1.0)。
     *       "smooth"：平滑曲线，cubic-bezier(0.4, 0.0, 0.4, 1.0)。
     *       "cubic-bezier(x1,y1,x2,y2)"：三次贝塞尔曲线，x1、x2的值必须处于0-1之间。例如"cubic-bezier(0.42,0.0,0.58,1.0)"。
     *       "steps(number,step-position)"：阶梯曲线，number必须设置，为正整数，step-position参数可选，支持设置start或end，默认值为end。例如"steps(3,start)"。
     * 返回值 Unit 
     */
    public func animateY (durationMillis: Int32, easing: String): Unit
    
    /*
     * 为图表设置选择监听事件
     * 
     * 参数 l - 监听事件
     * 返回值 Unit 
     */
    public func setOnChartValueSelectedListener (l: OnChartValueSelectedListener): Unit
    
    /*
     * 为图表设置手势监听事件
     * 
     * 参数 l - 手势监听事件
     * 返回值 Unit 
     */
    public func setOnChartGestureListener (l: OnChartGestureListener): Unit
    
    /*
     * 获取自定义手势监听事件
     * 
     * 返回值 ?OnChartGestureListener - OnChartGestureListener
     *                                - Option<OnChartGestureListener>.None
     */
    public func getOnChartGestureListener (): ?OnChartGestureListener
    
           
    /*
     * 设置图表额外偏移量*
     * 
     * 参数 left - 左
     * 参数 top - 高
     * 参数 right - 右
     * 参数 bottom - 下
     */
    public func setExtraOffsets (left: Float64, top: Float64, right: Float64, bottom: Float64)
    
    /*
     * 设置附加到视口顶部的额外偏移
     * 
     * 参数 offset - 
     */
    public func setExtraTopOffset (offset: Float64)
    
    
    /*
     * 设置附加到视口右边的额外偏移
     * 
     * 参数 offset - 
     */
    public func setExtraRightOffset (offset: Float64)
    
    
    /*
     * 设置附加到视口底部的额外偏移
     * 
     * 参数 offset - 
     */
    public func setExtraBottomOffset (offset: Float64)
    
    
    /*
     * 设置附加到视口左边的额外偏移
     * 
     * 参数 offset - 
     */
    public func setExtraLeftOffset (offset: Float64)
    
    
    /*
     * 将其设置为 true 可启用图表的log输出
     * 
     * 参数 enabled - true/false
     */
    public func setLogEnabled (enabled: Bool)
     
    /*
     * 设置文本，通知用户没有可用于绘制图表的数据。
     * 
     * 参数 text - 文本
     */
    public func setNoDataText (text: String)
    
    /*
     * 设置无数据文本的颜色
     * 
     * 参数 color - 
     */
    public func setNoDataTextColor (color: Color)
    
    /*
     * 设置无数据文本的字体
     * 
     * 参数 tf - 字体
     */
    public func setNoDataTextTypeface (tf: FontFamily)
    
    /*
     * 对齐无数据文本
     * 
     * 参数 align - 
     */
    public func setNoDataTextAlignment (align: TextAlignStyle)
    
    /*
     * 设置为false。禁用图表所有手势与触摸
     * 
     * 参数 enabled - true/false
     */
    public func setTouchEnabled (enabled: Bool)
    
    /*
     * 设置在图表上单击某个值时显示的标记
     * 
     * 参数 marker - IMarker
     */
    public func setMarker (marker: IMarker)
    
    /*
     * 设置长按标记
     * 
     * 参数 marker - 
     */
    public func setLongPressMarker (marker: IMarker)
    
    /*
     * 设置标记区域
     * 
     * 参数 v - IMarker
     */
    public func setMarkerView (v: IMarker)
       
    /*
     * 设置图表描述信息
     * 
     * 参数 desc - Description
     */
    public func setDescription (desc: Description)
      
    /*
     * 获取图例对象。
     * 
     * 返回值 ?Legend - 获取图例对象。
     *               - Legend
     *               - Option<Legend>.None
     */
    public func getLegend (): ?Legend
    
    /*
     * 设置是否开启绘画标记点显示
     * 
     * 参数 enabled - true/false
     */
    public func setDrawMarkerViews (enabled: Bool)
    
    /*
     * 将此设置为true可在点击图表时显示用户指定的标记
     * 
     * 参数 enabled - true/false
     */
    public func setDrawMarkers (enabled: Bool)
    
    /*
     * 将此设置为true可在长按图表时显示用户指定的标记
     * 
     * 参数 enabled - true/false
     */
    public func setDrawLongPressMarkers (enabled: Bool)
     
    /*
     * 设置高亮显示
     * 
     * 参数 highlighter - 高亮显示接口类
     */
    public func setHighlighter (highlighter: ChartHighlighter<BarLineScatterCandleBubbleDataProvider<IDataSet<EntryOhos>,EntryOhos>,IDataSet<EntryOhos>,EntryOhos>)
     
    /*
     * 改变图表大小
     * 
     * 参数 w - 新宽
     * 参数 h - 新高
     * 参数 oldw - 旧宽
     * 参数 oldh - 旧高
     * 返回值 Unit - 
     */
    public func onSizeChanged (w: Float64, h: Float64, oldw: Float64, oldh: Float64): Unit
       
    /*
     * 将此设置为true以启用可绘制对象从当视图从窗口分离时，这有助于避免内存泄漏。
     * 默认值:false
     * 
     * 参数 enabled - true/false
     */
    public func setUnbindEnabled (enabled: Bool)
}

```

#### 1.1.6 PieChart Class API Description

饼状图组件

```cangjie
@Component
class PieChart {
    var model: PieChartModel
}
```

### 1.2 图例 Legend

图表 Legend(图例) 部件

#### 1.2.1 LegendEntry Class API Description

```cangjie
public class LegendEntry {
    
    /*
     * 构造 
     * 
     */
    public init ()
    
    /*
     * 构造 
     * 
     * 参数 label - 图例条目文本。
     * 参数 form - 本条目要绘制的表格。
     * 参数 formSize - 表格大小。
     * 参数 formLineWidth - 表格线宽
     * 参数 formLineDashEffect - 表格线形状
     * 参数 formColor - 用于绘制窗体的颜色。
     */
    public init (label: String, form: LegendForm, formSize: Float64, formLineWidth: Float64, formLineDashEffect: ?DashPathEffect, formColor: UInt32)
}
```


#### 1.2.2 Legend Class API Description

图例对象

```cangjie
public class Legend<: ComponentBase {
    
    /*
     * 无参构造 
     * 
     */
    public init ()
    
    /*
     * 构造 
     * 
     * 参数 entries - LegendEntry 集合
     */
    public init (entries: Array<LegendEntry>)
    
    /*
     * 设置图例
     * 
     * 参数 entries - LegendEntry 集合
     * 返回值 Unit - 
     */
    public func setEntries (entries: ArrayList<LegendEntry>): Unit
    
    
    /*
     * 添加额外图例
     * 
     * 参数 entriesParams - LegendEntry集合集合
     * 返回值 Unit - 
     */
    public func setExtra (entriesParams: ArrayList<LegendEntry>): Unit
    
    /*
     * 在原始条目末尾追加条目。(如果图例已经计算过，则需要调用 notifyDataSetchanged()以使更改生效)
     * 
     * 参数 colors - 颜色集合
     * 参数 labels - 标签集合
     * 参数 entriesParams - 图例集合
     * 返回值 Unit - 
     */
    public func setExtra (colors: Array<UInt32>, labels: Array<String>, entriesParams: ArrayList<LegendEntry>): Unit
    
    /*
     * 设置自定义图例的条目数组。
     * 
     * 参数 entries - LegendEntry 集合
     * 返回值 Unit - 
     */
    public func setCustom (entries: ArrayList<LegendEntry>): Unit
    
    /*
     * 设置自定义图例的条目数组。
     * 
     * 参数 entries - LegendEntry 集合
     * 返回值 Unit - 
     */
    public func setCustomArray (entries: Array<LegendEntry>): Unit
    
    /*
     * 禁用自定义图例项
     * 
     * 返回值 Unit - 
     */
    public func resetCustom (): Unit
    
    /*
     * 设置图例的水平对齐方式
     * 
     * 参数 value - LegendHorizontalAlignment
     * 返回值 Unit - 
     */
    public func setHorizontalAlignment (value: LegendHorizontalAlignment): Unit
    
    
    /*
     * 设置图例的垂直对齐方式
     * 
     * 参数 value - LegendVerticalAlignment
     * 返回值 Unit - 
     */
    public func setVerticalAlignment (value: LegendVerticalAlignment): Unit
    
    
    /*
     * 设置图例的方向
     * 
     * 参数 value - LegendOrientation
     * 返回值 Unit - 
     */
    public func setOrientation (value: LegendOrientation): Unit
    
    /*
     * 设置图例将在图表内部还是外部绘制
     * 
     * 参数 value - true/false
     * 返回值 Unit - 
     */
    public func setDrawInside (value: Bool): Unit
    
    /*
     * 设置图例的文本方向
     * 
     * 参数 pos - 
     * 返回值 Unit - 
     */
    public func setDirection (pos: LegendDirection): Unit
    
    
    /*
     * 设置图例设置的当前窗体的形状
     * 
     * 参数 shape - LegendForm
     * 返回值 Unit - 
     */
    public func setForm (shape: LegendForm): Unit
    
    /*
     * 设置图例窗体大小
     * 
     * 参数 size - 大小 
     * 返回值 Unit - 
     */
    public func setFormSize (size: Float64): Unit
    
    
    /*
     * 设置图例窗体线宽
     * 
     * 参数 size - 线宽
     * 返回值 Unit - 
     */
    public func setFormLineWidth (size: Float64): Unit
    
    /*
     * 设置图例窗体线类型
     * 
     * 参数 dashPathEffect - DashPathEffect
     * 返回值 Unit - 
     */
    public func setFormLineDashEffect (dashPathEffect: DashPathEffect): Unit

    
    /*
     * 设置水平轴上图例项之间的间距，单位为像素
     * 
     * 参数 space - 间距
     * 返回值 Unit - 
     */
    public func setXEntrySpace (space: Float64): Unit
    
    
    /*
     * 设置垂直轴上图例项之间的间距，单位为像素
     * 
     * 参数 space - 间距
     * 返回值 Unit - 
     */
    public func setYEntrySpace (space: Float64): Unit
   
    /*
     * 设置窗体和实际标签/文本之间的空格
     * 
     * 参数 space - 空格
     * 返回值 Unit - 
     */
    public func setFormToTextSpace (space: Float64): Unit
    
    /*
     * 是否设置文本换行显示
     * 
     * 参数 enabled - true/false
     * 返回值 Unit - 
     */
    public func setWordWrapEnabled (enabled: Bool): Unit 
     
    /*
     * 设置整个图例视图的最大相对大小
     * 
     * 参数 maxSize - 大小
     * 返回值 Unit - 
     */
    public func setMaxSizePercent (maxSize: Float64): Unit
    
}
```

### 1.3 文本描述

图表文本描述

```cangjie
public class Description<: ComponentBase {
    
    /*
     * 构造 
     * 
     */
    public init ()
    
    /*
     * 设置说明文本
     * 
     * 参数 text - 文本
     * 返回值 Unit - 
     */
    public func setText (text: String): Unit
    
    /*
     * 设置文本位置
     * 
     * 参数 x - x 坐标
     * 参数 y - y 坐标
     * 返回值 Unit - 
     */
    public func setPosition (x: Float64, y: Float64): Unit
    
    /*
     * 设置文本居中格式
     * 
     * 参数 align - TextAlignStyle
     */
    public func setTextAlign (align: TextAlignStyle)
}
```

### 1.4 DefaultValueFormatter Class API Description

```
public class DefaultValueFormatter <: IValueFormatter {
    /**
     * 指定值是多少位数
     */
    public init(digits: Int64)
}
```
### 1.5 高亮
```cangjie
public class Highlight {
    /**
     * 构造
     *
     * 参数 x - 突出显示的x值
     * 参数 y - 突出显示的y值
     * 参数 dataSetIndex - 数据对象的索引
     */
    public init(x: Float64, y: Float64, dataSetIndex: Int64) 

    /**
     * 设置数据索引
     *
     * 参数 x - 突出显示的x值
     * 参数 y - 突出显示的y值
     * 参数 dataSetIndex - 数据对象的索引
     */
    public func setDataIndex(mDataIndex: Int64): Unit 

}

```
### 1.6 其他接口

#### 1.6.1 ChartPixelMap Class API Description

图表像素图

```cangjie
public class ChartPixelMap {
    
    /*
     * 设置图标图像
     * 
     * 参数 newIcon - PixelMap
     */
    public func setIcon (newIcon: PixelMap)
    
    /*
     * 设置图像宽度
     * 
     * 参数 width - 
     */
    public func setWidth (width: Int64)
     
    /*
     * 设置图像高度
     * 
     * 参数 height - 
     */
    public func setHeight (height: Int64) 
}
```

#### 1.6.2 MPPointF Class API Description

```cangjie
public class MPPointF<: Poolable {
       
    /*
     * 构造函数
     * 
     * 参数 x - x 坐标
     * 参数 y - y 坐标
     */
    public init (x: Float64, y: Float64)
}
```

#### 1.6.3 enum

##### 1.6.3.1 FontFamily

字体样式

```cangjie
public enum FontFamily {
    | SANS_SERIF
    | SERIF
    | MONOSPACE
    | NONE

    public func toString(): String {
        match (this) {
            case SANS_SERIF => "sans-serif"
            case SERIF => "serif"
            case MONOSPACE => "monospace"
            case MONE => ""
        }
    }
}
```


##### 1.6.3.2 LegendForm

图例样式

```cangjie
public enum LegendForm <: Equatable<LegendForm> {
    | NONE
    | EMPTY
    | DEFAULT
    | SQUARE
    | CIRCLE
    | LINE

    public operator func ==(b: LegendForm): Bool

    public operator func !=(b: LegendForm): Bool
}

```

##### 1.6.3.3 ValuePosition

数值位置
```cangjie
public enum ValuePosition <: Equatable<ValuePosition> {
    | INSIDE_SLICE
    | OUTSIDE_SLICE

    public operator func ==(b: ValuePosition): Bool

    public operator func !=(b: ValuePosition): Bool
}
```

##### 1.6.3.4 LegendHorizontalAlignment

图例水平对齐方式

```cangjie
public enum LegendHorizontalAlignment {
    | LEFT
    | CENTER
    | RIGHT

    public operator func ==(b: LegendHorizontalAlignment): Bool

    public operator func !=(b: LegendHorizontalAlignment): Bool
}
```

##### 1.6.3.5 LegendOrientation

图例方向

```cangjie
public enum LegendOrientation {
    | HORIZONTAL
    | VERTICAL

    public operator func ==(b: LegendOrientation): Bool

    public operator func !=(b: LegendOrientation): Bool
}
```

##### 1.6.3.6 LegendDirection

图例方向

```cangjie
public enum LegendDirection {
    | LEFT_TO_RIGHT
    | RIGHT_TO_LEFT

    public operator func ==(b: LegendDirection): Bool

    public operator func !=(b: LegendDirection): Bool
}
```

##### 1.6.3.7 LegendDirection

图例垂直对齐方式

```cangjie
public enum LegendVerticalAlignment {
    TOP | CENTER | BOTTOM

    public operator func ==(b: LegendVerticalAlignment): Bool

    public operator func !=(b: LegendVerticalAlignment): Bool
}
```




### 1.7 饼图示例

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