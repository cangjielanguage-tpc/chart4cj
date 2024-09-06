/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package chart.utils

public class RangeChart {
    public var myfrom: Float64 = 0.0;
    public var to: Float64 = 0.0;

    public init(myfrom: Float64, to: Float64) {
        this.myfrom = myfrom
        this.to = to
    }

    /**
     * Returns true if this range contains (if the value is in between) the given value, false if not.
     *
     * @param value
     * @return
     */
    public func contains(value: Float64): Bool {
        if (value > this.myfrom && value <= this.to) {
            return true;
        } else {
            return false;
        }
    }

    public func isLarger(value: Float64): Bool {
        return value > this.to;
    }

    public func isSmaller(value: Float64): Bool {
        return value < this.myfrom;
    }
}
