/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.pie

public class BubblesEntry <: EntryOhos {
    let FLAG: String = "BubblesEntry"
    private var mSize: Float64 = 0.0

    public init(x: Float64, y: Float64, size!: Float64 = 0.0, icon!: ?ChartPixelMap = Option<ChartPixelMap>.None, data!: ?Any = Option<Any>.None) {
        super(x, y, icon: icon, data: data)
        this.mSize = size
    }

    public func copy(): BubblesEntry {
        let data: ?Any = this.getData()
        if (let Some(d) <- data) {
            return BubblesEntry(this.getX(), this.getY(), size: this.mSize, data: data)
        } else {
            return BubblesEntry(this.getX(), this.getY(), size: this.mSize)
        }
    }

    public func getSize(): Float64 {
        return this.mSize
    }

    public func setSize(size: Float64): Unit {
        this.mSize = size
    }
    public func toString(): String {
        return FLAG
    }
}
