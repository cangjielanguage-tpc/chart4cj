/**
 * Created on 031 24/8/31
 */
package chart.pie

/**
    wrapper from:
        LineData <: BarLineScatterCandleBubbleData<ILineDataSet, EntryOhos>
        BarData <: BarLineScatterCandleBubbleData<IBarDataSet, BarEntry>
        ScatterData <: BarLineScatterCandleBubbleData<IScatterDataSet, EntryOhos>
        CandleData <: BarLineScatterCandleBubbleData<ICandleDataSet, CandleEntry>
        BubbleData <: BarLineScatterCandleBubbleData<IBubbleDataSet, BubblesEntry>
    to:
        BarLineScatterCandleBubbleData<IBarLineScatterCandleBubbleDataSet<EntryOhos>, EntryOhos>
 */
public class CombinedChartDataWrapper<SW, EW> <: BarLineScatterCandleBubbleData<IBarLineScatterCandleBubbleDataSet<EntryOhos>,
    EntryOhos> where EW <: EntryOhos, SW <: IBarLineScatterCandleBubbleDataSet<EW> {

    let inner: BarLineScatterCandleBubbleData<SW, EW> // 保存源数据

    public init(inner: BarLineScatterCandleBubbleData<SW, EW>) {
        this.inner = inner
    }
    public open func calcMinMax(): Unit {
        inner.calcMinMax()
    }
    public override func getDataSets(): ArrayList<DataSetWrapper> {
        inner.getDataSets() |> map<SW, DataSetWrapper> {v => CombinedDataSetWrapper(v)} |> collectArrayList
    }
    public override func getYMax(): Float64 {
        inner.getYMax()
    }
    public override func getYMin(): Float64 {
        inner.getYMin()
    }
    public override func getXMax(): Float64 {
        inner.getXMax()
    }
    public override func getXMin(): Float64 {
        inner.getXMin()
    }
}

public type DataSetWrapper = IBarLineScatterCandleBubbleDataSet<EntryOhos>

public type ChartDataWrapper = BarLineScatterCandleBubbleData<IBarLineScatterCandleBubbleDataSet<EntryOhos>, EntryOhos>

/**
    wrapper from:
        ILineDataSet
        IBarDataSet
        IScatterDataSet
        ICandleDataSet
        IBubbleDataSet
    to:
        IBarLineScatterCandleBubbleDataSet<EntryOhos>
 */
public class CombinedDataSetWrapper<EW> <: IBarLineScatterCandleBubbleDataSet<EntryOhos> where EW <: EntryOhos {
    CombinedDataSetWrapper(let inner: IBarLineScatterCandleBubbleDataSet<EW>) {}

