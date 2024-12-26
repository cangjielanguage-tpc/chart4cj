/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.bar

public class XBounds {
    /**
     * minimum visible entry index
     */
    public var mins: Int64 = 0
    /**
     * maximum visible entry index
     */
    public var maxs: Int64 = 0
    /**
     * range of visible entry indices
     */
    public var range: Int64 = 0
    public var mAnimator: ?ChartAnimator = None

    public init(animator: ChartAnimator) {
        this.mAnimator = animator
    }

    /**
     * Calculates the minimum and maximum x values as well as the range between them.
     *
     * @param chart
     * @param dataSet
     */
    public func set<D,S,E>(
        chart: BarLineScatterCandleBubbleDataProvider<D,S,E>,
        dataSet: S
    ): Unit where D <: ChartData<S, E>, S <: IDataSet<E>, E <: EntryOhos{
        let getPhaseX: Float64 = if (let Some(m) <- this.mAnimator) {
            m.getPhaseX()
        } else {
            1.0
        }
        let phaseX: Float64 = max(0.0, min(1.0, getPhaseX))

        let low: Float64 = chart.getLowestVisibleX()
        let high: Float64 = chart.getHighestVisibleX()
        let entryFrom: ?E = dataSet.getEntryForXValue(low, Float64.NaN, rounding: Rounding.DOWN)
        let entryTo: ?E = dataSet.getEntryForXValue(high, Float64.NaN, rounding: Rounding.UP)

            this.mins = if (let Some(ef) <- entryFrom) {
                dataSet.getEntryIndexByEntry(ef)
            } else {
                0
            }
            this.maxs = if (let Some(et) <- entryTo) {
                dataSet.getEntryIndexByEntry(et)
            } else {
                0
            }
            this.range = Int64(floor(Float64(this.maxs - this.mins) * phaseX))
    }
}

public abstract class BarLineScatterCandleBubbleRenderer <: DataRenderer {
    /**
     * buffer for storing the current minimum and maximum visible x
     */
    protected var mXBounds: ?XBounds = None

    public init(animator: ChartAnimator, viewPortHandler: ViewPortHandler) {
        super(animator, viewPortHandler)
        if (let Some(m) <- this.mAnimator) {
            this.mXBounds = XBounds(m)
        }
    }

    /**
     * Returns true if the DataSet values should be drawn, false if not.
     *
     * @param set
     * @return
     */
    protected func shouldDrawValues<S, E>(dataSet: S): Bool where S <: IDataSet<E>, E <: EntryOhos {
        return dataSet.isVisible() && (dataSet.isDrawValuesEnabled() || dataSet.isDrawIconsEnabled())
    }

    /**
     * Checks if the provided entry object is in bounds for drawing considering the current animation phase.
     *
     * @param e
     * @param set
     * @return
     */
    protected func isInBoundsX<E>(e: ?E, dataSet: IBarLineScatterCandleBubbleDataSet<E>): Bool where E <: EntryOhos {
        if (let Some(entry) <- e) {
            let entryIndex = dataSet.getEntryIndexByEntry(entry)
            if (entryIndex >= dataSet.getEntryCount() * (if (let Some(m) <- this.mAnimator) {
                Int64(m.getPhaseX())
            } else {
                1
            })) {
                return false
            } else {
                return true
            }
        }
        return false
    }
}
