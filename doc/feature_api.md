# chart4Ohos 特性文档

## 介绍

chart4Ohos 是一个包含各种类型图表的图表库，主要用于业务数据汇总，例如销售数据走势图，股价走势图等场景中使用，方便开发者快速实现图表 UI，chart4Ohos主要包括线形图、柱状图、饼状图、蜡烛图、气泡图、雷达图、瀑布图等自定义图表库。

## 1 生成各种类型的图表，包括：线形图、条形图、饼状图、蜡烛图、气泡图、雷达图、散点图、瀑布图、组合图、自定义图表

### 1.1 图表基础信息基类

#### 1.1.1 EntryOhos Class API Description

```cangjie
public class EntryOhos <: BaseEntry {
    
    /*
     * 构造 
     * 
     * 参数 x - x 值
     * 参数 y - y 值
     * 参数 icon - 图标图像,默认 Option<ChartPixelMap>.None
     * 参数 data - 数据,默认 Option<Any>.None
     */
    public init (x: Float64, y: Float64, icon!: ?ChartPixelMap, data!: ?Any)
    
    /*
     * 获取 x 值
     * 
     * 返回值 Float64 - x 值
     */
    public func getX (): Float64
    
    
    /*
     * 设置 x 值
     * 
     * 参数 x - x 值
     * 返回值 Unit 
     */
    public func setX (x: Float64): Unit
    
    /*
     * 创建副本
     * 
     * 返回值 EntryOhos - EntryOhos
     */
    public func copy (): EntryOhos

    /*
     * 比较项目的值、xlndex 和数据。如果这些点中的条目相等，则返回true，否则返回false。
     * 
     * 返回值 Bool - true/false
     */
    public func equalTo(e: EntryOhos): Bool

    /*
     * 返回包含 x-index 和 value 的条目的字符串表示形式
     * 
     * 返回值 String 
     */
    public func toString(): String
}
```

#### 1.1.2 IDataSet interface API Description

```cangjie
public interface IDataSet<E> where E <: EntryOhos {

    /*
     * 返回此数据集包含的最小y值
     * 
     * 返回值 Float64 
     */
    func getYMin(): Float64
    
    /*
     * 返回此数据集包含的最大y值
     * 
     * 返回值 Float64 
     */
    func getYMax(): Float64

    /*
     * 返回此数据集包含的最小x值
     * 
     * 返回值 Float64 
     */
    func getXMin(): Float64
    
    /*
     * 返回此数据集包含的最大x值
     * 
     * 返回值 Float64 
     */
    func getXMax(): Float64
    
    /*
     * 返回此数据对象包含的所有DataSet对象的总条目计数。
     * 
     * 返回值 Int64 - 总条目计数
     */
    func getEntryCount(): Int64

    /*
     * 计算所有DataSet上的最小值和最大值(x和y)
     * 
     * 返回值 Unit 
     */
    func calcMinMax(): Unit

    /*
     * 计算所有数据集上的最小和最大Y值。
     * 
     * 参数 fromX - 开始计算的x值
     * 参数 toX - 应执行计算的x值
     * 返回值 Unit 
     */
    func calcMinMaxY(fromX: Float64, toX: Float64): Unit
    
    /*
     * 返回在给定x值处找到的第一个Entry对象
     * 
     * 参数 xValue - x值
     * 参数 closestToY - 如果指定的x值有多个y值
     * 参数 rounding - 如果没有与提供的x值匹配的条目，是否向上/向下/最接近寻找
     * 返回值 ?E 
     */
    func getEntryForXValue(xValue: Float64, closestToY: Float64, rounding!: Rounding): ?E
    
    /*
     * 返回在给定x值处找到的所有Entry对象，如果在该x值处没有Entry对象，则为空数组
     * 
     * 参数 xValue - x值
     * 返回值 ArrayList<E> - Entry对象集合
     */
    func getEntriesForXValue(xValue: Float64): ArrayList<E>
    
    /*
     * 返回在给定索引处找到的Entry对象。
     * 
     * 参数 index - 索引
     * 返回值 E - Entry对象
     */
    func getEntryForIndex(index: Int64): E

    /*
     * 返回在给定x值处找到的第一个条目索引
     * 
     * 参数 xValue - x值
     * 参数 closestToY - 如果指定的x值有多个y值
     * 参数 rounding - 如果没有与提供的x值匹配的条目，是否向上/向下/最接近寻找
     * 返回值 Int64 - 索引
     */
    func getEntryIndex(xValue: Float64, closestToY: Float64, rounding: Rounding): Int64
    
    /*
     * 返回提供的entry条目在DataSets entry数组中的位置。
     * 
     * 参数 e - entry
     * 返回值 Int64
     */
    func getEntryIndexByEntry(e: E): Int64

    /*
     * 返回给定xIndex的数据集的Entry数组中的实际索引
     * 
     * 参数 xIndex - 索引
     * 返回值 Int64
     */
    func getIndexInEntries(xIndex: Float64): Int64
    
    /*
     * 将条目动态添加到数据集中
     * 
     * 参数 e - e
     * 返回值 Bool
     */
    func addEntry(e: ?E): Bool
    
    /*
     * 将条目动态添加到数据集中
     * 
     * 参数 e - 条目
     * 返回值 Unit
     */
    func addEntryOrdered(e: E): Unit
    
    /*
     * 从条目数组中删除此数据集的第一个条目
     * 
     * 返回值 Bool - 如果成功则返回true，如果不成功则返回false。
     */
    func removeFirst(): Bool

    /*
     * 从条目数组中删除此数据集的最后一个条目
     * 
     * 返回值 Bool - 如果成功则返回true，如果不成功则返回false
     */
    func removeLast(): Bool
    
    /*
     * 从DataSets条目数组中删除条目
     * 
     * 参数 e - 
     * 返回值 Bool
     */
    func removeEntry(e: E): Bool

    /*
     * 从数据集中删除最接近给定x值的Entry对象
     * 
     * 参数 xValue - x值
     * 返回值 Bool
     */
    func removeEntryByXValue(xValue: Float64): Bool
    
    /*
     * 从数据集中删除值数组中给定索引处的Entry对象
     * 
     * 参数 xIndex - 索引
     * 返回值 Bool - 如果删除了条目，则返回true；如果无法删除任何条目，则为false
     */
    func removeEntryByIndex(index: Int64): Bool
    
    /*
     * 检查此数据集是否包含指定的条目
     * 
     * 参数 entry - 条目
     * 返回值 Bool - 如果是，则返回true，否则为false
     */
    func contains(entry: E): Bool
    
    /*
     * 从该数据集中删除所有值
     * 
     * 返回值 Unit
     */
    func clear(): Unit

    /*
     * 返回描述数据集的标签字符串
     * 
     * 返回值 String
     */
    func getLabel(): String
    
    /*
     * 设置描述数据集的标签字符串
     * 
     * 参数 label - 标签字符串
     * 返回值 Unit
     */
    func setLabel(label: String): Unit

    /*
     * 返回此数据集应绘制的轴
     * 
     * 返回值 AxisDependency - 轴
     */
    func getAxisDependency(): AxisDependency
    
    /*
     * 设置绘制此数据集的y轴（向左或向右），默认值：LEFT
     * 
     * 返回值 Unit
     */
    func setAxisDependency(dependency: AxisDependency): Unit
    
    /*
     * 返回为此数据集设置的所有颜色集合
     * 
     * 返回值 ArrayList<UInt32> - 颜色集合
     */
    func getColors(): ArrayList<UInt32>
   
    /*
     * 返回数据集的颜色数组给定索引处的颜色
     * 
     * 参数 index - 索引
     * 返回值 UInt32 - 颜色
     */
    func getColor(index: Int64): UInt32
    
    /*
     * 如果启用了值的高亮显示，则返回true；如果未启用，则返回false
     * 
     * 返回值 Bool
     */
    func isHighlightEnabled(): Bool
    
    /*
     * 如果设置为true，将启用值高亮显示
     * 参数 enabled - true/false
     * 返回值 Unit
     */
    func setHighlightEnabled(enabled: Bool): Unit
    
    /*
     * 设置用于在图表中绘制值的格式
     * 
     * 参数 f - 使用chart.getDefaultValueFormatter()
     * 返回值 Unit
     */
    func setValueFormatter(f: IValueFormatter): Unit
    
    /*
     * 返回用于在图表中绘制值的格式化
     * 
     * 返回值 ?IValueFormatter
     */
    func getValueFormatter(): ?IValueFormatter
    
    /*
     * 如果此数据集的valueFormatter对象为None，则返回true
     * 
     * 返回值 Bool
     */
    func needsFormatter(): Bool
    
    /*
     * 设置此数据集的值的标签颜色
     * 
     * 参数 color - 颜色
     * 返回值 Unit
     */
    func setValueTextColor(color: UInt32): Unit
    
    /*
     * 设置此数据集的值的标签颜色列表
     * 
     * 参数 colors - 颜色列表
     * 返回值 Unit
     */
    func setValueTextColors(colors: ArrayList<UInt32>): Unit
    
    /*
     * 设置此数据集的值标签的字体
     * 
     * 参数 tf - FontFamily
     * 返回值 Unit
     */
    func setValueTypeface(tf: FontFamily): Unit
    
    /*
     * 设置此数据集的值标签的文本大小。
     * 
     * 参数 size - 文本大小
     * 返回值 Unit
     */
    func setValueTextSize(size: Float64): Unit
    
    /*
     * 返回指定索引处的颜色
     * 
     * 参数 index - 索引
     * 返回值 UInt32 - 颜色
     */
    func getValueTextColor(index: ?Int64): UInt32
    
    /*
     * 返回用于在图表中绘制值的字体
     * 
     * 返回值 FontFamily - 字体
     */
    func getValueTypeface(): FontFamily
    
    /*
     * 返回用于在图表中绘制值的文本大小
     * 
     * 返回值 Float64 - 文本大小
     */
    func getValueTextSize(): Float64

    /*
     * 图例中要为此数据集绘制的表单
     * 
     * 返回值 LegendForm - 图例
     */
    func getForm(): LegendForm
    
    /*
     * 图例中要为此数据集绘制的表单大小。
     * 
     * 返回值 Float64 - 表单大小
     */
    func getFormSize(): Float64
    
    /*
     * 图例中用于绘制此数据集形式的线宽
     * 
     * 返回值 Float64 - 线宽
     */
    func getFormLineWidth(): Float64
    
    /*
     * 用于由线组成的线路径效果
     * 
     * 返回值 DashPathEffect - 虚实线
     */
    func getFormLineDashEffect(): ?DashPathEffect
    
    /*
     * 将其设置为true可在图表上绘制y值
     * 
     * 参数 enabled - true/false
     * 返回值 Unit
     */
    func setDrawValues(enabled: Bool): Unit

    /*
     * 如果启用y值绘制，则返回true；如果未启用，则返回false
     * 
     * 返回值 Bool - true/false
     */
    func isDrawValuesEnabled(): Bool
    
    /*
     * 将此设置为true可在图表上绘制y图标。
     * 
     * 参数 enabled - true/false
     * 返回值 Unit
     */
    func setDrawIcons(enabled: Bool): Unit

    /*
     * 如果启用了y图标绘制，则返回true；如果未启用，则返回false
     * 
     * 返回值 Bool
     */
    func isDrawIconsEnabled(): Bool
    
    /*
     * 图表上绘制的图标的偏移量
     * 
     * 参数 offset - 偏移量
     * 返回值 Unit
     */
    func setIconsOffset(offset: MPPointF): Unit
    
    /*
     * 获取图形图标的偏移量。
     * 
     * 返回值 MPPointF
     */
    func getIconsOffset(): MPPointF
    
    /*
     * 设置此数据集的可见性
     * 
     * 参数 visible - true/false
     * 返回值 Int64
     */
    func setVisible(visible: Bool): Unit
    
    /*
     * 如果此数据集在图表中可见，则返回true
     * 
     * 返回值 Bool - true/false
     */
    func isVisible(): Bool
}

```
#### 1.1.3 ChartData Class API Description

图表数据类

