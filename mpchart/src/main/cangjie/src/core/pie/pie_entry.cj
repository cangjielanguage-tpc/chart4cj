/**
 * Created on 2024/5/6
 */
package core.pie

public class PiEntry <: EntryOhos {
    public var label: String = ""

    public init(yValue: Float64) {
        super(0.0, yValue)
    }
    public init(yValue: Float64, data: Any) {
        super(0.0, yValue, data)
    }
    public init(yValue: Float64, icon: ChartPixelMap) {
        super(0.0, yValue, icon)
    }
    public init(yValue: Float64, icon: ChartPixelMap, data: Any) {
        super(0.0, yValue, icon, data)
    }
    public init(yValue: Float64, label: String) {
        super(0.0, yValue)
        this.label = label
    }
    public init(yValue: Float64, label: String, data: Any) {
        super(0.0, yValue, data)
        this.label = label
    }
    public init(yValue: Float64, label: String, icon: ChartPixelMap) {
        super(0.0, yValue, icon)
        this.label = label
    }

    public init(yValue: Float64, label: String, icon: ChartPixelMap, data: Any) {
        super(0.0, yValue, icon, data)
        this.label = label
    }

    /**
     * This is the same as getY(). Returns the value of the PiEntry.
     *
     * @return
     */
    public func getValue(): Float64 {
        return super.getY()
    }

    public func getLabel(): String {
        return this.label
    }

    public func setLabel(label: String): Unit {
        this.label = label
    }

    public func copy(): PiEntry {
        let data = this.getData()
        let e: PiEntry = PiEntry(this.getY(), this.label, getData())
        return e
    }
}
