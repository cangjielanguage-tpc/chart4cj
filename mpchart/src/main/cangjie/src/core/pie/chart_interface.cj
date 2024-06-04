/**
 * Created on 2024/5/9
 */
package core.pie

public interface ChartInterface<S, E> where S <: IDataSet<E>, E <: EntryOhos {
    func getXChartMin(): Float64

    /**
     * Returns the maximum x value of the chart, regardless of zoom or translation.
     *
     * @return
     */
    func getXChartMax(): Float64

    func getXRange(): Float64

    /**
     * Returns the minimum y value of the chart, regardless of zoom or translation.
     *
     * @return
     */
    func getYChartMin(): Float64

    /**
     * Returns the maximum y value of the chart, regardless of zoom or translation.
     *
     * @return
     */
    func getYChartMax(): Float64

    /**
     * Returns the maximum distance in scren dp a touch can be away from an entry to cause it to get highlighted.
     *
     * @return
     */
    func getMaxHighlightDistance(): Float64

    func getWidth(): Float64

    func getHeight(): Float64

    func getCenterOfView(): MPPointF

    func getCenterOffsets(): ?MPPointF

    func getContentRect(): MyRect /*RectF*/

    func getDefaultValueFormatter(): IValueFormatter

    func getData(): ?ChartData<S, E>

    func getMaxVisibleCount(): Int64
}