```cangjie
public open class ChartData<S, E> where S <: IDataSet<E>, E <: EntryOhos  {
    
    /*
     * 无参构造 
     * 
     */
    public init ()
    
    /*
     * 有参构造 
     * 
     * 参数 dataSets - 数据集
     */
    public init (dataSets: ArrayList<S>)
    
    /*
     * 有参构造  
     * 
     * 参数 dataSets - 数据集
     */
    public init (dataSets: Array<S>)
    
    /*
     * 调用此方法以让ChartData知道基础数据已更改。当包含的数据发生更改时，调用此函数将重新计算。
     * 
     * 返回值 Unit 
     */
    public func notifyDataChanged (): Unit
    
    /*
     * 计算所有数据集上的最小和最大Y值。
     * 
     * 参数 fromX - 开始计算的x值
     * 参数 toX - 应执行计算的x值
     * 返回值 Unit 
     */
    public func calcMinMaxY (fromX: Float64, toX: Float64): Unit
    
    /*
     * 计算所有DataSet上的最小值和最大值(x和y)
     * 
     * 返回值 Unit 
     */
    public func calcMinMax (): Unit
    
    /*
     * 返回此对象包含的DataSet数
     * 
     * 返回值 Int64 - DataSet数
     */
    public func getDataSetCount (): Int64
    
    /*
     * 返回指定轴的最小y值。
     * 
     * 返回值 Float64 - 最小y值
     */
    public func getYMin (): Float64
    
    /*
     * 返回指定轴的最小y值。
     * 
     * 参数 axis - AxisDependency
     * 返回值 Float64 - 最小y值
     */
    public func getYMin (axis: AxisDependency): Float64
    
    /*
     *  返回指定轴的最大y值。
     * 
     * 返回值 Float64 - 最大y值
     */
    public func getYMax (): Float64
    
    /*
     * 返回指定轴的最大y值。
     * 
     * 参数 axis - AxisDependency
     * 返回值 Float64 - 最大y值
     */
    public func getYMax (axis: AxisDependency): Float64
    
    /*
     * 返回指定轴的最小x值。
     * 
     * 返回值 Float64 - 最小x值
     */
    public func getXMin (): Float64
    
    /*
     * 返回指定轴的最大x值。
     * 
     * 返回值 Float64 - 最大x值
     */
    public func getXMax (): Float64
    
    /*
     * 返回此ChartData对象持有的所有DataSet对象。
     * 
     * 返回值 ArrayList<S> - DataSet对象
     */
    public open func getDataSets (): ArrayList<S>
    
    /*
     * 以字符串数组的形式返回所有数据集的标签。
     * 
     * 返回值 Array<String> - 标签集合
     */
    public func getDataSetLabels (): Array<String>
    
    /*
     * 获取相应高亮显示对象的Entry
     * 
     * 参数 highlight - 高亮
     * 返回值 EntryOhos - EntryOhos
     */
    public open func getEntryForHighlight (highlight: Highlight): EntryOhos
    
    /*
     * 返回具有给定标签的DataSet对象。搜索可以区分大小写，也可以不区分大小写重要提示:此方法在运行时进行计算。在性能危急的情况下小心使用。
     * 
     * 参数 label - 给定标签
     * 参数 ignorecase - 是否区分大小写
     * 返回值 ?S - S/Option<S>.None
     *           - S 是所有 IdataSet 的父类
     */
    public open func getDataSetByLabel (label: String, ignorecase: Bool): ?S
    
    /*
     * 根据索引获取DataSet对象
     * 
     * 参数 index - 索引
     * 返回值 ?S - S/Option<S>.None
     *           - S 是所有 IdataSet 的父类
     */
    public open func getDataSetByIndex (index: Int64): ?S
    
    /*
     * 动态添加数据集
     * 
     * 参数 d - 数据
     * 返回值 Unit 
     */
    public func addDataSet (d: S): Unit
    
    /*
     * 从此数据对象中移除给定的DataSet。也会重新计算所有的最小值和最大值。如果删除了数据集，则返回true;如果不能删除任何数据集，则返回false。
     * 
     * 参数 d - 数据集
     * 返回值 Bool - true/false
     */
    public func removeDataSet (d: S): Bool
    
    /*
     * 从数据对象中移除DataSet数组中给定索引处的DataSet。也会重新计算所有的最小值和最大值。如果删除了DataSet，则返回true;如果不能删除DataSet，则返回false。
     * 
     * 参数 index - 索引
     * 返回值 Bool - true/false
     */
    public func removeDataSetByIndex (index: Int64): Bool
    
    /*
     * 在指定的索引处向DataSet添加一个Entry。条目添加到列表的未尾。
     * 
     * 参数 e - Entry
     * 参数 dataSetIndex - 指定索引
     * 返回值 Unit 
     */
    public func addEntry (e: E, dataSetIndex: Int64): Unit
    
    /*
     * 从指定索引处的DataSet中移除给定的Entry对象。
     * 
     * 参数 e - Entry对象
     * 参数 dataSetIndex - 指定索引
     * 返回值 Bool - true/false
     */
    public func removeEntry (e: E, dataSetIndex: Int64): Bool
    
    /*
     * 移除指定索引中最接近给定DataSet的Entry对象。如果删除条目，则返回true;如果没有找到符合指定要求的条目，则返回false。
     * 
     * 参数 xValue - 给定值
     * 参数 dataSetIndex - 给定索引
     * 返回值 Bool - true/false
     */
    public func removeEntryByXValue (xValue: Float64, dataSetIndex: Int64): Bool
    
    /*
     * 返回包含所提供的项的DataSet，如果没有DataSet包含此项，则返回 Option<S>.None
     * 
     * 参数 e - EntryOhos
     * 返回值 ?S - S/Option<S>.None
     *           - S 是所有 IdataSet 的父类
     */
    public func getDataSetForEntry (e: EntryOhos): ?S
    
    /*
     * 返回此对象所代表的所有Dataset对象中使用的所有颜色。
     * 
     * 返回值 Array<UInt32> - 所有颜色数组
     */
    public func getColors (): Array<UInt32>
    
    /*
     * 返回此数据对象的DataSet数组中提供的DataSet的索引，如果不存在，返回-1。
     * 
     * 参数 dataSet - DataSet
     * 返回值 Int64 - 索引
     */
    public func getIndexOfDataSet (dataSet: S): Int64
    
    /*
     * 返回在左轴上具有依赖关系的数据集数组中的第一个数据集。如果找不到具有左依赖关系的数据集，则返Option<S>.None。
     * 
     * 参数 sets - 数据集
     * 返回值 ?S - S/Option<S>.None
     *           - S 是所有 IdataSet 的父类
     */
    public func getFirstRight (sets: ArrayList<S>): ?S
    
    /*
     * 为该数据对象包含的所有数据集设置自定义IValueFormatter。
     * 
     * 参数 f - IValueFormatter
     * 返回值 Unit 
     */
    public func setValueFormatter (f: ?IValueFormatter): Unit
    
    /*
     * 为该数据对象包含的所有Dataset设置值-文本的颜色(绘制值标签的颜色)
     * 
     * 参数 color - 颜色
     * 返回值 Unit 
     */
    public func setValueTextColor (color: UInt32): Unit
    
    /*
     * 为该数据对象包含的所有Dataset设置相同的值-颜色列表。
     * 
     * 参数 colors - 颜色集
     * 返回值 Unit 
     */
    public func setValueTextColors (colors: ArrayList<UInt32>): Unit
    
    /*
     * 设置此数据对象包含的所有数据集的所有值标签的字体。
     * 
     * 参数 tf - 字体
     * 返回值 Unit 
     */
    public func setValueTypeface (tf: FontFamily): Unit
    
    /*
     * 设置此数据对象包含的所有DataSet的值-文本的大小(以vp为单位)
     * 
     * 参数 size - 字体大小
     * 返回值 Unit 
     */
    public func setValueTextSize (size: Float64): Unit
    
    /*
     * 启用/禁用此数据对象包含的所有DataSet的绘图值(值-文本)
     * 
     * 参数 enabled - true/false
     * 返回值 Unit 
     */
    public func setDrawValues (enabled: Bool): Unit
    
    /*
     * 启用/禁用此数据对象包含的所有DataSet的突出显示值。如果设置为true这意味着可以通过编程方式或通过触摸手势突出显示值。
     * 
     * 参数 enabled - true/false 
     * 返回值 Unit 
     */
    public func setHighlightEnabled (enabled: Bool): Unit
    
    /*
     * 如果启用了所有基础值的突出显示，则返回true;如果未启用，则返回false。
     * 
     * 返回值 Bool - true/false 
     */
    public func isHighlightEnabled (): Bool
    
    /*
     * 从所有数据集中清除此数据对象并删除所有条目。别忘了在这之后让图表失效。
     * 
     * 返回值 Unit 
     */
    public func clearValues (): Unit
    
    /*
     * 检查此数据对象是否包含指定的数据集。如果是则返回真，如果不是则返回假。
     * 
     * 参数 dataSet - 数据对象
     * 返回值 Bool - true/false 
     */
    public func contains (dataSet: S): Bool
    
    /*
     * 返回此数据对象包含的所有DataSet对象的总条目计数。
     * 
     * 返回值 Int64 - 总条目计数
     */
    public func getEntryCount (): Int64
    
    /*
     * 返回具有最大条目数的DataSet对象，如果没有DataSet，返回 Option<S>.None
     * 
     * 返回值 ?S - S/Option<S>.None
     *           - S 是所有 IdataSet 的父类
     */
    public func getMaxEntryCountSet (): ?S
    
    /*
     * 设置是否仅通过X轴距离来判断是否高亮点。
     * 
     * 参数 highlightByXDistance - 是否仅通过X轴距离来判断是否高亮点
     */
    public func setHighlightByXDistance (highlightByXDistance: Bool)
    
    /*
     * 检查是否仅通过X轴距离来判断是否高亮点。
     * 
     * 返回值 Bool - 是否仅通过X轴距离来判断是否高亮点的布尔值
     */
    public func isHighlightByXDistance (): Bool
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
     * 返回值 Unit 
     */
    public func setColorsByList (colors: ArrayList<UInt32>): Unit
    
    /*
     * 设置此DataSet应使用的颜色。一旦DataSet表示的条目数大于颜色数组的大小，就会重用颜色。
     * 
     * 参数 colors - 颜色
     * 返回值 Unit 
     */
    public func setColorsByVariable (colors: Array<UInt32>): Unit
    
    /*
     * 设置此DataSet应使用的颜色。一旦DataSet表示的条目数大于颜色数组的大小，就会重用颜色。
     * 
     * 参数 colors - 颜色
     * 返回值 Unit 
     */
    public func setColorsByArr (colors: Array<UInt32>): Unit
    
    /*
     * 将新颜色添加到DataSet的颜色数组中。
     * 
     * 参数 color - 颜色
     * 返回值 Unit 
     */
    public func addColor (color: UInt32): Unit
    
    /*
     * 设置此DataSet应使用的唯一颜色。
     * 
     * 参数 color - 颜色
     * 返回值 Unit 
     */
    public func setColorByColor (color: UInt32): Unit
    
    /*
     * 设置具有特定alpha值的颜色
     * 
     * 参数 color - 颜色
     * 参数 alpha - 透明度（0.0-1.0）
     * 返回值 Unit 
     */
    public func setColorByAlpha (color: UInt32, alpha: Float64): Unit
    
    /*
     * 设置具有特定alpha值的颜色组合
     * 
     * 参数 colors - 颜色组
     * 参数 alpha - 透明度（0.0-1.0）
     * 返回值 Unit 
     */
    public func setColorsByArrAndAlpha (colors: Array<UInt32>, alpha: Float64): Unit
    
    /*
     * 重置此数据集的所有颜色并重新创建颜色数组。
     * 
     * 返回值 Unit 
     */
    public func resetColors (): Unit
    
    /*
     * 设置图表标签
     * 
     * 参数 label - 标签
     * 返回值 Unit 
     */
    public func setLabel (label: String): Unit

    /*
     * 设置是否高亮显示
     * 
     * 参数 enabled - true/false
     * 返回值 Unit 
     */
    public func setHighlightEnabled (enabled: Bool): Unit
    
    
    /*
     * 设置值格式
     * 
     * 参数 f - IValueFormatter
     * 返回值 Unit 
     */
    public func setValueFormatter (f: IValueFormatter): Unit
    
    /*
     * 设置文本颜色
     * 
     * 参数 color - 
     * 返回值 Unit 
     */
    public func setValueTextColor (color: UInt32): Unit
    
    /*
     * 设置数据文本颜色
     * 
     * 参数 colors - 颜色
     * 返回值 Unit 
     */
    public func setValueTextColors (colors: ArrayList<UInt32>): Unit
    
    /*
     * 设置设置数据文本字体样式
     * 
     * 参数 tf - 字体样式
     * 返回值 Unit 
     */
    public func setValueTypeface (tf: FontFamily): Unit
    
    /*
     * 设置数据文本大小
     * 
     * 参数 size - 大小（单位像素）
     * 返回值 Unit 
     */
    public func setValueTextSize (size: Float64): Unit
    
    /*
     * 设置启用/禁用此数据对象包含的所有DataSet的绘图值(值-文本)
     * 
     * 参数 enabled - 
     * 返回值 Unit 
     */
    public func setDrawValues (enabled: Bool): Unit
    
    
    /*
     * 设置是否绘制数据项图标*
     * 
     * 参数 enabled - true/false
     * 返回值 Unit 
     */
    public func setDrawIcons (enabled: Bool): Unit
    
    
    /*
     * 设置数据项图标的偏移量 *
     * 
     * 参数 offsetDp - MPPointF
     * 返回值 Unit 
     */
    public func setIconsOffset (offsetDp: MPPointF): Unit
    
    
    /*
     * 设置此数据集的可见性。如果数据集不可见，则在刷新数据集时将不会绘制到图表中
     * 
     * 参数 visible - true/false
     * 返回值 Unit 
     */
    public func setVisible (visible: Bool): Unit

    /*
     * 图表数据更新
     */
    public func notifyDataSetChanged(): Unit
}
```

#### 1.1.5 ChartModel Class API Description

所有图表配置构建类的基类。

