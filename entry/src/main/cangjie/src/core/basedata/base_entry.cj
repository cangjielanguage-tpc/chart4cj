/**
 * Created on 2024/4/12
 */
package core.basedata

public abstract class BaseEntry {
    private var y: Float64 = 0.0
    private var mData: ?Any = Option<Any>.None
    /** optional icon image */
    private var mIcon: ?ChartPixelMap = Option<ChartPixelMap>.None

    public init(y: Float64) {
        this.y = y
    }

    public init(y: Float64, icon: ChartPixelMap) {
        this.y = y
        this.mIcon = icon
    }

    public init(y: Float64, data: Any) {
        this.y = y
        this.mData = data
    }

    public init(y: Float64, icon: ChartPixelMap, data: Any) {
        this.y = y
        this.mIcon = icon
        this.mData = data
    }

    /**
     * Returns the y value of this Entry.
     *
     * @return
     */
    public open func getY(): Float64 {
        return this.y
    }

    /**
     * Sets the icon drawable
     *
     * @param icon
     */
    public func setIcon(icon: ChartPixelMap): Unit {
        this.mIcon = icon
    }

    /**
     * Returns the icon of this Entry.
     *
     * @return
     */
    public func getIcon(): ?ChartPixelMap {
        return this.mIcon
    }

    /**
     * Sets the y-value for the Entry.
     *
     * @param y
     */
    public func setY(y: Float64): Unit {
        this.y = y
    }

    /**
     * Returns the data, additional information that this Entry represents, or
     * null, if no data has been specified.
     *
     * @return
     */
    public func getData(): ?Any {
        return this.mData
    }

    /**
     * Sets additional data this Entry should represent.
     *
     * @param data
     */
    public func setData(data: Any): Unit {
        this.mData = data
    }
}
