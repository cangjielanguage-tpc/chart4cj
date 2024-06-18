/**
 * Created on 2024/4/22
 */
package core.components

public class DashPathEffectConfig {
    var lineLength: Int64  = 0
    var spaceLength: Int64 = 0
    var phase: Int64 = 0
    public init(lineLength: Int64, spaceLength: Int64, phase: Int64) {
        this.lineLength = lineLength
        this.spaceLength = spaceLength
        this.phase = phase
    }
    public func getLineLength(): Int64 {
        return this.lineLength
    }
    public func getSpaceLength(): Int64 {
        return this.spaceLength
    }
    public func getPhase(): Int64{
        return this.phase
    }
}
