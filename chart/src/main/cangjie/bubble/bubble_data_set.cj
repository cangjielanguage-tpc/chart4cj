/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.bubble

public class BubbleDataSet <: BarLineScatterCandleBubbleDataSet<BubblesEntry> & IBubbleDataSet {
    static var mMaxSize: Float64 = 0.0
    protected var mNormalizeSize: Bool = true
    private var mHighlightCircleWidth: Float64 = 2.5

    public init(yVals: ArrayList<BubblesEntry>, label: String) {
        super(yVals, label)

        this.calcMinMax()
    }

    public func setHighlightCircleWidth(width: Float64): Unit {
        this.mHighlightCircleWidth = Utils.handleDataValues(width)
    }

    public func getHighlightCircleWidth(): Float64 {
        return this.mHighlightCircleWidth
    }

    public func myCalcMinMaxBubble(e: BubblesEntry): Unit {
        super.myCalcMinMaxBubble(e)
        let size: Float64 = e.getSize()
        if (size > BubbleDataSet.mMaxSize) {
            BubbleDataSet.mMaxSize = size
        }
    }

    public func copy(): DataSet<BubblesEntry> {
        let entries: ArrayList<BubblesEntry> = ArrayList<BubblesEntry>()
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
        return BubbleDataSet.mMaxSize
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