```cangjie
public abstract class ChartModel<(D, S, E)> <: ChartInterface<S , E> & AnimatorUpdateListener {
    
    /*
     * 获取图表 Y 轴最小值
     * 
     * 返回值 Float64 - 最小值
     */
    public func getYChartMin (): Float64
    
    /*
     * 获取图表 Y 轴最大值
     * 
     * 返回值 Float64 - 最大值
     */
    public func getYChartMax (): Float64
    
    /*
     * 获取图表最大显示数量
     * 
     * 返回值 Int64 - 数量
     */
    public func getMaxVisibleCount (): Int64
    
    /*
     * 更新动画效果
     * 
     * 参数 result - ohos 的 AnimatorResult
     * 返回值 Unit - 
     */
    public func onAnimationUpdate (result: AnimatorResult): Unit
    
    
    /*
     * 为图表设置新的数据对象
     * 
     * 参数 data - 数据
     * 返回值 Unit
     */
    public func setData (data: ?ChartData<S, E>): Unit
    
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
     * 判断图表数据是否为空
     * 
     * 返回值 Bool - true/false
     */
    public func isEmpty (): Bool
    
    /*
     * 如果图表已经设置了作业的维度，则立即发布作业，或者将作业添加到执行队列中。 
     * 
     * 参数 job - 作业
     * 返回值 Unit 
     */
    public func addViewportJob (job: MoveViewJob): Unit
    
    /*
     * 图表数据刷新。
     * 
     * 返回值 Unit
     */
    public func notifyDataSetChanged (): Unit
    
    /*
     * 计算图表到边框的偏移量，具体取决于图例的位置，x轴y轴的长度，及其的标签位置。
     * 
     * 返回值 Unit  - Unit
     */
    public open func calculateOffsets (): Unit
    
    /*
     * 图表绘制方法。
     * 
     * 参数 c - 图表绘制的上下文。
     * 返回值 Unit 
     */
    public open func onDraw (c: CanvasRenderingContext2D): Unit
    
    /*
     * 判断字符串是否为空
     * 
     * 参数 str - String
     * 返回值 Bool - true/false
     *            - str 为 None 或 size = 0 为true
     */
    public func strIsEmpty (str: ?String): Bool
    
    /*
     * 设置最后一个手势单点
     * 
     * 返回值 Unit 
     */
    public func setLastGestureSingleTap (): Unit
    
    /*
     * 设置最后一个手势长按
     * 
     * 返回值 Unit 
     */
    public func setLastGestureLongPress (): Unit
    
    /*
     * 获取高亮的最大距离
     * 
     * 返回值 Float64 - 最大距离
     */
    public func getMaxHighlightDistance (): Float64
    
    /*
     * 设置最大高亮距离
     * 
     * 参数 distDp - 距离 
     * 返回值 Unit 
     */
    public func setMaxHighlightDistance (distDp: Float64): Unit
    
    /*
     * 返回当前高亮显示值的数组。这可能是空值，如果没有突出显示，则为空数组。
     * 
     * 返回值 ?Array<Highlight> - 高亮显示值的数组
     *                          - Array<Highlight>
     *                          - Option<Array<Highlight>>.None
     */
    public func getHighlighted (): ?Array<Highlight>
    
    /*
     * 判断启用每次点击高亮显示
     * 
     * 返回值 Bool - true/false
     */
    public func isHighlightPerTapEnabled (): Bool
    
    /*
     * 判断启用每次长按高亮显示
     * 
     * 返回值 Bool - true/false
     */
    public func isHighlightPerLongPressEnabled (): Bool
    
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
     * 判断值是否高亮显示
     * 
     * 返回值 Bool - true/false
     */
    public func valuesToHighlight (): Bool
    
    /*
     * 突出显示给定数组值高亮显示
     * 
     * 参数 highs - Array<Highlight>
     */
    public func highlightValuesForArray (highs: Array<Highlight>)
    
    /*
     * 高亮显示给定数据集中给定x值处的任何y值
     * 
     * 参数 x - 要突出显示的x值
     * 参数 dataSetIndex - 要搜索的数据集索引
     * 参数 dataIndex - 要搜索的数据索引
     * 返回值 Unit 
     */
    public func highlightValue (x: Float64, dataSetIndex: Int64, dataIndex: Int64): Unit
    
    /*
     * 高亮显示给定数据集中给定x值处的任何y值
     * 
     * 参数 x - 要突出显示的x值
     * 参数 dataSetIndex - 要搜索的数据集索引
     * 返回值 Unit 
     */
    public func highlightValue (x: Float64, dataSetIndex: Int64): Unit
    
    /*
     * 高亮显示给定数据集中给定x值处的任何y值
     * 
     * 参数 x - 要突出显示的x值
     * 参数 y - 要突出显示的y值。
     * 参数 dataSetIndex - 要搜索的数据集索引
     * 参数 dataIndex - 要搜索的数据索引
     * 返回值 Unit 
     */
    public func highlightValue (x: Float64, y: Float64, dataSetIndex: Int64, dataIndex: Int64): Unit
    
    /*
     * 高亮显示给定数据集中给定x值处的任何y值
     * 
     * 参数 x - 要突出显示的x值
     * 参数 y - 要突出显示的y值
     * 参数 dataSetIndex - 要搜索的数据集索引
     * 返回值 Unit 
     */
    public func highlightValue (x: Float64, y: Float64, dataSetIndex: Int64): Unit
    
    /*
     * 高亮显示给定数据集中给定x值处的任何y值
     * 
     * 参数 x - 要突出显示的x值
     * 参数 dataSetIndex - 要搜索的数据集索引
     * 参数 dataIndex - 要搜索的数据索引
     * 参数 callListener - 是否应为此更改调用侦听器
     * 返回值 Unit 
     */
    public func highlightValue (x: Float64, dataSetIndex: Int64, dataIndex: Int64, callListener: Bool): Unit
    
    /*
     * 高亮显示给定数据集中给定x值处的任何y值
     * 
     * 参数 x - 要突出显示的x值
     * 参数 dataSetIndex - 要搜索的数据集索引
     * 参数 callListener - 是否应为此更改调用侦听器
     * 返回值 Unit 
     */
    public func highlightValue (x: Float64, dataSetIndex: Int64, callListener: Bool): Unit
    
    /*
     * 高亮显示给定数据集中给定x值处的任何y值
     * 
     * 参数 x - 要突出显示的x值
     * 参数 y - 要突出显示的y值
     * 参数 dataSetIndex - 要搜索的数据集索引
     * 参数 dataIndex - 要搜索的数据索引
     * 参数 callListener - 是否应为此更改调用侦听器
     */
    public func highlightValue (x: Float64, y: Float64, dataSetIndex: Int64, dataIndex: Int64, callListener: Bool)
    
    /*
     * 高亮显示给定数据集中给定x值处的任何y值
     * 
     * 参数 x - 要突出显示的x值
     * 参数 y - 要突出显示的x值
     * 参数 dataSetIndex - 要搜索的数据集索引
     * 参数 callListener - 是否应为此更改调用侦听器
     * 返回值 Unit 
     */
    public func highlightValue (x: Float64, y: Float64, dataSetIndex: Int64, callListener: Bool): Unit
    
    /*
     * 高亮显示通过触摸手势选择的值
     * 
     * 参数 high - 高亮显示对象
     * 返回值 Unit 
     */
    public func highlightValue (high: ?Highlight): Unit
    
    /*
     * 高亮显示通过触摸手势选择的值
     * 
     * 参数 high - 高亮显示对象
     * 参数 callListener - 调用侦听器
     * 返回值 Unit 
     */
    public func highlightValue (high: ?Highlight, callListener: Bool): Unit
    
    /*
     * 重绘图表。
     * 
     * 返回值 Unit
     */
    public func invalidate (): Unit
    
    /*
     * 设置图表绘制的上下文。
     * 
     * 参数 context2d - 图表绘制的上下文。
     * 返回值 Unit 
     */
    public func setContext2D (context2d: CanvasRenderingContext2D): Unit
    
    /*
     * 更新图表正确Size。
     * 
     * 参数 newWidth - 图表当前显示的宽。
     * 参数 newHeight - 图表当前显示的高。
     * 参数 oldWidth - 图表改变Size前显示的宽。
     * 参数 oldHeight - 图表改变Size前显示的高。
     * 返回值 Unit 
     */
    public func onChartSizeChanged (newWidth: Float64, newHeight: Float64, oldWidth: Float64, oldHeight: Float64): Unit
    
    /*
     * 返回图表触摸屏幕时的 Highlight 对象（包含 x-index 和 DataSet 索引）。
     * 
     * 参数 x - 屏幕触摸点的x轴坐标。
     * 参数 y - 屏幕触摸点的y轴坐标。
     * 返回值 ?Highlight - 触摸点的高亮对象。
     *                   - Highlight
     *                   - Option<Highlight>.None
     */
    public func getHighlightByTouchPoint (x: Float64, y: Float64): ?Highlight
    
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
     * 返回值 ?ChartTouchListener<ChartModel<D,S,E>,D,S,E> - 触摸监听事件
     *                   - ChartTouchListener<ChartModel<D,S,E>,D,S,E>
     *                   - Option<ChartTouchListener<ChartModel<D,S,E>,D,S,E>>.None
     * 
     */
    public func getOnTouchListener (): ?ChartTouchListener<ChartModel<D,S,E>,D,S,E>
    
    /*
     * 获取标记点位置
     * 
     * 参数 high - 高亮显示对象
     * 返回值 Array<Float64> - 位置集合
     */
    public open func getMarkerPosition (high: Highlight): Array<Float64>
    
    /*
     * 返回负责对图表值进行动画处理的动画制作者。
     * 
     * 返回值 ?ChartAnimator - 动画管理类。
     *                      - ChartAnimator
     *                      - Option<ChartAnimator>.None
     */
    public func getAnimator (): ?ChartAnimator
    
    /*
     * 如果设置为 true，则图表在润色后继续滚动默认值：true
     * 
     * 返回值 Bool - true/false
     */
    public func isDragDecelerationEnabled (): Bool
    
    /*
     * 设置是否开启惯性滑动
     * 
     * 参数 enabled - true/false
     */
    public func setDragDecelerationEnabled (enabled: Bool)
    
    /*
     * 获取拖动减速摩擦系数
     * 
     * 返回值 Float64 - 摩擦系数
     */
    public func getDragDecelerationFrictionCoef (): Float64
    
    /*
     * 设置拖动减速摩擦系数
     * 
     * 参数 newValue - 摩擦系数
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
     * 获取 X 轴对象   
     * 
     * 返回值 ?XAxis - XAxis
     *               - Option<XAxis>.None
     */
    public func getXAxis (): ?XAxis
    
    /*
     * 返回默认的数据格式化接口实现类。
     * 
     * 返回值 IValueFormatter - 数据格式化接口实现类 IValueFormatter
     */
    public func getDefaultValueFormatter (): IValueFormatter
    
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
     * 获取 Y 轴最大值
     * 
     * 返回值 Float64 - 最大值
     */
    public func getYMax (): Float64
    
    /*
     * 获取 Y 轴最小值
     * 
     * 返回值 Float64 - 最小值
     */
    public func getYMin (): Float64
    
    /*
     * 获取图表X轴最大值
     * 
     * 返回值 Float64 - 最大值
     */
    public func getXChartMax (): Float64
    
    /*
     * 获取图表X轴最小值
     * 
     * 返回值 Float64 - 最小值
     */
    public func getXChartMin (): Float64
    
    /*
     * 获取X轴范围
     * 
     * 返回值 Float64 - 
     */
    public func getXRange (): Float64
    
    /*
     * 返回图表(整个视图)的中心点的可回收的MPPointF实例。
     * 
     * 返回值 MPPointF - 可回收的MPPointF实例。
     */
    public func getCenter (): MPPointF
    
    /*
     * 获取图表宽度
     * 
     * 返回值 Float64 - 
     */
    public func getWidth (): Float64
    
    /*
     * 获取图表高度
     * 
     * 返回值 Float64 - 
     */
    public func getHeight (): Float64
    
    /*
     * 返回图表的图形绘制的中心区域的可回收的MPPointF实例。
     * 
     * 返回值 ?MPPointF - 可回收的MPPointF实例。
     *                 - MPPointF
     *                 - Option<MPPointF>.None
     */
    public func getCenterOffsets (): ?MPPointF
    
    /*
     * 设置图表额外偏移量
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
     * 获取附加到视口顶部的额外偏移
     * 
     * 返回值 Float64 - 
     */
    public func getExtraTopOffset (): Float64
    
    /*
     * 设置附加到视口右边的额外偏移
     * 
     * 参数 offset - 
     */
    public func setExtraRightOffset (offset: Float64)
    
    /*
     * 获取附加到视口右边的额外偏移
     * 
     * 返回值 Float64 - 
     */
    public func getExtraRightOffset (): Float64
    
    /*
     * 设置附加到视口底部的额外偏移
     * 
     * 参数 offset - 
     */
    public func setExtraBottomOffset (offset: Float64)
    
    /*
     * 设置附加到视口底部的额外偏移
     * 
     * 返回值 Float64 - 
     */
    public func getExtraBottomOffset (): Float64
    
    /*
     * 设置附加到视口左边的额外偏移
     * 
     * 参数 offset - 
     */
    public func setExtraLeftOffset (offset: Float64)
    
    /*
     * 设置附加到视口左边的额外偏移
     * 
     * 返回值 Float64 - 
     */
    public func getExtraLeftOffset (): Float64
    
    /*
     * 将其设置为 true 可启用图表的log输出
     * 
     * 参数 enabled - true/false
     */
    public func setLogEnabled (enabled: Bool)
    
    /*
     * 判断图表是否启用的日志输出
     * 
     * 返回值 Bool - true/false
     */
    public func isLogEnabled (): Bool
    
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
     * 获取是否禁用图表的所有手势与触摸
     * 
     * 返回值 Bool - 
     */
    public func getTouchEnabled (): Bool
    
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
     * 获取是否做了标记显示
     * 
     * 返回值 ?IMarker - IMarker
     *                - Option<IMarker>.None
     */
    public func getMarker (): ?IMarker
    
    /*
     * 获取长按标记
     * 
     * 返回值 ?IMarker - IMarker
     *                - Option<IMarker>.None
     */
    public func getLongPressMarker (): ?IMarker
    
    /*
     * 设置标记区域
     * 
     * 参数 v - IMarker
     */
    public func setMarkerView (v: IMarker)
    
    /*
     * 获取标记区域
     * 
     * 返回值 ?IMarker - IMarker
     *                - Option<IMarker>.None 
     */
    public func getMarkerView (): ?IMarker
    
    /*
     * 设置图表描述信息
     * 
     * 参数 desc - Description
     */
    public func setDescription (desc: Description)
    
    /*
     * 获取图表描述信息
     * 
     * 返回值 ?Description - Description
     *                    - Option<Description>.None
     */
    public func getDescription (): ?Description
    
    /*
     * 获取图例对象。
     * 
     * 返回值 ?Legend - 获取图例对象。
     *               - Legend
     *               - Option<Legend>.None
     */
    public func getLegend (): ?Legend
    
    /*
     * 获取图例渲染器。
     * 
     * 返回值 ?LegendRenderer - 获取图例渲染器。
     *                        - LegendRenderer
     *                       - Option<LegendRenderer>.None
     */
    public func getLegendRenderer (): ?LegendRenderer
    
    /*
     * 返回图表绘制的内容区域的矩形。
     * 
     * 返回值 MyRect - 图表绘制的内容区域的矩形。
     */
    public func getContentRect (): MyRect
    
    /*
     * 判断是否开启绘画标记点显示
     * 
     * 返回值 Bool - true/false
     */
    public func isDrawMarkerViewsEnabled (): Bool
    
    /*
     * 设置是否开启绘画标记点显示
     * 
     * 参数 enabled - true/false
     */
    public func setDrawMarkerViews (enabled: Bool)
    
    /*
     * 如果在点按值时启用了绘制标记，则返回true 
     * 
     * 返回值 Bool - true/false
     */
    public func isDrawMarkersEnabled (): Bool
    
    /*
     * 如果在长按值时启用了绘制标记，则返回true 
     * 
     * 返回值 Bool - true/false
     */
    public func isDrawLongPressMarkersEnabled (): Bool
    
    /*
     * 将此设置为true可在点击图表值时绘制用户指定的标记
     * 
     * 参数 enabled - true/false
     */
    public func setDrawMarkers (enabled: Bool)
    
    /*
     * 将此设置为true可在长按图表值时绘制用户指定的标记
     * 
     * 参数 enabled - true/false
     */
    public func setDrawLongPressMarkers (enabled: Bool)
    
    /*
     * 返回已为图表设置的 ChartData 对象。
     * 
     * 返回值 ?ChartData<S,E> - 数据对象。
     *                       - ChartData<S,E>
     *                       - Option<ChartData<S,E>>.None
     */
    public func getData (): ?ChartData<S,E>
    
    /*
     * 返回负责图表内容区域及其偏移量和维度的图表的ViewPortHandler
     * 
     * 返回值 ViewPortHandler - ViewPortHandler
     */
    public func getViewPortHandler (): ViewPortHandler
    
    /*
     * 获取图表数据渲染器。
     * 
     * 返回值 ?DataRenderer - 获取图表数据渲染器。
     *                      - DataRenderer
     *                      - Option<DataRenderer>.None
     */
    public func getRenderer (): ?DataRenderer
    
    /*
     * 设置图表数据渲染器。
     * 
     * 参数 renderer - 图表数据渲染器
     */
    public func setRenderer (renderer: ?DataRenderer)
    
    /*
     * 返回当前高亮显示条目接口。
     * 
     * 返回值 ?IHighlighter - 获取触摸点的高亮对象接口类。
     *                     - IHighlighter
     *                     - Option<IHighlighter>.None
     */
    public func getHighlighter (): ?IHighlighter
    
    /*
     * 设置高亮显示
     * 
     * 参数 highlighter - 高亮显示接口类
     */
    public func setHighlighter (highlighter: ChartHighlighter<BarLineScatterCandleBubbleDataProvider<IDataSet<EntryOhos>,EntryOhos>,IDataSet<EntryOhos>,EntryOhos>)
    
    /*
     * 返回图表(整个视图)的中心点的可回收的MPPointF实例。
     * 
     * 返回值 MPPointF - 可回收的MPPointF实例。
     */
    public func getCenterOfView (): MPPointF
    
    /*
     * 改变图表大小
     * 
     * 参数 w - 新宽
     * 参数 h - 新高
     * 参数 oldw - 旧宽
     * 参数 oldh - 旧高
     * 返回值 Unit 
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

### 1.2 饼状图 PieChart

#### 1.2.1 PiEntry Class API Description

饼状图数据结构

```cangjie
public class PiEntry <: EntryOhos {
    
