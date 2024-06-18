/**
 * Created on 2024/4/22
 */
package core.components

public class GridLineConfig {
    var lineColor: Int64 = 0
    var position: Float64 = 0.0
    var lineWidth: Float64 = 0.0
    var dashPathEffect: ?DashPathEffectConfig

    public init(position: Float64, lineColor: Int64, lineWidth: Float64, dashPathEffect: ?DashPathEffectConfig) {
        this.lineColor = lineColor
        this.position = position
        this.lineWidth = lineWidth
        this.dashPathEffect = dashPathEffect
    }

    public func getPosition(): Float64 {
        this.position
    }
    public func getLineWidth(): Float64 {
        this.lineWidth
    }
    public func getLineColor(): Int64 {
        this.lineColor
    }
    public func getDashPathEffect(): ?DashPathEffectConfig {
        this.dashPathEffect
    }
}
