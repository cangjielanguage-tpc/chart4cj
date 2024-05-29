/**
 * Created on 2024/4/22
 */
package core.components

public interface GridLineConfig {
    func getPosition(): Float64
    func getLineWidth(): Float64
    func getLineColor(): Int64
    func getDashPathEffect(): DashPathEffectConfig
}