    /*
     * 构造 
     * 
     * 参数 yValue - 比例值
     * 参数 label - 标签字符
     * 参数 icon - 图标图像 （cangjie UI ChartPixelMap）,默认 Option<ChartPixelMap>.None
     * 参数 data - 数据，默认 Option<Any>.None
     */
    public init(yValue: Float64, label: String, icon!: ?ChartPixelMap, data!: ?Any)
}
```

#### 1.2.2 IPieDataSet interface API Description

```cangjie
public interface  IPieDataSet <: IDataSet<PiEntry> {}

```

#### 1.2.3 PieDataSet Class API Description

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
     * 返回值 Unit 
     */
    public func setSliceSpace (spaceDp: Float64): Unit
    
    
    /*
     * 启用后，当最小值小于切片间距本身时，切片间距将为0.0。
     * 
     * 参数 autoDisable - true/false
     * 返回值 Unit 
     */
    public func setAutomaticallyDisableSliceSpacing (autoDisable: Bool): Unit
    
    
    /*
     * 设置此DataSet的突出显示的piechart切片从图表中心“移位”的距离，默认为12.0
     * 
     * 参数 shift - 距离
     * 返回值 Unit 
     */
    public func setSelectionShift (shift: Float64): Unit
        
    /*
     * 设置 x 轴值的位置
     * 
     * 参数 xValuePosition - ValuePosition
     * 返回值 Unit 
     */
    public func setXValuePosition (xValuePosition: ValuePosition): Unit
        
    /*
     * 设置 y 轴值的位置
     * 
     * 参数 yValuePosition - ValuePosition
     * 返回值 Unit 
     */
    public func setYValuePosition (yValuePosition: ValuePosition): Unit
        
    /*
     * 设置值引导线颜色
     * 
     * 参数 valueLineColor - 颜色值
     * 返回值 Unit 
     */
    public func setValueLineColor (valueLineColor: UInt32): Unit
    
    /*
     * 是否设置值引导线的颜色
     * 
     * 参数 enabled - true/false
     * 返回值 Unit 
     */
    public func setUseValueColorForLine (enabled: Bool): Unit
       
    /*
     * 设置值引导线宽度
     * 
     * 参数 valueLineWidth - 行宽
     * 返回值 Unit 
     */
    public func setValueLineWidth (valueLineWidth: Float64): Unit
       
    /*
     * 设置超出切片大小的百分比（表示偏移量
     * 
     * 参数 valueLinePart1OffsetPercentage - 百分比
     * 返回值 Unit 
     */
    public func setValueLinePart1OffsetPercentage (valueLinePart1OffsetPercentage: Float64): Unit
        
    /*
     * 设置图表上半部分的长度
     * 
     * 参数 valueLinePart1Length - 长度
     * 返回值 Unit 
     */
    public func setValueLinePart1Length (valueLinePart1Length: Float64): Unit
       
    /*
     * 设置图表下半部分的长度
     * 
     * 参数 valueLinePart2Length - 长度
     * 返回值 Unit 
     */
    public func setValueLinePart2Length (valueLinePart2Length: Float64): Unit
    
    
    /*
     * 设置可变长度
     * 
     * 参数 valueLineVariableLength - true/false
     * 返回值 Unit 
     */
    public func setValueLineVariableLength (valueLineVariableLength: Bool): Unit
       
    /*
     * 设置高亮显示的扇区颜色
     * 
     * 参数 color - 颜色
     * 返回值 Unit 
     */
    public func setHighlightColor (color: UInt32): Unit

}
```

#### 1.2.4 PieData Class API Description

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
     * 返回值 Unit 
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
     * 返回值 Float64
     */
    public func getYValueSum (): Float64
}
```

#### 1.2.5 PieChartModel Class API Description

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
     * 返回值 Unit 
     */
    public func setHoleColor (color: UInt32): Unit
    
    /*
     * 启用或禁用孔后面切片内部尖端的可见性
     * 
     * 参数 enable - true/false
     * 返回值 Unit 
     */
    public func setDrawSlicesUnderHole (enable: Bool): Unit
  
    
    /*
     * 将此设置为true将饼图中心画为空
     * 
     * 参数 enabled - true/false
     * 返回值 Unit 
     */
    public func setDrawHoleEnabled (enabled: Bool): Unit
    
    
    /*
     * 设置显示在 PieChart 中心的文本 String。
     * 
     * 参数 text - 文本
     * 返回值 Unit 
     */
    public func setCenterText (text: String): Unit
       
    /*
     * 将其设置为true以绘制显示在扇形图中心的文字
     * 
     * 参数 enabled - true/false
     * 返回值 Unit 
     */
    public func setDrawCenterText (enabled: Bool): Unit
    
    /*
     * 设置中心文本绘制的字体
     * 
     * 参数 t - 字体
     * 返回值 Unit 
     */
    public func setCenterTextTypeface (t: FontFamily): Unit
    
    /*
     * 设置PieChart的中心文本的大小。
     * 
     * 参数 sizeDp - 字体大小
     * 返回值 Unit 
     */
    public func setCenterTextSize (sizeDp: Float64): Unit
    
    /*
     * 设置PieChart中心文本的大小(以像素为单位)
     * 
     * 参数 sizePixels - 大小(以像素为单位)
     * 返回值 Unit 
     */
    public func setCenterTextSizePixels (sizePixels: Float64): Unit
    
    /*
     * 设置中心文本相对于原始位置的偏移量。默认的x=0，y=0
     * 
     * 参数 x - x偏移量
     * 参数 y - y偏移量
     * 返回值 Unit 
     */
    public func setCenterTextOffset (x: Float64, y: Float64): Unit
    
    
    /*
     * 设置PieChart中心文本的颜色。
     * 
     * 参数 color - 中心文本的颜色
     * 返回值 Unit 
     */
    public func setCenterTextColor (color: UInt32): Unit
    
    /*
     * 以最大半径的百分比设置图中心孔的半径(max=整个图表的半径)，默认为50%
     * 
     * 参数 percent - 百分比
     * 返回值 Unit 
     */
    public func setHoleRadius (percent: Float64): Unit
      
    /*
     * 设置圈应有的颜色。
     * 
     * 参数 color - 颜色
     * 返回值 Unit 
     */
    public func setTransparentCircleColor (color: UInt32): Unit
    
    /*
     * 设置圆的半径，该圆画在图中的孔旁边，以最大半径的百分比(max=整个图表的半径)，默认为55%->表示默认比中心孔大5% *
     * 
     * 参数 percent - 百分比
     * 返回值 Unit 
     */
    public func setTransparentCircleRadius (percent: Float64): Unit
       
    /*
     * 设置圈的透明度，0=完全透明，255=完全不透明。默认值为100。*
     * 
     * 参数 alpha - 透明度
     * 返回值 Unit 
     */
    public func setTransparentCircleAlpha (alpha: Float64): Unit
    
    /*
     * 将此设置为true则将条目标签绘制到饼图切片中*
     * 
     * 参数 enabled - true/false
     * 返回值 Unit 
     */
    public func setDrawEntryLabels (enabled: Bool): Unit
    
    
    /*
     * 设置绘制条目标签的颜色。
     * 
     * 参数 color - 颜色
     * 返回值 Unit 
     */
    public func setEntryLabelColor (color: UInt32): Unit
    
    /*
     * 为条目标签的绘制设置自定义字体。
     * 
     * 参数 tf - 字体
     * 返回值 Unit 
     */
    public func setEntryLabelTypeface (tf: FontFamily): Unit
    
    /*
     * 设置条目标签的大小。默认值:14vp
     * 
     * 参数 size - 大小
     * 返回值 Unit 
     */
    public func setEntryLabelTextSize (size: Float64): Unit
    
    /*
     * 设置是否以曲线方式绘制切片，仅在启用绘制孔且切片未在孔下绘制时起作用。*
     * 
     * 参数 enabled - true/false
     * 返回值 Unit 
     */
    public func setDrawRoundedSlices (enabled: Bool): Unit
    
    
    /*
     * 如果启用此功能，PieChart中的值将以百分数绘制，而不是以其原始值绘制,如果为IValueFormatter，提供的格式化的值将以百分比形式提供。
     * 
     * 参数 enabled - true/false
     * 返回值 Unit 
     */
    public func setUsePercentValues (enabled: Bool): Unit
    
    
    /*
     * 中心文本的限界框以饼状孔的百分比表示，默认值1.0(100%)
     * 
     * 参数 percent - 0.0-1.0
     * 返回值 Unit 
     */
    public func setCenterTextRadiusPercent (percent: Float64): Unit
     
    /*
     * 设置用于计算圆饼的最大角度。360表示它是一个完整的派图，180结果是一个半派图。默认值:360
     * 
     * 参数 maxangle - 角度
     * 返回值 Unit 
     */
    public func setMaxAngle (maxangle: Float64): Unit
    
    /* 
     * 设置角度来设置切片的最小大小，您必须调用{@link#notifyDataSetchanged()}和{@link#invalidate()}来进行更改，只有当有足够的空间让所有切片具有最小角度时才起作用。
     * 
     * 参数 minAngle - 最小大小
     * 返回值 Unit 
     */
    public func setMinAngleForSlices (minAngle: Float64): Unit
}
```

#### 1.2.6 PieChart Class API Description

饼状图组件

```cangjie
@Component
class PieChart {
    var model: PieChartModel
}
```

### 1.3 图例 Legend

图表 Legend(图例) 部件

#### 1.3.1 LegendEntry Class API Description

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

#### 1.3.2 Legend Class API Description

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
     * 返回值 Unit 
     */
    public func setEntries (entries: ArrayList<LegendEntry>): Unit
    
    
    /*
     * 添加额外图例
     * 
     * 参数 entriesParams - LegendEntry集合集合
     * 返回值 Unit 
     */
    public func setExtra (entriesParams: ArrayList<LegendEntry>): Unit
    
    /*
     * 在原始条目末尾追加条目。(如果图例已经计算过，则需要调用 notifyDataSetchanged()以使更改生效)
     * 
     * 参数 colors - 颜色集合
     * 参数 labels - 标签集合
     * 参数 entriesParams - 图例集合
     * 返回值 Unit 
     */
    public func setExtra (colors: Array<UInt32>, labels: Array<String>, entriesParams: ArrayList<LegendEntry>): Unit
    
    /*
     * 设置自定义图例的条目数组。
     * 
     * 参数 entries - LegendEntry 集合
     * 返回值 Unit 
     */
    public func setCustom (entries: ArrayList<LegendEntry>): Unit
    
    /*
     * 设置自定义图例的条目数组。
     * 
     * 参数 entries - LegendEntry 集合
     * 返回值 Unit 
     */
    public func setCustomArray (entries: Array<LegendEntry>): Unit
    
    /*
     * 禁用自定义图例项
     * 
     * 返回值 Unit 
     */
    public func resetCustom (): Unit
    
    /*
     * 设置图例的水平对齐方式
     * 
     * 参数 value - LegendHorizontalAlignment
     * 返回值 Unit 
     */
    public func setHorizontalAlignment (value: LegendHorizontalAlignment): Unit
    
    
    /*
     * 设置图例的垂直对齐方式
     * 
     * 参数 value - LegendVerticalAlignment
     * 返回值 Unit 
     */
    public func setVerticalAlignment (value: LegendVerticalAlignment): Unit
    
    
    /*
     * 设置图例的方向
     * 
     * 参数 value - LegendOrientation
     * 返回值 Unit 
     */
    public func setOrientation (value: LegendOrientation): Unit
    
    /*
     * 设置图例将在图表内部还是外部绘制
     * 
     * 参数 value - true/false
     * 返回值 Unit 
     */
    public func setDrawInside (value: Bool): Unit
    
    /*
     * 设置图例的文本方向
     * 
     * 参数 pos - LegendDirection
     * 返回值 Unit 
     */
    public func setDirection (pos: LegendDirection): Unit
    
    /*
     * 设置图例设置的当前窗体的形状
     * 
     * 参数 shape - LegendForm
     * 返回值 Unit 
     */
    public func setForm (shape: LegendForm): Unit
    
    /*
     * 设置图例窗体大小
     * 
     * 参数 size - 大小 
     * 返回值 Unit 
     */
    public func setFormSize (size: Float64): Unit
    
    
    /*
     * 设置图例窗体线宽
     * 
     * 参数 size - 线宽
     * 返回值 Unit 
     */
    public func setFormLineWidth (size: Float64): Unit
    
    /*
     * 设置图例窗体线类型
     * 
     * 参数 dashPathEffect - DashPathEffect
     * 返回值 Unit 
     */
    public func setFormLineDashEffect (dashPathEffect: DashPathEffect): Unit

    
    /*
     * 设置水平轴上图例项之间的间距，单位为像素
     * 
     * 参数 space - 间距
     * 返回值 Unit 
     */
    public func setXEntrySpace (space: Float64): Unit
    
    /*
     * 设置垂直轴上图例项之间的间距，单位为像素
     * 
     * 参数 space - 间距
     * 返回值 Unit 
     */
    public func setYEntrySpace (space: Float64): Unit
   
    /*
     * 设置窗体和实际标签/文本之间的空格
     * 
     * 参数 space - 空格
     * 返回值 Unit 
     */
    public func setFormToTextSpace (space: Float64): Unit
    
    /*
     * 是否设置文本换行显示
     * 
     * 参数 enabled - true/false
     * 返回值 Unit 
     */
    public func setWordWrapEnabled (enabled: Bool): Unit 
     
    /*
     * 设置整个图例视图的最大相对大小
     * 
     * 参数 maxSize - 大小
     * 返回值 Unit 
     */
    public func setMaxSizePercent (maxSize: Float64): Unit
    
}
```

### 1.4 文本描述

图表文本描述

```cangjie
public class Description<: ComponentBase {
    
