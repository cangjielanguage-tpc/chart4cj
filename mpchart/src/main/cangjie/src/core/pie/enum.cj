/**
 * Created on 2024/5/30
 */
package core.pie

public enum ValuePosition <: Equatable<ValuePosition> {
    | INSIDE_SLICE
    | OUTSIDE_SLICE

    public operator func ==(b: ValuePosition): Bool {
        match ((this, b)) {
            case (INSIDE_SLICE, INSIDE_SLICE) => true
            case (OUTSIDE_SLICE, OUTSIDE_SLICE) => true
            case _ => false
        }
    }

    public operator func !=(b: ValuePosition): Bool {
        return !(this == b)
    }
}

public enum LastGesture {
    | NONE
    | SINGLE_TAP
    | LONG_PRESS
}
