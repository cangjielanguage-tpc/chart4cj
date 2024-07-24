/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package mpchart.pie

public open class EntryOhos <: BaseEntry {
    private var x: Float64 = 0.0

    public init (x: Float64, y: Float64, icon!: ?ChartPixelMap = Option<ChartPixelMap>.None, data!: ?Any = Option<Any>.None) {
        super(y, icon, data);
        this.x = x
    }
    public func getX(): Float64 {
        return this.x
    }

    /**
     * Sets the x-value of this Entry object.
     *
     * @param x
     */
    public func setX(x: Float64): Unit {
        this.x = x
    }

    /**
     * returns an exact copy of the entry
     *
     * @return
     */
    public open func copy(): EntryOhos {
        let data: ?Any = this.getData()

        return EntryOhos(this.x, this.getY(), data: data)

    }

    /**
     * Compares value, xIndex and data of the entries. Returns true if entries
     * are equal in those points, false if not. Does not check by hash-code like
     * it's done by the "equals" method.
     *
     * @param e
     * @return
     */
    public func equalTo(e: EntryOhos): Bool {

        //        if (e.getData() != this.getData()) {
        //            return false
        //        }

        if (abs(e.x - this.x) > Utils.FLOAT_EPSILON) {
            return false
        }

        if (abs(e.getY() - this.getY()) > Utils.FLOAT_EPSILON) {
            return false
        }

        return true
    }

    /**
     * returns a string representation of the entry containing x-index and value
     */
    public func toString(): String {
        return "Entry, x: ${this.x}  y: ${this.getY()}"
    }

    public func describeContents(): Float64 {
        return 0.0
    }
}