    /*
     * 构造 
     */
    public init ()
    
    /*
     * 设置说明文本
     * 
     * 参数 text - 文本
     * 返回值 Unit 
     */
    public func setText (text: String): Unit
    
    /*
     * 设置文本位置
     * 
     * 参数 x - x 坐标
     * 参数 y - y 坐标
     * 返回值 Unit 
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

### 1.5 DefaultValueFormatter Class API Description

```
public class DefaultValueFormatter <: IValueFormatter {
    /**
     * 指定值是多少位数
     */
    public init(digits: Int64)
}
```

### 1.6 高亮

#### 1.6.1 Highlight
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
#### 1.6.2 ChartHighlighter

```cangjie
public open class ChartHighlighter<P, S, E> <: IHighlighter where P <: BarLineScatterCandleBubbleDataProvider<S, E>,
    S <: IDataSet<E>, E <: EntryOhos {
    
    public init(chart: P) 

    public open func getHighlight(x: Float64, y: Float64): ?Highlight

    public func getClosestHighlightByPixel(closestValues: ArrayList<Highlight>, x: Float64, y: Float64,
        axis: ?AxisDependency, minSelectionDistance: Float64): ?Highlight
    
}
```

#### 1.6.3 ChartHighlighter

```cangjie
public interface BarLineScatterCandleBubbleDataProvider<S, E> <: ChartInterface<S, E> where S <: IDataSet<E>,
    E <: EntryOhos {
    func getTransformer(axis: AxisDependency): ?Transformer

    func isInverted(axis: AxisDependency): Bool

    func getLowestVisibleX(): Float64

    func getHighestVisibleX(): Float64

    func getData(): ?ChartData<S, E>
}
```

### 1.7 IMarker
#### 1.7.1 IMarker interface API Description

```cangjie
public interface IMarker {

    /**
     * 返回 IMarker在x轴和y轴上的偏移量。
     */
    func getOffset(): MPPointF

    /**
     * 返回 用于绘制的特定“点”的偏移量
     *
     * 参数 posX - 标记绘制的 x 位置
     * 参数 posY - 标记绘制的 Y位置
     */
    func getOffsetForDrawingAtPoint(posX: Float64, posY: Float64): MPPointF

    /**
     * 使用给定的Canvas对象在屏幕的给定位置绘制IMarker
     *
     * 参数 canvas - CanvasRenderingContext2D
     * 参数 posX - x 偏移
     * 参数 posY - y 偏移
     */
    func draw(c: CanvasRenderingContext2D, posX: Float64, posY: Float64, e: EntryOhos, highlight: Highlight): Unit
}

```
#### 1.7.2 MarkerView class API Description

```cangjie

public class MarkerView <: IMarker {
    /**
     * 初始化构造
     */
    public init()
    
    /**
     * 设置指定的点的偏移量
     *
     * 参数 offset - 指定点
     */
    public func setOffsetByMPPointF(offset: MPPointF)
    
    /**
     * 设置指定的点的偏移量
     *
     * 参数 posX - 标记绘制的 x 位置
     * 参数 posY - 标记绘制的 Y位置
     */
    public func setOffset(offsetX: Float64, offsetY: Float64): Unit 
    
    /**
     * 返回 IMarker在x轴和y轴上的偏移量。
     */
    public func getOffset(): MPPointF
    
    /**
     * 返回 用于绘制的特定“点”的偏移量
     *
     * 参数 posX - 标记绘制的 x 位置
     * 参数 posY - 标记绘制的 Y位置
     */
    public func setChartView(chart: ChartModel<ChartData<IDataSet<EntryOhos>, EntryOhos>, IDataSet<EntryOhos>, EntryOhos>): Unit
    
    /**
     * 返回 用于绘制的特定“点”的偏移量
     *
     * 参数 posX - 标记绘制的 x 位置
     * 参数 posY - 标记绘制的 Y位置
     */
    public func getChartView(): ?ChartModel<ChartData<IDataSet<EntryOhos>, EntryOhos>, IDataSet<EntryOhos>, EntryOhos> 
    
    /**
     * 返回 用于绘制的特定“点”的偏移量
     *
     * 参数 posX - 标记绘制的 x 位置
     * 参数 posY - 标记绘制的 Y位置
     */
    public func getOffsetForDrawingAtPoint(posX: Float64, posY: Float64): MPPointF
    
    /**
     * 使用给定的Canvas对象在屏幕的给定位置绘制IMarker
     *
     * 参数 canvas
     * 参数 posX
     * 参数 posY
     */
    public func draw(c: CanvasRenderingContext2D, posX: Float64, posY: Float64, e: EntryOhos, highlight: Highlight) 
}

```

### 1.8 其他接口

#### 1.8.1 ChartPixelMap Class API Description

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
     * 参数 width - 宽度
     */
    public func setWidth (width: Int64)
     
    /*
     * 设置图像高度
     * 
     * 参数 height - 高度
     */
    public func setHeight (height: Int64) 
}
```

#### 1.8.2 MPPointF Class API Description

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

#### 1.8.3 enum

##### 1.8.3.1 FontFamily

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


##### 1.8.3.2 LegendForm

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

##### 1.8.3.3 ValuePosition

数值位置
```cangjie
public enum ValuePosition <: Equatable<ValuePosition> {
    | INSIDE_SLICE
    | OUTSIDE_SLICE

    public operator func ==(b: ValuePosition): Bool

    public operator func !=(b: ValuePosition): Bool
}
```

##### 1.8.3.4 LegendHorizontalAlignment

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

##### 1.8.3.5 LegendOrientation

图例水平垂直方向

```cangjie
public enum LegendOrientation {
    | HORIZONTAL
    | VERTICAL

    public operator func ==(b: LegendOrientation): Bool

    public operator func !=(b: LegendOrientation): Bool
}
```

##### 1.8.3.6 LegendDirection

图例从左到右、从右到左方向

```cangjie
public enum LegendDirection {
    | LEFT_TO_RIGHT
    | RIGHT_TO_LEFT

    public operator func ==(b: LegendDirection): Bool

    public operator func !=(b: LegendDirection): Bool
}
```

##### 1.8.3.7 LegendVerticalAlignment

图例垂直对齐方式

```cangjie
public enum LegendVerticalAlignment {
    TOP | CENTER | BOTTOM

    public operator func ==(b: LegendVerticalAlignment): Bool

    public operator func !=(b: LegendVerticalAlignment): Bool
}
```

### 1.9 饼图示例

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

### 1.10 柱状图 BarChart

#### 1.10.1 垂直柱状图

##### 1.10.1.1 BarEntry Class API Description

柱状图数据结构

```cangjie
public class BarEntry <: EntryOhos {
    /*
     * 构造 
     * 
     * 参数 x - x 值
     * 参数 y - y 值
     * 参数 icon - 图标图像 （cangjie UI ChartPixelMap）,默认 Option<ChartPixelMap>.None
     * 参数 data - 数据，默认 Option<Any>.None  
     */
    public init(x: Float64, y: Float64, icon!: ?ChartPixelMap, data!: ?Any)
    
    /*
     * 构造 
     * 
     * 参数 x - x 值
     * 参数 y - y 值集合
     * 参数 icon - 图标图像 （cangjie UI ChartPixelMap）,默认 Option<ChartPixelMap>.None
     * 参数 data - 数据，默认 Option<Any>.None
     */
    public init(x: Float64, y: Array<Float64>, icon!: ?ChartPixelMap, data!: ?Any)
}
```
##### 1.10.1.2 IBarDataSet interface API Description

```cangjie
public interface IBarDataSet <: IBarLineScatterCandleBubbleDataSet<BarEntry> {
    public func getFills(): ?ArrayList<Fill>

    public func getFill(index: Int64): Fill

    /**
     * 判断是否堆叠
     *
     * 返回 Bool
     */
    public func isStacked(): Bool

    /**
     * 获取堆叠数目
     *
     * 返回 Int64
     */
    public func getStackSize(): Int64

    /**
     * 获取条形背后阴影的颜色
     *
     * 返回 UInt32
     */
    public func getBarShadowColor(): UInt32

    /**
     * 获取条形图宽度
     *
     * 返回 Float64
     */
    public func getBarBorderWidth(): Float64

    /**
     * 获取条形图颜色
     *
     * 返回 UInt32
     */
    public func getBarBorderColor(): UInt32

    /**
     * 获取高亮透明度
     *
     * 返回 Float64
     */
    public func getHighLightAlpha(): Float64

    /**
     * 获取堆叠条目的标签
     *
     * 返回 Array<String>
     */
    public func getStackLabels(): Array<String>
}

```

##### 1.10.1.3 BarDataSet Class API Description
```cangjie
public open class BarDataSet<: BarLineScatterCandleBubbleDataSet<BarEntry> & IBarDataSet {
    
    /*
     * 构造 
     * 
     * 参数 yVals - BarEntry 集合
     * 参数 label - 标签
     */
    public init (yVals: ArrayList<BarEntry>, label: String)
    
    /*
     * 创建副本
     * 
     * 返回值 DataSet<BarEntry> - 柱状图数据集
     */
    public func copy (): DataSet<BarEntry>
    
    /*
     * 设置渐变色的开始和结束颜色
     * 
     * 参数 startColor - 开始颜色
     * 参数 endColor - 结束颜色
     * 返回值 Unit 
     */
    public func setGradientColor (startColor: UInt32, endColor: UInt32): Unit
    
    /*
     * 设置数据集条形图的填充
     * 
     * 参数 fills - 填充集合
     * 返回值 Unit 
     */
    public func setFills (fills: ArrayList<Fill>): Unit
    
    /*
     * 设置条形图阴影颜色
     * 
     * 参数 color - 颜色
     * 返回值 Unit 
     */
    public func setBarShadowColor (color: UInt32): Unit
    
    /*
     * 设置条形图边框宽度
     * 
     * 参数 width - 宽度
     * 返回值 Unit 
     */
    public func setBarBorderWidth (width: Float64): Unit
    
    /*
     * 设置条形图边框颜色
     * 
     * 参数 color - 颜色
     * 返回值 Unit 
     */
    public func setBarBorderColor (color: UInt32): Unit
    
    /*
     * 设置高亮透明度
     * 
     * 参数 alpha - 透明度
     * 返回值 Unit 
     */
    public func setHighLightAlpha (alpha: Float64): Unit
    
    /*
     * 设置堆叠标签
     * 
     * 参数 labels - 标签
     * 返回值 Unit 
     */
    public func setStackLabels (labels: Array<String>): Unit
}
```

##### 1.10.1.4  BarData Class API Description
```cangjie
public open class BarData<: BarLineScatterCandleBubbleData<IBarDataSet, BarEntry> {
    
    /*
     * 构造
     */
    public init ()
    
    /*
     * 构造 
     * 
     * 参数 dataSets - 柱状图数据集合
     */
    public init (dataSets: Array<IBarDataSet>)
    
    /*
     * 构造 
     * 
     * 参数 dataSets - 柱状图数据集合
     */
    public init (dataSets: ArrayList<IBarDataSet>)
    
    /*
     * 设置每个条形图在坐标轴上的宽度，默认 0.85
     * 
     * 参数 mBarWidth - 宽度
     * 返回值 Unit 
     */
    public func setBarWidth (mBarWidth: Float64): Unit
    
    /*
     * 获取每个条形图在坐标轴上的宽度
     * 
     * 返回值 Float64 - 宽度
     */
    public func getBarWidth (): Float64
    
    /*
     * 设置顶部圆角半径
     * 
     * 参数 radius - 圆角半径
     * 返回值 Unit 
     */
    public func setTopRadius (radius: Float64): Unit
    
    /*
     * 获取顶部圆角半径
     * 
     * 返回值 Float64 - 半径
     */
    public func getTopRadius (): Float64
    
    /*
     * 将指定条目分组
     * 
     * 参数 fromX - x轴上分组的起始点
     * 参数 groupSpace - 组之间的间距
     * 参数 barSpace - 各条目之间的间距
     * 返回值 Unit 
     */
    public func groupBars (fromX: Float64, groupSpace: Float64, barSpace: Float64): Unit
    
    /*
     * 获取单个条形组在x轴上的宽度
     * 
     * 参数 groupSpace - 组之间的间距
     * 参数 barSpace - 各条目之间的间距
     * 返回值 Float64 - 宽度
     */
    public func getGroupWidth (groupSpace: Float64, barSpace: Float64): Float64
}

```

