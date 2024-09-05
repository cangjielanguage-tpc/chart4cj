/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package mpchart.pie

public abstract class PieRadarHighlighter<T, D, S, E> <: IHighlighter where T <: PieRadarChartBaseModel<D, S, E>,
    D <: ChartData<S, E>, S <: IDataSet<E>, E <: EntryOhos {
    protected var mChart: ?T
    /**
     * buffer for storing previously highlighted values
     */
    protected var mHighlightBuffer: Array<Highlight> = Array<Highlight>()

    public init(chart: T) {
        this.mChart = chart
    }

    public func getHighlight(x: Float64, y: Float64): ?Highlight {
        if (this.mChart.isNone() || (this.mChart().getData() as D)().getMaxEntryCountSet().isNone()) {
            return None
        }

        let touchDistanceToCenter: Float64 = this.mChart().distanceToCenter(x, y)

        // check if a slice was touched
        if (touchDistanceToCenter > this.mChart().getRadius()) {

            // if no slice was touched, highlight nothing
            return None
        } else {
            let angle: Float64 = this.mChart().getAngleForPoint(x, y)

            let index = Int64(this.mChart().getIndexForAngle(angle))

            // check if the index could be found
            if (index < 0 || index >= (this.mChart().getData() as D)().getMaxEntryCountSet()().getEntryCount()) {
                return None
            } else {
                return this.getClosestHighlight(index, x, y)
            }
        }
    }

    /**
     * Returns the closest Highlight object of the given objects based on the touch position inside the chart.
     *
     * @param index
     * @param x
     * @param y
     * @return
     */
    protected open func getClosestHighlight(index: Int64, x: Float64, y: Float64): Highlight
}
