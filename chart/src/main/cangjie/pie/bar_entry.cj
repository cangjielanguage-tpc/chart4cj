/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.pie

public class BarEntry <: EntryOhos {
    private var mYVals: Array<Float64> = []
    private var mRanges: ?Array<RangeChart> = None
    private var mNegativeSum: Float64 = 0.0
    private var mPositiveSum: Float64 = 0.0

    public init(x: Float64, y: Float64, icon!: ?ChartPixelMap = Option<ChartPixelMap>.None, data!: Any = Option<Any>.None) {
        super(x, y, icon: icon, data: data);
    }
    public init(x: Float64, y: Array<Float64>, icon!: ?ChartPixelMap = Option<ChartPixelMap>.None, data!: Any = Option<Any>.None) {
        super(x, BarEntry.calcSum(y), icon: icon, data: data);
        this.mYVals = y
        this.calcPosNegSum();
        this.calcRanges();
    }

    public func copy(): BarEntry {
        let data: ?Any = this.getData()
        if (let Some(d) <- data) {
            let copied = BarEntry(this.getX(), this.getY(), data: d)
            copied.setVals(this.mYVals)
            return copied
        } else {
            let copied = BarEntry(this.getX(), this.getY())
            copied.setVals(this.mYVals)
            return copied
        }
    }

    public func getYVals(): Array<Float64> {
        return this.mYVals
    }

    public func setVals(vals: Array<Float64>): Unit {
        this.setY(BarEntry.calcSum(vals))
        this.mYVals = vals
        this.calcPosNegSum()
        this.calcRanges()
    }

    public func getY(): Float64 {
        return super.getY()
    }

    public func getRanges(): ?Array<RangeChart> {
        return this.mRanges
    }

    /**
     * Returns true if this BarEntry is stacked (has a values array), false if not.
     *
     * @return
     */
    public func isStacked(): Bool {
        return this.mYVals.size > 0
    }

    /**
     * Use `getSumBelow(stackIndex)` instead.
     */
    public func getBelowSum(stackIndex: Int64): Float64 {
        return this.getSumBelow(stackIndex)
    }

    public func getSumBelow(stackIndex: Int64): Float64 {
        if (this.mYVals.size > 0) {
            var remainder: Float64 = 0.0
            var index = this.mYVals.size

            while (index > stackIndex && index >= 0) {
                remainder += this.mYVals[index]
                index--
            }
            return remainder
        } else {
            return 0.0
        }
    }

    /**
     * Reuturns the sum of all positive values this entry (if stacked) contains.
     *
     * @return
     */
    public func getPositiveSum(): Float64 {
        return this.mPositiveSum
    }

    /**
     * Returns the sum of all negative values this entry (if stacked) contains. (this is a positive number)
     *
     * @return
     */
    public func getNegativeSum(): Float64 {
        return this.mNegativeSum
    }

    private func calcPosNegSum(): Unit {
        if (this.mYVals.size > 0) {
            var sumNeg: Float64 = 0.0
            var sumPos: Float64 = 0.0

            for (f in this.mYVals) {
                if (f <= 0.0) {
                    sumNeg += abs(f)
                } else {
                    sumPos += f
                }
            }

            this.mNegativeSum = sumNeg
            this.mPositiveSum = sumPos
        } else {
            this.mNegativeSum = 0.0
            this.mPositiveSum = 0.0
            return
        }
    }

    /**
     * Calculates the sum across all values of the given stack.
     *
     * @param vals
     * @return
     */
    public static func calcSum(vals: ?Array<Float64>): Float64 {
        if (let Some(v) <- vals) {
            var sum: Float64 = 0.0
            for (f in v) {
                sum += f
            }

            return sum
        } else {
            return 0.0
        }
    }

    protected func calcRanges(): Unit {
        let v: Array<Float64> = this.getYVals()

            if (v.size == 0) {
                return
            } else {
                this.mRanges = Array(v.size, item: RangeChart(0.0, 0.0))

                var negRemain: Float64 = -this.mNegativeSum //getNegativeSum
                var posRemain: Float64 = 0.0

                for (i in 0..this.mRanges().size) {
                    let value: Float64 = v[i]

                    if (value < 0.0) {
                        this.mRanges()[i] = RangeChart(negRemain, negRemain - value)
                        negRemain -= value
                    } else {
                        this.mRanges()[i] = RangeChart(posRemain, posRemain + value)
                        posRemain += value
                    }
                }
            }

    }
}
