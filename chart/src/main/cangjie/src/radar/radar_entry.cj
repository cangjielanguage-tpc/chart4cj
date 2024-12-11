/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.radar

public class RadarEntry <: EntryOhos {
    public init(value: Float64, data!: Any = Option<Any>.None) {
        super(0.0, value, data: data)
    }

    public func getValue(): Float64 {
        return this.getY()
    }

    public func copy(): RadarEntry {
        let data: ?Any = this.getData()
        if (data.isNone()) {
            return RadarEntry(this.getY())
        }
        let e: RadarEntry = RadarEntry(this.getY(), data: this.getData()())
        return e
    }

    public func setX(x: Float64): Unit {
        super.setX(x)
    }

    public func getX(): Float64 {
        return super.getX()
    }
}
