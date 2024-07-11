/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package core.waterfall

public class WaterfallBuffer <: BarBuffer {
    private var arrayTop: ArrayList<Float64> = ArrayList<Float64>()
    private var arrayBottom: ArrayList<Float64> = ArrayList<Float64>()
    public init(size: Int64, dataSetCount: Int64, containsStacks: Bool) {
        super(size, dataSetCount, containsStacks)
    }
    public func getArrayTop(): ArrayList<Float64> {
        return this.arrayTop
    }

    public func getArrayBottom(): ArrayList<Float64> {
        return this.arrayBottom
    }

    public func feed(data: IWaterfallDataSet): Unit {
        let size: Int64 = data.getEntryCount() * Int64(this.phaseX)
        let barWidthHalf: Float64 = this.mBarWidth / 2.0

        for (i in 0..size) {
            let e: ?WaterfallEntry = data.getEntryForIndex(i) as WaterfallEntry

            if (e.isNone()) {
                continue
            }

            let x: Float64 = e().getX()
            let y1: Float64 = e().getMinY()
            let y2: Float64 = e().getMaxY()

            let minY = max(y1, y2)
            let maxY = min(y1, y2)

            let bottom = if (this.mInverted) {
                maxY
            } else {
                minY
            }
            let top = if (this.mInverted) {
                minY
            } else {
                maxY
            }
            this.arrayTop.append(e().getMaxY())
            this.arrayBottom.append(e().getMinY())
            this.addWaterfall(x - barWidthHalf, top * this.phaseY, x + barWidthHalf, bottom * this.phaseY)
        }

        this.reset()
        this.arrayTop.toArray().sort()
        this.arrayBottom.toArray().sort()
    }

    protected func addWaterfall(left: Float64, top: Float64, right: Float64, bottom: Float64): Unit {
        this.buffer.append(left)
        this.buffer.append(top)
        this.buffer.append(right)
        this.buffer.append(bottom)
    }
}