    public override func getYMax(): Float64 {
        inner.getYMax()
    }
    public override func getYMin(): Float64 {
        inner.getYMin()
    }
    public override func getXMin(): Float64 {
        inner.getXMin()
    }
    public override func getXMax(): Float64 {
        inner.getXMax()
    }
    public override func getEntryCount(): Int64 {
        inner.getEntryCount()
    }
    public override func calcMinMax(): Unit {
        inner.calcMinMax()
    }
    public override func calcMinMaxY(fromX: Float64, toX: Float64): Unit {
        inner.calcMinMaxY(fromX, toX)
    }
    public override func getEntryForXValue(xValue: Float64, closestToY: Float64, rounding!: Rounding): ?EntryOhos {
        inner.getEntryForXValue(xValue, closestToY, rounding: rounding) ?? None
    }
    public override func getEntriesForXValue(xValue: Float64): ArrayList<EntryOhos> {
        inner.getEntriesForXValue(xValue) |> map<EW, EntryOhos> {v => v} |> collectArrayList
    }
    public override func getEntryForIndex(index: Int64): ?EntryOhos {
        inner.getEntryForIndex(index) ?? None
    }
    public override func getEntryIndex(xValue: Float64, closestToY: Float64, rounding: Rounding): Int64 {
        inner.getEntryIndex(xValue, closestToY, rounding)
    }
    public override func getEntryIndexByEntry(e: EntryOhos): Int64 {
        inner.getEntryIndexByEntry(to<EW>(e))
    }
    public override func getIndexInEntries(xIndex: Float64): Int64 {
        inner.getIndexInEntries(xIndex)
    }
    public override func addEntry(e: ?EntryOhos): Bool {
        inner.addEntry(tos<EW>(e))
    }
    public override func addEntryOrdered(e: EntryOhos): Unit {
        inner.addEntryOrdered(to<EW>(e))
    }
    public override func removeFirst(): Bool {
        inner.removeFirst()
    }
    public override func removeLast(): Bool {
        inner.removeLast()
    }
    public override func removeEntry(e: EntryOhos): Bool {
        inner.removeEntry(to<EW>(e))
    }
    public override func removeEntryByXValue(xValue: Float64): Bool {
        inner.removeEntryByXValue(xValue)
    }
    public override func removeEntryByIndex(indexL: Int64): Bool {
        inner.removeEntryByIndex(indexL)
    }
    public override func contains(entry: EntryOhos): Bool {
        inner.contains(to<EW>(entry))
    }
    public override func clear(): Unit {
        inner.clear()
    }
    public override func getLabel(): String {
        inner.getLabel()
    }
    public override func setLabel(label: String): Unit {
        inner.setLabel(label)
    }
    public override func getAxisDependency(): AxisDependency {
        inner.getAxisDependency()
    }
    public override func setAxisDependency(dependency: AxisDependency): Unit {
        inner.setAxisDependency(dependency)
    }
    public override func getColors(): ArrayList<UInt32> {
        inner.getColors()
    }
    public override func getColor(): UInt32 {
        inner.getColor()
    }
    public override func getColor(index: Int64): UInt32 {
        inner.getColor(index)
    }
    public override func isHighlightEnabled(): Bool {
        inner.isHighlightEnabled()
    }
    public override func setHighlightEnabled(enabled: Bool): Unit {
        inner.setHighlightEnabled(enabled)
    }
    public override func setValueFormatter(f: IValueFormatter): Unit {
        inner.setValueFormatter(f)
    }
    public override func getValueFormatter(): ?IValueFormatter {
        inner.getValueFormatter()
    }
    public override func needsFormatter(): Bool {
        inner.needsFormatter()
    }
    public override func setValueTextColor(color: UInt32): Unit {
        inner.setValueTextColor(color)
    }
    public override func setValueTextColors(colors: ArrayList<UInt32>): Unit {
        inner.setValueTextColors(colors)
    }
    public override func setValueTypeface(tf: FontFamily): Unit {
        inner.setValueTypeface(tf)
    }
    public override func setValueTextSize(size: Float64): Unit {
        inner.setValueTextSize(size)
    }
    public override func getValueTextColor(index: ?Int64): UInt32 {
        inner.getValueTextColor(index)
    }
    public override func getValueTypeface(): FontFamily {
        inner.getValueTypeface()
    }
    public override func getValueTextSize(): Float64 {
        inner.getValueTextSize()
    }
    public override func getForm(): LegendForm {
        inner.getForm()
    }
    public override func getFormSize(): Float64 {
        inner.getFormSize()
    }
    public override func getFormLineWidth(): Float64 {
        inner.getFormLineWidth()
    }
    public override func getFormLineDashEffect(): ?DashPathEffect {
        inner.getFormLineDashEffect()
    }
    public override func setDrawValues(enabled: Bool): Unit {
        inner.setDrawValues(enabled)
    }
    public override func isDrawValuesEnabled(): Bool {
        inner.isDrawValuesEnabled()
    }
    public override func setDrawIcons(enabled: Bool): Unit {
        inner.setDrawIcons(enabled)
    }
    public override func isDrawIconsEnabled(): Bool {
        inner.isDrawIconsEnabled()
    }
    public override func setIconsOffset(offset: MPPointF): Unit {
        inner.setIconsOffset(offset)
    }
    public override func getIconsOffset(): MPPointF {
        inner.getIconsOffset()
    }
    public override func setVisible(visible: Bool): Unit {
        inner.setVisible(visible)
    }
    public override func isVisible(): Bool {
        inner.isVisible()
    }
    public override func getHighLightColor(): UInt32 {
        inner.getHighLightColor()
    }
    public operator override func ==(s: Any): Bool {
        inner == s
    }
    public operator override func !=(s: Any): Bool {
        inner != s
    }
}


