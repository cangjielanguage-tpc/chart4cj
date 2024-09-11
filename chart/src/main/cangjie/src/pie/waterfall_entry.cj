/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package chart.pie

public class WaterfallEntry <: EntryOhos {
    private var mYVals: Array<Float64> = Array<Float64>()
    private var mMinY: Float64 = 0.0
    private var mMaxY: Float64 = 0.0
    private var mHighlights: Array<WaterfallHighlight> = []
    private var mRanges: ?Array<RangeChart> = None
    private var mNegativeSum: Float64 = 0.0
    private var mPositiveSum: Float64 = 0.0

    public init(x: Float64, minY: Float64, maxY: Float64 , icon!: ?ChartPixelMap = Option<ChartPixelMap>.None, data!: ?Any = Option<Any>.None, highlights!: Array<WaterfallHighlight> = Array<WaterfallHighlight>()) {
        super(x, maxY, icon: icon, data: data)
        this.mMinY = minY
        this.mMaxY = maxY
        this.mHighlights = highlights
    }

    public func getMinY(): Float64 {
        return this.mMinY
    }

    public func getMaxY(): Float64 {
        return super.getY()
    }

    public func getHighlights(): Array<WaterfallHighlight> {
        return this.mHighlights
    }

    public func setHighlights(highlights: Array<WaterfallHighlight>): Unit {
        this.mHighlights = Array<WaterfallHighlight>(highlights.size, item: WaterfallHighlight(0.0, 0.0))
        if (highlights.size > 0) {
            for (i in 0..highlights.size) {
                this.mHighlights[i] = highlights[i]
            }
        }
    }

    public func copy(): WaterfallEntry {
        let data: ?Any = this.getData()
        if (let Some(d) <- data) {
            let copied = WaterfallEntry(this.getX(), this.getY(), 0.0, data: d)
            copied.setVals(this.mYVals)
            return copied
        } else {
            let copied = WaterfallEntry(this.getX(), this.getY(), 0.0)
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

     private func calcPosNegSum(): Unit {
        if (this.mYVals.size > 0) {
            var negSum: Float64 = 0.0
            var posSum: Float64 = 0.0

            for (f in this.mYVals) {
                if (f <= 0.0) {
                    negSum += abs(f)
                } else {
                    posSum += f
                }
            }
            this.mNegativeSum = negSum
            this.mPositiveSum = posSum
        } else {
            this.mNegativeSum = 0.0
            this.mPositiveSum = 0.0
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

    public func getNegativeSum(): Float64 {
        return this.mNegativeSum
    }
}

public class WaterfallHighlight {
  private var minY: Float64  = 0.0;
  private var maxY: Float64 = 0.0;
  private var color: UInt32 = 0xff0000;

  public init(minY: Float64, maxY: Float64, color!: UInt32 = 0xff0000) {
    this.minY = minY;
    this.maxY = maxY;
    this.color = color;

  }

  public func getMinY() {
    return this.minY;
  }

  public func getMaxY() {
    return this.maxY;
  }

  public func getColor() {
    return this.color;
  }

  public func setColor(color: UInt32) {
    this.color = color;
  }
}