##### 1.10.1.5 BarDataProvider interface API Description
```cangjie
public interface BarDataProvider <: BarLineScatterCandleBubbleDataProvider<IBarDataSet, BarEntry> {
    /*
     * 获取柱状图条目
     * 
     * 返回值 ?BarData - 柱状图条目
     */
    func getBarData(): ?BarData
    
    /*
     * 判断是否绘制柱状图阴影
     * 
     * 返回值 Bool - true/false
     */
    func isDrawBarShadowEnabled(): Bool
    
    /*
     * 判断是否在条形图上方绘制值
     * 
     * 返回值 Bool - true/false
     */
    func isDrawValueAboveBarEnabled(): Bool
    
    /*
     * 判断条形图是否高亮
     * 
     * 返回值 Bool - true/false
     */
    func isHighlightFullBarEnabled(): Bool
}
```
##### 1.10.1.6  BarChartModel Class API Description
```cangjie
public open class BarChartModel<: BarLineChartBaseModel<BarData, IBarDataSet, BarEntry> & BarDataProvider {
    
    /*
     * 创建 BarChartModel 示例
     * 
     * 返回值 BarChartModel - BarChartModel
     */
    public static func build (): BarChartModel
    
    /*
     * 设置绘图工具
     * 
     * 参数 context2d - CanvasRenderingContext2D
     */
    public func setContext2D (context2d: CanvasRenderingContext2D)
    
    /*
     * 图标尺寸改变
     * 
     * 参数 newWidth - 新宽
     * 参数 newHeight - 新高
     * 参数 oldWidth - 旧宽
     * 参数 oldHeight - 旧高
     */
    public func onChartSizeChanged (newWidth: Float64, newHeight: Float64, oldWidth: Float64, oldHeight: Float64)
    
    /*
     * 绘图
     * 
     * 参数 c - 标准库画布工具
     * 返回值 Unit 
     */
    public func onDraw (c: CanvasRenderingContext2D): Unit
    
    /*
     * 获取接触点的高亮对象
     * 
     * 参数 x - x值
     * 参数 y - y值
     * 返回值 ?Highlight - 高亮
     */
    public open func getHighlightByTouchPoint (x: Float64, y: Float64): ?Highlight
    
    
    /*
     * 设置值是否在条形图的上方绘制
     * 
     * 参数 enabled - true/false
     * 返回值 Unit 
     */
    public func setDrawValueAboveBar (enabled: Bool): Unit
    
    /*
     * 是否设置在每个条目后面设置阴影
     * 
     * 参数 enabled - true/false
     * 返回值 Unit 
     */
    public func setDrawBarShadow (enabled: Bool): Unit
    
    /*
     * 设置是否突出显示某个条目（堆叠柱状图）
     * 
     * 参数 enabled - true/false
     * 返回值 Unit 
     */
    public func setHighlightFullBarEnabled (enabled: Bool): Unit
    
    /*
     * 给定值处设置高亮
     * 
     * 参数 x - x值
     * 参数 dataSetIndex - 条目索引
     * 参数 stackIndex - 堆叠索引
     * 返回值 Unit 
     */
    public func highlightValue (x: Float64, dataSetIndex: Int64, stackIndex: Int64): Unit
    
    /*
     * 获取柱状图条目
     * 
     * 返回值 ?BarData - 柱状图条目
     */
    public func getBarData (): ?BarData
    
    /*
     * 是否在x轴范围的两侧各增加一半条形图宽度，以使条形图完全显示出来。
     * 
     * 参数 enabled - true/false
     * 返回值 Unit 
     */
    public func setFitBars (enabled: Bool): Unit
    
    /*
     * 将指定条目分组
     * 
     * 参数 fromX - x轴上分组的起始点
     * 参数 groupSpace - 组之间的间距
     * 参数 barSpace - 各条目之间的间距
     * 返回值 Unit 
     */
    public func groupBars (fromX: Float64, groupSpace: Float64, barSpace: Float64): Unit
}
```

##### 1.10.1.6 BarChart Class API Description
```cangjie
@Component
public class BarChart {}
```
##### 1.10.1.7 示例

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

#### 1.10.2 水平柱状图

##### 1.10.2.1 HorizontalBarChartModel Class API Description

```cangjie
public class HorizontalBarChartModel<: BarChartModel {
    
    /*
     * 初始化水平柱状图
     * 
     * 返回值 HorizontalBarChartModel - 水平柱状图
     */
    public static func build (): HorizontalBarChartModel
    
    /*
     * 设置最大可见区域
     * 
     * 参数 maxXRange - 最大区域
     * 返回值 Unit 
     */
    public open func setVisibleXRangeMaximum (maxXRange: Float64): Unit
    
    /*
     * 设置最大最小可见区域
     * 
     * 参数 minXRange - 最大区域
     * 参数 maxXRange - 最小区域
     * 返回值 Unit 
     */
    public func setVisibleXRange (minXRange: Float64, maxXRange: Float64): Unit
    
    /*
     * 设置Y轴最大区域大小
     * 
     * 参数 maxYRange - 最大区域大小
     * 参数 axis - AxisDependency
     * 返回值 Unit 
     */
    public func setVisibleYRangeMaximum (maxYRange: Float64, axis: AxisDependency): Unit
    
    /*
     * 设置Y轴最小区域大小
     * 
     * 参数 minYRange - 最小区域大小
     * 参数 axis - AxisDependency
     * 返回值 Unit 
     */
    public func setVisibleYRangeMinimum (minYRange: Float64, axis: AxisDependency): Unit
    
    /*
     * 设置缩放的y最大最小范围
     * 
     * 参数 minYRange - 最小范围
     * 参数 maxYRange - 最大范围
     * 参数 axis - AxisDependency
     * 返回值 Unit 
     */
    public func setVisibleYRange (minYRange: Float64, maxYRange: Float64, axis: AxisDependency): Unit
}
```
##### 1.10.2.2 HorizontalBarChart Class API Description

```cangjie
@Component
public class HorizontalBarChart {}
```
##### 1.10.2.3 示例

```cangjie
@Entry
@Component
class HorizontalBarChartPage {
    private var title: String = "Horizontal"
    private var model: HorizontalBarChartModel = HorizontalBarChartModel.build()
    private var leftAxis: ?YAxis = Option<YAxis>.None
    private var rightAxis: ?YAxis = Option<YAxis>.None
    private var xAxis: ?XAxis = Option<XAxis>.None

    func aboutToAppear(): HorizontalBarChartModel {
        this.model = HorizontalBarChartModel.build()
        this.model.animateX(1000, easing: "linear")

        this.model.setDrawBarShadow(false)
        this.model.setDrawValueAboveBar(true)

        let description: Description = this.model.getDescription()

        description.setEnabled(false)

        this.model.setPinchZoom(false)
        this.model.setDrawGridBackground(false)

        let xAxis: ?XAxis = this.model.getXAxis()
        if (let Some(xaxis) <- this.xAxis) {
            xaxis.setPosition(XAxisPosition.BOTTOM)
            xaxis.setDrawGridLines(false)
            xaxis.setGranularity(1.0)
            xaxis.setLabelCount(7, Option<Bool>.None)
            xaxis.setDrawAxisLine(true)
        }

        let leftAxis: ?YAxis = this.model.getAxisLeft()
        if (let Some(leftaxis) <- this.leftAxis) {
            leftaxis.setLabelCount(8, false)
            leftaxis.setPosition(YAxisLabelPosition.OUTSIDE_CHART)
            leftaxis.setDrawAxisLine(true)
        }

        let rightAxis: ?YAxis = this.model.getAxisRight()
        if (let Some(rightaxis) <- this.rightAxis) {
            rightaxis.setLabelCount(8, false)
            rightaxis.setDrawGridLines(false)
            rightaxis.setDrawAxisLine(true)
        }

        let legend: ?Legend = this.model.getLegend()
        if (let Some(l) <- legend) {
            l.setEnabled(false)
        }
        this.model.setFitBars(true)
        this.setData(10, 50)
        return this.model
    }

    private func setData(count: Int64, range: Int64): Unit {
        let startAxis: Int64 = 0
        let endAxis: Int64 = startAxis + count

        let values: ArrayList<BarEntry> = ArrayList<BarEntry>()
        for (i in startAxis..endAxis) {
            let val = Random().nextFloat64() * Float64(range)
            values.append(BarEntry(Float64(i), val))
        }

        let dataSet: BarDataSet = BarDataSet(values, "DataSet")
        dataSet.setHighLightColor(0x000000)
        dataSet.setDrawIcons(false)

        dataSet.setColorByColor(0x8CEAFF)

        let dataSetList: ArrayList<IBarDataSet> = ArrayList<IBarDataSet>()
        dataSetList.append(dataSet)

        let barData: BarData = BarData(dataSetList)
        barData.setValueTextSize(10.0)
        barData.setBarWidth(0.9)

        this.model.setData(barData)
    }

    func render() {
        Column {
            Text(this.title).fontSize(21).fontColor(Color.WHITE).fontWeight(FontWeight.W600).layoutWeight(1).maxLines(1)
            HorizontalBarChart(model: aboutToAppear())
        }.width(100.percent).height(70.percent).backgroundColor(Color.WHITE)
    }
}

```

#### 1.10.3  坐标轴

##### 1.10.3.1 AxisBase  interface API Description

```cangjie
public abstract class AxisBase<: ComponentBase {
    /*
     * 构造 
     * 
     */
    public init ()
    
    /*
     * 设置轴上的最小标签数
     * 
     * 参数 labels - 标签数
     * 返回值 Unit 
     */
    public func setAxisMinLabels (labels: Int64): Unit
    
    /*
     * 设置轴上的最大标签数
     * 
     * 参数 labels - 标签数
     * 返回值 Unit 
     */
    public func setAxisMaxLabels (labels: Int64): Unit
    
    /*
     * 是否设置网格线
     * 
     * 参数 enabled - true/false
     * 返回值 Unit 
     */
    public func setDrawGridLines (enabled: Bool): Unit
    
    /*
     * 是否设置轴线
     * 
     * 参数 enabled - true/false
     * 返回值 Unit 
     */
    public func setDrawAxisLine (enabled: Bool): Unit
    
    /*
     * 设置轴标签是否居中显示
     * 
     * 参数 enabled - true/false
     * 返回值 Unit 
     */
    public func setCenterAxisLabels (enabled: Bool): Unit
    
    /*
     * 设置网格线颜色
     * 
     * 参数 color - 颜色
     * 返回值 Unit 
     */
    public func setGridColor (color: Color): Unit
    
    /*
     * 设置轴线宽度
     * 
     * 参数 width - 宽度
     * 返回值 Unit 
     */
    public func setAxisLineWidth (width: Float64): Unit
    
    /*
     * 设置网格线宽度
     * 
     * 参数 width - 宽度
     * 返回值 Unit 
     */
    public func setGridLineWidth (width: Float64): Unit
    
    /*
     * 设置轴线颜色
     * 
     * 参数 color - 颜色
     * 返回值 Unit 
     */
    public func setAxisLineColor (color: Color): Unit
    
    /*
     * 是否设置标签显示
     * 
     * 参数 enabled - true/false
     * 返回值 Unit 
     */
    public func setDrawLabels (enabled: Bool): Unit
    
    /*
     * 设置标签数量
     * 
     * 参数 count - 标签数量
     * 参数 force - true/false
     * 返回值 Unit 
     */
    public func setLabelCount (count: Int64, force: ?Bool): Unit
    
    /*
     * 是否设置轴上的粒度显示
     * 
     * 参数 enabled - true/false
     * 返回值 Unit 
     */
    public func setGranularityEnabled (enabled: Bool): Unit
    
    /*
     * 放大时设置轴上的最小间隔
     * 
     * 参数 granularity - 最小间隔
     * 返回值 Unit 
     */
    public func setGranularity (granularity: Float64): Unit
    
    /*
     * 添加限制线
     * 
     * 参数 l - 限制线
     * 返回值 Unit 
     */
    public func addLimitLine (l: LimitLine): Unit
    
    /*
     * 添加网格线 
     * 
     * 参数 customLine - 网格线接口
     */
    public func addGridLine (customLine: GridLineConfig)
    
    /*
     * 移除限制线
     * 
     * 参数 l - 限制线
     * 返回值 Unit 
     */
    public func removeLimitLine (l: LimitLine): Unit
    
    /*
     * 移除所有限制线
     * 
     * 返回值 Unit 
     */
    public func removeAllLimitLines (): Unit
    
    /*
     * 如果设置为true，则在实际数据后面绘制LimitLines，否则在顶部绘制。默认值:false
     * 
     * 参数 enabled - true/false
     * 返回值 Unit 
     */
    public func setDrawLimitLinesBehindData (enabled: Bool): Unit
    
    
    /*
     * 如果设置为false，网格线将绘制在实际数据的顶部，否则绘制在后面。默认值:true
     * 
     * 参数 enabled - true/false
     * 返回值 Unit 
     */
    public func setDrawGridLinesBehindData (enabled: Bool): Unit
    
    /*
     * 设置轴值的数据格式
     * 
     * 参数 f - 坐标轴值格式
     * 返回值 Unit 
     */
    public func setValueFormatter (f: IAxisValueFormatter): Unit
    
    /*
     * 获取轴值的数据格式
     * 
     * 返回值 ?IAxisValueFormatter - 坐标轴值格式
     */
    public func getValueFormatter (): ?IAxisValueFormatter
    
    /*
     * 使网格线以虚线模式绘制
     * 
     * 参数 lineLength - 长度
     * 参数 spaceLength - 间隔
     * 参数 phase - 偏移
     * 返回值 Unit 
     */
    public func enableGridDashedLine (lineLength: Int64, spaceLength: Int64, phase: Int64): Unit
    
    /*
     * 设置网格线的形式
     * 
     * 参数 effect - 虚线接口
     * 返回值 Unit 
     */
    public func setGridDashedLine (effect: DashPathEffect): Unit
    
    /*
     * 禁用以虚线模式绘制的网格线。
     * 
     * 返回值 Unit 
     */
    public func disableGridDashedLine (): Unit
    
    
    /*
     * 获取网格线的形式
     * 
     * 返回值 DashPathEffect - 虚线接口
     */
    public func getGridDashPathEffect (): DashPathEffect
    
    /*
     * 是否允许以虚线模式绘制轴线
     * 
     * 参数 lineLength - 线长
     * 参数 spaceLength - 间隔
     * 参数 phase - 偏移
     * 返回值 Unit 
     */
    public func enableAxisLineDashedLine (lineLength: Int64, spaceLength: Int64, phase: Int64): Unit
    
    /*
     * 设置轴线为虚线
     * 
     * 参数 effect - 虚线接口
     * 返回值 Unit 
     */
    public func setAxisLineDashedLine (effect: DashPathEffect): Unit
    
    /*
     * 禁用以虚线模式绘制轴线
     * 
     * 返回值 Unit 
     */
    public func disableAxisLineDashedLine (): Unit
    
    
    /*
     * 返回为轴线设置的DashPathEffect
     * 
     * 返回值 DashPathEffect - 虚线接口
     */
    public func getAxisLineDashPathEffect (): DashPathEffect
    
    /*
     * 重置轴线的最大值
     * 
     * 返回值 Unit 最大值
     */
    public func resetAxisMaximum (): Unit
    
    /*
     * 重置轴线的最小值
     * 
     * 返回值 Unit 最小值
     */
    public func resetAxisMinimum (): Unit
    
    /*
     * 设置轴线最小值
     * 
     * 参数 min - 最小值
     * 返回值 Unit 
     */
    public func setAxisMinimum (min: Float64): Unit
    
    /*
     * 设置轴线的最大值
     * 
     * 参数 max - 最大值
     * 返回值 Unit 
     */
    public func setAxisMaximum (max: Float64): Unit
    
    /*
     * 设置额外最小间距
     * 
     * 参数 mSpaceMin - 间距
     * 返回值 Unit 
     */
    public func setSpaceMin (mSpaceMin: Float64): Unit
    
    /*
     * 设置额外最大间距
     * 
     * 参数 mSpaceMax - 间距
     * 返回值 Unit 
     */
    public func setSpaceMax (mSpaceMax: Float64): Unit
}
```

