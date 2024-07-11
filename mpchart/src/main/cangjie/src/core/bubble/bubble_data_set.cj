/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package core.bubble

public class BubbleDataSet <: BarLineScatterCandleBubbleDataSet<BubbleEntry> & IBubbleDataSet {
    private var mMaxSize: Float64 = 0.0
    protected var mNormalizeSize: Bool = true
    private var mHighlightCircleWidth: Float64 = 2.5

    public init(yVals: ArrayList<BubbleEntry>, label: String) {
        super(yVals, label)
    }

    public func setHighlightCircleWidth(width: Float64): Unit {
        this.mHighlightCircleWidth = Utils.handleDataValues(width)
    }

    public func getHighlightCircleWidth(): Float64 {
        return this.mHighlightCircleWidth
    }

    public func myCalcMinMax(e: BubbleEntry): Unit {
        super.myCalcMinMax(e)
        let size: Float64 = e.getSize()
        if (size > this.mMaxSize) {
            this.mMaxSize = size
        }
    }

    public func copy(): DataSet<BubbleEntry> {
        let entries: ArrayList<BubbleEntry> = ArrayList<BubbleEntry>()
        if (let Some(m) <- this.mEntries) {
            for (i in 0..m.size) {
                entries.append(m[i].copy())
            }
        }
        let copied = BubbleDataSet(entries, this.getLabel())
        this.copyDataSet(copied)
        return copied
    }

    protected func copyDataSet(bubbleDataSet: BubbleDataSet): Unit {
        bubbleDataSet.mHighlightCircleWidth = this.mHighlightCircleWidth
        bubbleDataSet.mNormalizeSize = this.mNormalizeSize
    }

    public func getMaxSize(): Float64 {
        return this.mMaxSize
    }

    public func isNormalizeSizeEnabled(): Bool {
        return this.mNormalizeSize
    }

    public func setNormalizeSizeEnabled(normalizeSize: Bool): Unit {
        this.mNormalizeSize = normalizeSize
    }

    public operator func ==(s: Any): Bool {
        return match (s) {
            case v: BubbleData => refEq(this, v)
            case _ => false
        }
    }

    public operator func !=(s: Any): Bool {
        return !(this == s)
    }
}
