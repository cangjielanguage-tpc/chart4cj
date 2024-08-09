/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package mpchart.bar

public open class BarBuffer <: AbstractBuffer<IBarDataSet> {
    protected var mDataSetIndex: Int64 = 0
    protected var mDataSetCount: Int64 = 1
    protected var mContainsStacks: Bool = false
    protected var mInverted: Bool = false
    /** width of the bar on the x-axis, in values (not pixels) */
    protected var mBarWidth: Float64 = 1.0

    public init(size: Int64, dataSetCount: Int64, containsStacks: Bool) {
        super(size)
        this.mDataSetCount = dataSetCount
        this.mContainsStacks = containsStacks
    }

    public func setBarWidth(barWidth: Float64): Unit {
        this.mBarWidth = barWidth
    }

    public func setDataSet(index: Int64): Unit {
        this.mDataSetIndex = index
    }

    public func setInverted(inverted: Bool): Unit {
        this.mInverted = inverted
    }

    protected func addBar(left: Float64, top: Float64, right: Float64, bottom: Float64): Unit {
        newSet(this.buffer, this.index, left)
        this.index++
        newSet(this.buffer, this.index, top)
        this.index++
        newSet(this.buffer, this.index, right)
        this.index++
        newSet(this.buffer, this.index, bottom)
        this.index++
    }
    private func newSet(array: ArrayList<Float64>, index: Int64, value: Float64) {
        if (index < array.size) {
            array.set(index, value)
        } else {
            array.append(value)
        }
    }
    public open func feed(data: IBarDataSet): Unit {
        let size: Int64 = Int64(ceil(Float64(data.getEntryCount()) * this.phaseX))
        let barWidthHalf: Float64 = this.mBarWidth / 2.0

        for (i in 0..size) {
            let e: BarEntry = data.getEntryForIndex(i)

            let x: Float64 = e.getX()
            var y: Float64 = e.getY()
            let values: Array<Float64> = e.getYVals()

            if (!this.mContainsStacks || values.size == 0) {
                feedValueIsNone(x, y, barWidthHalf)
            } else {
                feedValueIsSome(e, values, x, y, barWidthHalf)
            }
        }

        this.reset()
    }

    private func feedValueIsNone(x: Float64, y: Float64, barWidthHalf: Float64): Unit {
        let left: Float64 = x - barWidthHalf
        let right: Float64 = x + barWidthHalf
        var bottom: Float64 = 0.0
        var top: Float64 = 0.0

        if (this.mInverted) {
            bottom = if (y >= 0.0) {
                y
            } else {
                0.0
            }
            top = if (y <= 0.0) {
                y
            } else {
                0.0
            }
        } else {
            top = if (y >= 0.0) {
                y
            } else {
                0.0
            }
            bottom = if (y <= 0.0) {
                y
            } else {
                0.0
            }
        }

        // multiply the height of the rect with the phase
        if (top > 0.0) {
            top *= this.phaseY
        } else {
            bottom *= this.phaseY
        }

        this.addBar(left, top, right, bottom)
    }
    private func feedValueIsSome(e: BarEntry, val: Array<Float64>, x: Float64, yy: Float64, barWidthHalf: Float64) {
        var y: Float64 = yy
        var posY: Float64 = 0.0
        var negY: Float64 = -e.getNegativeSum()
        var yStart: Float64 = 0.0
        // fill the stack
        for (k in 0..val.size) {
            let value: Float64 = val[k]

            if (value == 0.0 && (posY == 0.0 || negY == 0.0)) {
                // Take care of the situation of a 0.0 value, which overlaps a non-zero bar
                y = value
                yStart = y
            } else if (value >= 0.0) {
                y = posY
                yStart = posY + value
                posY = yStart
            } else {
                y = negY
                yStart = negY + abs(value)
                negY += abs(value)
            }

            let left: Float64 = x - barWidthHalf
            let right: Float64 = x + barWidthHalf
            var bottom: Float64 = 0.0
            var top: Float64 = 0.0

            if (this.mInverted) {
                bottom = if (y >= yStart) {
                    y
                } else {
                    yStart
                }
                top = if (y <= yStart) {
                    y
                } else {
                    yStart
                }
            } else {
                top = if (y >= yStart) {
                    y
                } else {
                    yStart
                }
                bottom = if (y <= yStart) {
                    y
                } else {
                    yStart
                }
            }

            // multiply the height of the rect with the phase
            top *= this.phaseY
            bottom *= this.phaseY
            this.addBar(left, top, right, bottom)
        }
    }
}