##### 1.10.3.2 XAxis interface API Description
X轴
```cangjie
public class XAxis<: AxisBase {
    
    /*
     * 构造 
     * 
     */
    public init ()
    
    /*
     * 设置轴位置
     * 
     * 参数 pos - 位置
     * 返回值 Unit 
     */
    public func setPosition (pos: XAxisPosition): Unit
    
    /*
     * 设置绘制X轴标签的角度
     * 
     * 参数 angle - 角度
     * 返回值 Unit 
     */
    public func setLabelRotationAngle (angle: Int64): Unit
    
    /*
     * 如果设置为true，将避免图表中第一个和最后一个标签从图表边缘或屏幕上“剪切”
     * 
     * 参数 enabled - true/false
     * 返回值 Unit 
     */
    public func setAvoidFirstLastClipping (enabled: Bool): Unit
    
    /*
     * 设置X轴数据偏移量
     * 
     * 参数 xOffset - 偏移量 
     * 返回值 Unit 
     */
    public func setLabelXOffset (xOffset: Int64): Unit
    
    /*
     * 设置x标签的位置
     * 
     * 参数 position - x轴标签位置
     * 返回值 Unit 
     */
    public func setXAxisLabelPosition (position: XAxisLabelPosition): Unit
    
    /*
     * 设置自定义标签数组
     * 
     * 参数 numbers - 标签数组
     * 返回值 Unit 
     */
    public func setCustomLabels (numbers: Array<Float64>): Unit
    
    /*
     * 设置是否绘制自定义标签
     * 
     * 参数 flag - true/false
     * 返回值 Unit 
     */
    public func setDrawCustomLabels (flag: Bool): Unit
}
```
##### 1.10.3.3 YAxis Class API Description
Y轴
```cangjie
public class YAxis<: AxisBase {
    
    /*
     * 构造 
     * 
     * 参数 position - y位置
     */
    public init (position: ?AxisDependency)
    
    /*
     * 设置Y轴最小宽度
     * 
     * 参数 minWidth - 宽度
     * 返回值 Unit 
     */
    public func setMinWidth (minWidth: Float64): Unit
    
    /*
     * 设置Y轴最大宽度
     * 
     * 参数 maxWidth - 宽度
     * 返回值 Unit 
     */
    public func setMaxWidth (maxWidth: Float64): Unit
    
    /*
     * 设置Y轴位置
     * 
     * 参数 pos - 位置
     * 返回值 Unit 
     */
    public func setPosition (pos: YAxisLabelPosition): Unit
    
    /*
     * 设置Y轴数据偏移量
     * 
     * 参数 xOffset - 偏移量
     * 返回值 Unit 
     */
    public func setLabelXOffset (xOffset: Float64): Unit
    
    /*
     * 将此设置为true以启用绘制顶部y-label条目
     * 
     * 参数 enabled - true/false
     * 返回值 Unit 
     */
    public func setDrawTopYLabelEntry (enabled: Bool): Unit
    
    /*
     * 设置y轴反转
     * 
     * 参数 enabled - true/false
     * 返回值 Unit 
     */
    public func setInverted (enabled: Bool): Unit
    
    /*
     * 设置顶轴空间占整个范围的百分比。
     * 
     * 参数 percent - 百分比
     * 返回值 Unit 
     */
    public func setSpaceTop (percent: Float64): Unit
    
    /*
     * 设置底部轴空间占整个范围的百分比
     * 
     * 参数 percent - 百分比
     * 返回值 Unit 
     */
    public func setSpaceBottom (percent: Float64): Unit
    
    /*
     * 将此设置为true以绘制零线，而不管是否启用了其他网格线。默认值:false
     * 
     * 参数 mDrawZeroLine - true/false
     * 返回值 Unit 
     */
    public func setDrawZeroLine (mDrawZeroLine: Bool): Unit
    
    /*
     * 设置零线颜色
     * 
     * 参数 color - 颜色
     * 返回值 Unit 
     */
    public func setZeroLineColor (color: Color): Unit
    
    /*
     * 设置零线宽度
     * 
     * 参数 width - 宽度
     * 返回值 Unit 
     */
    public func setZeroLineWidth (width: Float64): Unit
}
```

##### 1.10.3.4 LimitLine Class API Description
限制线
```cangjie
public class LimitLine<: ComponentBase {
    
    /*
     * 构造 
     * 
     * 参数 limit - 限制线
     */
    public init (limit: Float64)
    
    /*
     * 构造 
     * 
     * 参数 limit - 限制线
     * 参数 label - 标签
     */
    public init (limit: Float64, label: String)
    
    /*
     * 设置限制线的宽度
     * 
     * 参数 width - 宽度
     */
    public func setLineWidth (width: Float64)
    
    /*
     * 设置限制线的颜色
     * 
     * 参数 color - 颜色
     */
    public func setLineColor (color: Int64)
    
    /*
     * 设置限制线位虚线
     * 
     * 参数 lineLength - 线长
     * 参数 spaceLength - 虚线间隔
     * 参数 phase - 偏移
     */
    public func enableDashedLine (lineLength: Int64, spaceLength: Int64, phase: Int64)
    
    /*
     * 禁用虚线
     */
    public func disableDashedLine ()
    
    /*
     * 返回为此LimitLine设置的DashPathEffect
     * 
     * 返回值 ?DashPathEffect - 虚线设置类
     */
    public func getDashPathEffect (): ?DashPathEffect
    
    /*
     * 设置文本样式
     * 
     * 参数 style - 样式
     */
    public func setTextStyle (style: Style)
    
    /*
     * 设置标签位置
     * 
     * 参数 pos - 位置
     */
    public func setLabelPosition (pos: LimitLabelPosition)
    
    /*
     * 设置标签内容
     * 
     * 参数 label - 标签
     */
    public func setLabel (label: String)
}
```

##### 1.10.3.5 GridLineConfig Class API Description
网格线
```cangjie
public class GridLineConfig {
    /*
     * 构造 
     * 
     * 参数 position - 位置
     * 参数 lineColor - 颜色
     * 参数 lineWidth - 宽度
     * 参数 dashPathEffect - 是否虚线
     */
    public init(position: Float64, lineColor: Int64, lineWidth: Float64, dashPathEffect: ?DashPathEffectConfig)
}
```

##### 1.10.3.6 ValueFormatter

###### 1.10.3.6.1 IAxisValueFormatter
```cangjie
public interface IAxisValueFormatter {
    /*
     * 获取坐标轴值格式 
     * 
     * 参数 value - 值
     * 参数 axis - 坐标轴父类
     * 返回 String
     */
    func getFormattedValue(value: Float64, axis: AxisBase): String
}
```
###### 1.10.3.6.2 DefaultAxisValueFormatter

```cangjie
public class DefaultAxisValueFormatter<: IAxisValueFormatter {
    
    /*
     * 构造 
     * 
     * 参数 digits - 值格式化位数
     */
    public init (digits: Int64)
    
    /*
     * 获取格式化后的值
     * 
     * 参数 value - 值
     * 参数 axis - 坐标轴
     * 返回值 String - 格式化后的值
     */
    public func getFormattedValue (value: Float64, axis: AxisBase): String
    
    /*
     * 获取小数位数
     * 
     * 返回值 Int64 - 小数位数
     */
    public func getDecimalDigits (): Int64
}
```


#### 1.10.4 柱状图父类

##### 1.10.4.1 IBarLineScatterCandleBubbleDataSet interface API Description

```cangjie
public interface  IBarLineScatterCandleBubbleDataSet<E> <: IDataSet<E> where E <: EntryOhos {
    /*
     * 获取高亮颜色
     * 
     * 返回值 UInt32 - 16进制颜色
     */
    public func getHighLightColor(): UInt32
}
```
##### 1.10.4.2 BarLineScatterCandleBubbleDataSet abstract API Description
```cangjie
public abstract class BarLineScatterCandleBubbleDataSet<E> <: DataSet<E> where E <: EntryOhos {
    /*
     * 初始化
     * 
     * 参数 yVals - 数据结构集合
     * 参数 label - 标签
     * 返回值 UInt32 - 16进制颜色
     */
    public init (yVals: ArrayList<E>, label: String)
    
    /*
     * 设置高亮颜色
     * 
     * 参数 color - 16进制颜色
     * 返回值 Unit
     */
    public func setHighLightColor (color: UInt32): Unit
    
    /*
     * 获取高亮颜色
     * 
     * 返回值 UInt32 - 16进制颜色
     */
    public func getHighLightColor (): UInt32
}
```

##### 1.10.4.3  BarLineScatterCandleBubbleData abstract API Description
```cangjie
public abstract class BarLineScatterCandleBubbleData<S, E> <: ChartData<S, E> where S <: IBarLineScatterCandleBubbleDataSet<E>,
    E <: EntryOhos {
    
    /*
     * 初始化
     */
    public init ()
    
    /*
     * 初始化
     * 
     * 参数 sets - 数据对象集合
     */
    public init (sets: Array<S>)
    
    /*
     * 初始化
     * 
     * 参数 sets - 数据对象集合
     */
    public init (sets: ArrayList<S>)
}
```

##### 1.10.4.4 BarLineScatterCandleBubbleDataProvider interface API Description
```cangjie
public interface BarLineScatterCandleBubbleDataProvider<D, S, E> <: ChartInterface<D, S, E> where D <: ChartData<S, E>, S <: IDataSet<E>, E <: EntryOhos {
    
    /*
     * 初始化
     * 
     * 参数 axis - 坐标轴方向
     * 返回值 ?Transformer - 转换类
     */
    func getTransformer(axis: AxisDependency): ?Transformer

    /*
     * 判断是否反转
     * 
     * 参数 axis - 坐标轴方向
     * 返回值 Bool - true/false
     */
    func isInverted(axis: AxisDependency): Bool

    /*
     * 获取最小可见x值
     *
     * 返回值 Float64
     */
    func getLowestVisibleX(): Float64

    /*
     * 获取最大可见x值
     *
     * 返回值 Float64
     */
    func getHighestVisibleX(): Float64

    /*
     * 获取数据包
     *
     * 返回值 ?ChartData<S, E>
     */
    func getData(): ?ChartData<S, E>
}
```

