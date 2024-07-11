/**
 * Created on 2024/4/29
 */
package core.pie

public class DefaultValueFormatter <: IValueFormatter {
    protected var mDecimalDigits: Int64 = 0

    /**
     * Constructor that specifies to how many digits the value should be
     * formatted.
     *
     * @param digits
     */
    public init(digits: Int64) {
        this.setup(digits)
    }

    /**
     * Sets up the formatter with a given number of decimal digits.
     *
     * @param digits
     */
    public func setup(digits: Int64): Unit {
        this.mDecimalDigits = digits
    }

    public func getFormattedValue(value: Float64, entry: EntryOhos, dataSetIndex: Int64,
        viewPortHandler: ViewPortHandler): String {

        // put more logic here ...
        // avoid memory allocations here (for performance reasons)
        let str = value.format(".${getDecimalDigits()}")
        return str
    }

    /**
     * Returns the number of decimal digits this formatter uses.
     *
     * @return
     */
    public func getDecimalDigits(): Int64 {
        return this.mDecimalDigits
    }
}
