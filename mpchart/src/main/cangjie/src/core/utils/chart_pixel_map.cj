package core.utils

public class ChartPixelMap {
    private var icon: ?PixelMap = Option<PixelMap>.None
    private var height: Int64 = 0
    private var width: Int64 = 0

    public func setIcon(newIcon: PixelMap) {
        this.icon = newIcon
    }

    public func getIcon(): ?PixelMap {
        return this.icon
    }

    public func setWidth(width: Int64) {
        this.width = width
    }

    public func getWidth(): Int64 {
        return this.width
    }

    public func setHeight(height: Int64) {
        this.height = height
    }

    public func getHeight(): Int64 {
        return this.height
    }
}
