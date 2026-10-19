/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.pie

public class CandleEntry <: EntryOhos {
    let FLAG: String = "CandleEntry"
    private var mShadowHigh: Float64 = 0.0
    private var mShadowLow: Float64 = 0.0
    private var mClose: Float64 = 0.0
    private var mOpen: Float64 = 0.0

    public init(x: Float64, shadowH!: Float64 = 0.0, shadowL!: Float64 = 0.0, open!: Float64 = 0.0,
        close!: Float64 = 0.0, icon!: ?ChartPixelMap = Option<ChartPixelMap>.None, data!: Any = Option<Any>.None) {
        super(x, (shadowH + shadowL) / 2.0, icon: icon, data: data)
        this.mShadowHigh = shadowH
        this.mShadowLow = shadowL
        this.mOpen = open
        this.mClose = close
    }

    public func getShadowRange(): Float64 {
        return abs(this.mShadowHigh - this.mShadowLow)
    }

    public func getBodyRange(): Float64 {
        return abs(this.mOpen - this.mClose)
    }

    public func getY(): Float64 {
        return super.getY()
    }

    public func copy(): CandleEntry {
        let data: ?Any = this.getData()
        if (data.isNone()) {
            return CandleEntry(this.getX(), shadowH: this.mShadowHigh, shadowL: this.mShadowLow, open: this.mOpen,
                close: this.mClose)
        } else {
            return CandleEntry(this.getX(), shadowH: this.mShadowHigh, shadowL: this.mShadowLow, open: this.mOpen,
                close: this.mClose, data: data)
        }
    }

    public func getHigh(): Float64 {
        return this.mShadowHigh
    }

    public func setHigh(shadowH: Float64): Unit {
        this.mShadowHigh = shadowH
    }

    public func getLow(): Float64 {
        return this.mShadowLow
    }

    public func setLow(shadowL: Float64): Unit {
        this.mShadowLow = shadowL
    }

    public func getClose(): Float64 {
        return this.mClose
    }

    public func setClose(close: Float64): Unit {
        this.mClose = close
    }

    public func getOpen(): Float64 {
        return this.mOpen
    }

    public func setOpen(open: Float64): Unit {
        this.mOpen = open
    }
    public func toString(): String {
        return FLAG
    }

}