##### 1.10.4.5 BarLineChartBaseModel abstract API Description
```cangjie
public abstract class BarLineChartBaseModel<D, S, E> <: ChartModel<D, S, E> & BarLineScatterCandleBubbleDataProvider<D, S, E> where D <: BarLineScatterCandleBubbleData<S,
    E>, S <: IBarLineScatterCandleBubbleDataSet<E>, E <: EntryOhos {
    
    /*
     * 构造 
     * 
     */
    public init ()
    
    /*
     * 是否设置长按光标显示
     * 
     * 参数 enabled - true/false
     * 返回值 Unit 
     */
    public func setLongPressCursorEnabled (enabled: Bool): Unit
    
    
    /*
     * 是否设置长按时间间隔
     * 
     * 参数 duration - 时间
     * 返回值 Unit 
     */
    public func setLongPressDuration (duration: Int64): Unit
    
    /*
     * 是否设置y坐标轴延长线
     * 
     * 参数 opt - true/false
     */
    public func setYAxisExtensionLine (opt: Bool)
    
    /*
     * 绘制图表
     * 
     * 参数 context2D - CanvasRenderingContext2D 标准库UI画布组件
     * 返回值 Unit 
     */
    public open func onDraw (context2D: CanvasRenderingContext2D): Unit
    
    /*
     * 设置可缩放的最小比例
     * 
     * 参数 scaleX - x 缩放因子
     * 参数 scaleY - y 缩放因子
     * 返回值 Unit 
     */
    public func setScaleMinima (scaleX: Float64, scaleY: Float64): Unit
    
    /*
     * 设置X轴最大可见区域
     * 
     * 参数 maxXRange - 最大区域
     * 返回值 Unit 
     */
    public open func setVisibleXRangeMaximum (maxXRange: Float64): Unit
    
    /*
     * 设置X轴最小可见区域
     * 
     * 参数 minXRange - 最小区域
     * 返回值 Unit 
     */
    public func setVisibleXRangeMinimum (minXRange: Float64): Unit
    
    /*
     * 设置X轴最大最小可见区域
     * 
     * 参数 minXRange - 最大区域
     * 参数 maxXRange - 最小区域
     * 返回值 Unit 
     */
    public open func setVisibleXRange (minXRange: Float64, maxXRange: Float64): Unit
    
    /*
     * 设置Y轴最大区域大小
     * 
     * 参数 maxYRange - 最大区域大小
     * 参数 axis - 轴位置
     * 返回值 Unit 
     */
    public open func setVisibleYRangeMaximum (maxYRange: Float64, axis: AxisDependency): Unit
    
    /*
     * 设置Y轴最小区域大小
     * 
     * 参数 minYRange - 最小区域大小
     * 参数 axis - 轴位置
     * 返回值 Unit 
     */
    public open func setVisibleYRangeMinimum (minYRange: Float64, axis: AxisDependency): Unit
    
    /*
     * 设置缩放的y最大最小范围
     * 
     * 参数 minYRange - 最小范围
     * 参数 maxYRange - 最大范围
     * 参数 axis - 轴位置
     * 返回值 Unit 
     */
    public open func setVisibleYRange (minYRange: Float64, maxYRange: Float64, axis: AxisDependency): Unit
    
    /*
     * 将当前左侧视口移动到指定的x位置
     * 
     * 参数 xValue - x轴上的指定位置
     * 返回值 Unit 
     */
    public func moveViewToX (xValue: Float64): Unit
    
    /*
     * 将使当前视图的左侧移动到x轴上的指定位置，并将视图中心移动到y轴的指定位置。
     * 
     * 参数 xValue - x轴上的指定位置
     * 参数 yValue - y轴上的指定位置
     * 参数 axis - 轴位置
     * 返回值 Unit 
     */
    public func moveViewTo (xValue: Float64, yValue: Float64, axis: AxisDependency): Unit
    
    /*
     * 将使当前视图的左侧移动到x轴上的指定位置，并将视图中心移动到y轴的指定位置,启动动画效果*
     * 
     * 参数 xValue - x轴上的指定位置
     * 参数 yValue - y轴上的指定位置
     * 参数 axis - 轴位置
     * 参数 duration - 动画间隔
     * 返回值 Unit 
     */
    public func moveViewToAnimated (xValue: Float64, yValue: Float64, axis: AxisDependency, duration: Float64): Unit
    
    /*
     * 将视口的设置为Y轴指定位置
     * 
     * 参数 yValue - Y轴指定位置
     * 参数 axis - 轴位置
     * 返回值 Unit 
     */
    public func centerViewToY (yValue: Float64, axis: AxisDependency): Unit
    
    /*
     * 将视口的设置指定位置
     * 
     * 参数 xValue - X轴指定位置
     * 参数 yValue - Y轴指定位置
     * 参数 axis - 轴位置
     * 返回值 Unit 
     */
    public func centerViewTo (xValue: Float64, yValue: Float64, axis: AxisDependency): Unit
    
    /*
     * 将视口的设置指定位置，启动动画
     * 
     * 参数 xValue - X轴指定位置
     * 参数 yValue - Y轴指定位置
     * 参数 axis - AxisDependency
     * 参数 duration - 动画间隔
     * 返回值 Unit 
     */
    public func centerViewToAnimated (xValue: Float64, yValue: Float64, axis: AxisDependency, duration: Float64): Unit
    
    /*
     * 设置当前视口的偏移量
     * 
     * 参数 left - 左
     * 参数 top - 上
     * 参数 right - 右
     * 参数 bottom - 下
     * 返回值 Unit 
     */
    public func setViewPortOffsets (left: Float64, top: Float64, right: Float64, bottom: Float64): Unit
    
    /*
     * 重置视口偏移量
     * 
     * 返回值 Unit 
     */
    public func resetViewPortOffsets (): Unit
    
    /*
     * 设置绘图监听事件
     * 
     * 参数 drawListener - 绘图监听事件
     * 返回值 Unit 
     */
    public func setOnDrawListener (drawListener: OnDrawListener): Unit
    
    /*
     * 获取绘图监听事件
     * 
     * 返回值 ?OnDrawListener - 绘图监听事件
     */
    public func getDrawListener (): ?OnDrawListener
    
    /*
     * 设置图表可绘制的最大数量
     * 
     * 参数 count - 数量
     * 返回值 Unit 
     */
    public func setMaxVisibleValueCount (count: Int64): Unit
    
    /*
     * 设置图表可绘制的最大数量
     * 
     * 返回值 Int64 - 数量 
     */
    public func getMaxVisibleCount (): Int64
    
    /*
     * 设置拖动图表时是否高亮显示
     * 
     * 参数 enabled - true/false
     * 返回值 Unit 
     */
    public func setHighlightPerDragEnabled (enabled: Bool): Unit

    
    /*
     * 设置网格线背景颜色
     * 
     * 参数 color - 颜色
     * 返回值 Unit 
     */
    public func setGridBackgroundColor (color: UInt32): Unit
    
    /*
     * 设置是否启用图表拖动效果
     * 
     * 参数 enabled - true/false
     * 返回值 Unit 
     */
    public func setDragEnabled (enabled: Bool): Unit
    
    /*
     * 设置是否启用X轴上的拖动效果
     * 
     * 参数 enabled - true/false
     * 返回值 Unit 
     */
    public func setDragXEnabled (enabled: Bool): Unit
    
    
    /*
     * 设置Y轴是否拖动
     * 
     * 参数 enabled - true/false
     * 返回值 Unit 
     */
    public func setDragYEnabled (enabled: Bool): Unit
    
    /*
     * 判断是否启用Y轴上的拖动效果 
     * 
     * 返回值 Bool - true/false
     */
    public func isDragYEnabled (): Bool
    
    /*
     * 设置是否启用缩放功能
     * 
     * 参数 enabled - true/false
     * 返回值 Unit 
     */
    public func setScaleEnabled (enabled: Bool): Unit
    
    /*
     * 设置是否启用x轴缩放功能*
     * 
     * 参数 enabled - true/false
     * 返回值 Unit 
     */
    public func setScaleXEnabled (enabled: Bool): Unit
    
    /*
     * 设置是否启用y轴缩放功能*
     * 
     * 参数 enabled - true/false
     * 返回值 Unit 
     */
    public func setScaleYEnabled (enabled: Bool): Unit
    
    /*
     * 是否设置双击图表放大
     * 
     * 参数 enabled - true/false
     * 返回值 Unit 
     */
    public func setDoubleTapToZoomEnabled (enabled: Bool): Unit
    
    /*
     * 是否设置网格背景颜色
     * 
     * 参数 enabled - true/false
     * 返回值 Unit 
     */
    public func setDrawGridBackground (enabled: Bool): Unit
    
    /*
     * 是否设置边框线
     * 
     * 参数 enabled - true/false
     * 返回值 Unit 
     */
    public func setDrawBorders (enabled: Bool): Unit
    
    /*
     * 设置值是否在矩阵中*
     * 
     * 参数 enabled - true/false
     * 返回值 Unit 
     */
    public func setClipValuesToContent (enabled: Bool): Unit
    
    /*
     * 设置数据是否在矩阵中
     * 
     * 参数 enabled - true/false
     * 返回值 Unit 
     */
    public func setClipDataToContent (enabled: Bool): Unit
    
    /*
     * 设置边框线的宽度
     * 
     * 参数 width - 宽度
     * 返回值 Unit 
     */
    public func setBorderWidth (width: Float64): Unit
    
    /*
     * 设置边框线的颜色
     * 
     * 参数 color - 颜色
     * 返回值 Unit 
     */
    public func setBorderColor (color: UInt32): Unit
    
    /*
     * 设置图表最小偏移量
     * 
     * 参数 minOffset - 偏移量
     * 返回值 Unit 
     */
    public func setMinOffset (minOffset: Float64): Unit
    
    
    /*
     * 设置图表旋转后是否保持原位置
     * 
     * 参数 keepPositionOnRotation - true/false
     * 返回值 Unit 
     */
    public func setKeepPositionOnRotation (keepPositionOnRotation: Bool): Unit
    
    /*
     * 获取左侧Y轴
     * 
     * 返回值 ?YAxis - Y轴
     */
    public func getAxisLeft (): ?YAxis
    
    /*
     * 获取右侧Y轴
     * 
     * 返回值 ?YAxis - Y轴
     */
    public func getAxisRight (): ?YAxis
    
    /*
     * 获取Y轴
     * 
     * 参数 axis - 轴位置
     * 返回值 ?YAxis - Y轴
     */
    public func getAxis (axis: AxisDependency): ?YAxis
    
    /*
     * 如果设置为真，可以用2个手指同时缩放x和y轴
     * 
     * 参数 enabled - true/false
     * 返回值 Unit 
     */
    public func setPinchZoom (enabled: Bool): Unit
    
    /*
     * 设置x拖动偏移量
     * 
     * 参数 offset - 偏移量
     * 返回值 Unit 
     */
    public func setDragOffsetX (offset: Float64): Unit
    
    /*
     * 设置y拖动偏移量
     * 
     * 参数 offset - 偏移量
     * 返回值 Unit 
     */
    public func setDragOffsetY (offset: Float64): Unit
    
    /*
     * 设置是否可在y轴上设置缩放
     * 
     * 参数 enabled - true/false
     * 返回值 Unit 
     */
    public func setAutoScaleMinMaxEnabled (enabled: Bool): Unit
    
    /*
     * 图表尺寸改变
     * 
     * 参数 w - 新宽
     * 参数 h - 新高
     * 参数 oldw - 旧宽
     * 参数 oldh - 旧高
     * 返回值 Unit 
     */
    public func onSizeChanged (w: Float64, h: Float64, oldw: Float64, oldh: Float64): Unit
}
```

#### 1.10.5 其他

##### 1.10.5.1 LimitLabelPosition
限制线标签位置

```cangjie
public enum LimitLabelPosition <: Equatable<LimitLabelPosition> {
    | LEFT_TOP
    | LEFT_BOTTOM
    | RIGHT_TOP
    | RIGHT_BOTTOM

    public operator func ==(b: LimitLabelPosition): Bool

    public operator func !=(b: LimitLabelPosition): Bool
}
```

##### 1.10.5.2 Style

限制线文本样式

```cangjie
public enum Style <: Equatable<Style> {
    | FILL
    | STROKE
    | FILL_AND_STROKE

    public operator func ==(b: Style): Bool

    public operator func !=(b: Style): Bool
}
```

##### 1.10.5.3 XAxisLabelPosition

x轴标签位置

```cangjie
public enum XAxisLabelPosition {
    | LEFT
    | CENTER
    | RIGHT

    public func toString(): String
}
```

##### 1.10.5.4 XAxisPosition

x轴位置

```cangjie
public enum XAxisPosition <: Equatable<XAxisPosition> {
    | TOP
    | BOTTOM
    | BOTH_SIDED 
    | TOP_INSIDE
    | BOTTOM_INSIDE

    public operator func ==(b: XAxisPosition): Bool
    public operator func !=(b: XAxisPosition): Bool
}
```
##### 1.10.5.5 AxisDependency

Y 轴方向

```cangjie
public enum AxisDependency <: Equatable<AxisDependency> {
    | LEFT   //左
    | RIGHT  //右

    public operator func ==(b: AxisDependency): Bool

    public operator func !=(b: AxisDependency): Bool
    public func toString(): String
}
```

##### 1.10.5.6 DashPathEffect
虚线样式
```cangjie
public class DashPathEffect {
    /*
     * 构造 
     * 
     * 参数 dash - [lineLength 虚线线段长度, spaceLength 虚线线段之间间隔]
     * 参数 offset - 偏移量
     */
    public init(dash: Array<Int64>, offset: Int64)
}
```

##### 1.10.5.8 Fill Class API Description

填充

```cangjie
public class Fill {
    
    /*
     * 构造 
     * 
     * 参数 color - 开始颜色
     * 参数 endColor - 结束颜色
     */
    public init (color: UInt32, endColor: UInt32)
    
    /*
     * 构造 
     * 
     * 参数 color - 开始颜色组
     * 参数 endColor - 结束颜色组
     */
    public init (color: Array<UInt32>, endColor: Array<Float64>)
    
    /*
     * 构造 
     * 
     * 参数 color - ChartPixelMap
     */
    public init (color: ChartPixelMap)
    
    /*
     * 构造 
     * 
     * 参数 color - 颜色数组
     */
    public init (color: Array<UInt32>)
    
    /*
     * 构造 
     * 
     * 参数 color - UInt32 颜色
     */
    public init (color: UInt32)
      
    /*
     * 设置填充样式
     * 
     * 参数 types - FillType
     * 返回值 Unit 
     */
    public func setType (types: FillType): Unit
    
  
    /*
     * 设置颜色
     * 
     * 参数 color - 颜色
     * 返回值 Unit 
     */
    public func setColor (color: UInt32): Unit
    
    /*
     * 设置渐变位置
     * 
     * 参数 positions - 渐变位置集合
     * 返回值 Unit 
     */
    public func setGradientPositions (positions: Array<Float64>): Unit
    
    /*
     * 设置渐变颜色
     * 
     * 参数 color - 颜色
     * 返回值 Unit 
     */
    public func setGradientColors (color: Array<UInt32>): Unit
    
    /*
     * 设置渐变颜色组
     * 
     * 参数 color - 开始
     * 参数 endColor - 结束
     * 返回值 Unit 
     */
    public func setGradientColors (color: UInt32, endColor: UInt32): Unit
    
    /*
     * 设置透明度
     * 
     * 参数 alpha - 透明度
     * 返回值 Unit 
     */
    public func setAlpha (alpha: Float64): Unit
    
    /*
     * 填充矩形
     * 
     * 参数 c - CanvasRenderingContext2D
     * 参数 paint - Paint
     * 参数 left - 左
     * 参数 top - 上
     * 参数 right - 右
     * 参数 bottom - 下
     * 参数 gradientDirection - 填充方向
     * 参数 radius - 圆角
     * 参数 cornerType - 圆角绘制类型
     * 返回值 Unit 
     */
    public func fillRect (c: CanvasRenderingContext2D, paint: Paint, left: Float64, top: Float64, right: Float64, bottom: Float64, gradientDirection: FillDirection, radius: Float64, cornerType: RoundCornerType): Unit
}
```


##### 1.10.5.9 FillType

填充样式

```cangjie
public enum FillType {
    | EMPTY             //空
    | COLOR             //颜色
    | LINEAR_GRADIENT   //线性渐变
    | DRAWABLE          //可绘制
}
```

##### 1.10.5.10 FillDirection

填充方向

```cangjie
public enum FillDirection <: Equatable<FillDirection> {
    | DOWN  //下
    | UP    //上
    | RIGHT //右
    | LEFT  //左
}

```
##### 1.10.5.11 RoundCornerType

矩形圆角绘制类型

```cangjie
public enum RoundCornerType {
    | UP    // 顶部
    | down  // 底部
    | both  // 都有
}
```
##### 1.10.5.12 YAxisLabelPosition

Y轴标签的位置

```cangjie
public enum YAxisLabelPosition <: Equatable<YAxisLabelPosition> {
    | OUTSIDE_CHART  //表外
    | INSIDE_CHART   //表内
}
```

##### 1.10.5.13 OnDrawListener

图表绘制时监听器

```cangjie
public interface OnDrawListener {

    /**
     * 每当用手指添加条目时调用
     *
     * 参数 entry - 条目
     */
    func onEntryAdded(entry: EntryOhos): Unit

    /**
     * 每当项目突出显示后被用户移动时调用
     *
     * 参数 entry - 条目
     */
    func onEntryMoved(entry: EntryOhos): Unit

    /**
     * 当绘制手指被抬起并且绘制完成时调用。
     *
     * 参数 dataSet - the last drawn DataSet
     */
    func onDrawFinished(dataSet: DataSet<EntryOhos>): Unit
}
```