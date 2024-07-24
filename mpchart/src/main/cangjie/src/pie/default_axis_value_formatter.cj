/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package mpchart.pie

public class DefaultAxisValueFormatter <: IAxisValueFormatter {
    /**
     * the number of decimal digits this formatter uses
     */
    protected var digits: Int64 = 0

    /**
     * Constructor that specifies to how many digits the value should be
     * formatted.
     *
     * @param digits
     */
    public init(digits: Int64) {
        this.digits = digits
    }

    public func getFormattedValue(value: Float64, axis: AxisBase): String {
        // avoid memory allocations here (for performance)
        let str = value.format(".1").split(".")
        if (str[1] == "0") {
            return str[0]
        } else {
            return value.format(".1")
        }
    }

    /**
     * Returns the number of decimal digits this formatter uses or -1, if unspecified.
     *
     * @return
     */
    public func getDecimalDigits(): Int64 {
        return this.digits
    }
}
