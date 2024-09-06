/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package chart.pie

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


public enum ChartGesture <: ToString {
    | NONE
    | DRAG
    | X_ZOOM
    | Y_ZOOM
    | PINCH_ZOOM
    | ROTATE
    | SINGLE_TAP
    | DOUBLE_TAP
    | LONG_PRESS
    | FLING

    public func toString(): String {
        match (this) {
            case NONE => "NONE"
            case DRAG => "DRAG"
            case X_ZOOM => "X_ZOOM"
            case Y_ZOOM => "Y_ZOOM"
            case PINCH_ZOOM => "PINCH_ZOOM"
            case ROTATE => "ROTATE"
            case SINGLE_TAP => "SINGLE_TAP"
            case DOUBLE_TAP => "DOUBLE_TAP"
            case LONG_PRESS => "LONG_PRESS"
            case FLING => "FLING"
        }
    }
}