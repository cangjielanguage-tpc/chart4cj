/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package mpchart.bar

public class HorizontalBarBuffer <: BarBuffer {
    public init(size: Int64, dataSetCount: Int64, containsStacks: Bool) {
        super(size, dataSetCount, containsStacks)
    }

    public func feed(data: IBarDataSet) {
        let size: Int64 = Int64(ceil(Float64(data.getEntryCount()) * this.phaseX))
        let barWidthHalf: Float64 = this.mBarWidth / 2.0

        for (i in 0..size) {
            let e: BarEntry = data.getEntryForIndex(i)
            let x: Float64 = e.getX()
            var y: Float64 = e.getY()
            let vals: Array<Float64> = e.getYVals()

            if (!this.mContainsStacks || vals.size == 0) {
                feedValIsNone(x, y, barWidthHalf)
            } else {
                feedValIsSome(e, vals, y, x, barWidthHalf)
            }
        }
        this.reset()
    }

    private func feedValIsNone(x: Float64, y: Float64, barWidthHalf: Float64) {
        let bottom = x - barWidthHalf
        let top = x + barWidthHalf
        var left: Float64 = 0.0
        var right: Float64 = 0.0
        if (this.mInverted) {
            left = if (y >= 0.0) {
                y
            } else {
                0.0
            }
            right = if (y <= 0.0) {
                y
            } else {
                0.0
            }
        } else {
            right = if (y >= 0.0) {
                y
            } else {
                0.0
            }
            left = if (y <= 0.0) {
                y
            } else {
                0.0
            }
        }

        // multiply the height of the rect with the phase
        if (right > 0.0) {
            right *= this.phaseY
        } else {
            left *= this.phaseY
        }

        this.addBar(left, top, right, bottom)
    }

    private func feedValIsSome(e: BarEntry, vals: ?Array<Float64>, yy: Float64, x: Float64, barWidthHalf: Float64) {
        var y: Float64 = yy
        var posY = 0.0
        var negY = -e.getNegativeSum()
        var yStart = 0.0

        //fill the stack
        for (k in 0..vals().size) {
            let value = vals()[k]

            if (value >= 0.0) {
                y = posY
                yStart = posY + value
                posY = yStart
            } else {
                y = negY
                yStart = negY + abs(value)
                negY += abs(value)
            }

            let bottom = x - barWidthHalf
            let top = x + barWidthHalf
            var left: Float64 = 0.0
            var right: Float64 = 0.0
            if (this.mInverted) {
                left = if (y >= yStart) {
                    y
                } else {
                    yStart
                }
                right = if (y <= yStart) {
                    y
                } else {
                    yStart
                }
            } else {
                right = if (y >= yStart) {
                    y
                } else {
                    yStart
                }
                left = if (y <= yStart) {
                    y
                } else {
                    yStart
                }
            }

            // multiply the height of the rect with the phase
            right *= this.phaseY
            left *= this.phaseY

            this.addBar(left, top, right, bottom)
        }
    }
}
