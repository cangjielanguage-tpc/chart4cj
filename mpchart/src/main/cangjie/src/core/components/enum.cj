package core.components

/**
 * enum for the position of the x-labels relative to the chart
 */
public enum XAxisPosition <: Equatable<XAxisPosition> {
    | TOP
    | BOTTOM
    | BOTH_SIDED
    | TOP_INSIDE
    | BOTTOM_INSIDE

    public operator func ==(b: XAxisPosition): Bool {
        match ((this, b)) {
            case (TOP, TOP) => true
            case (BOTTOM, BOTTOM) => true
            case (BOTH_SIDED, BOTH_SIDED) => true
            case (TOP_INSIDE, TOP_INSIDE) => true
            case (BOTTOM_INSIDE, BOTTOM_INSIDE) => true
            case _ => false
        }
    }
    public operator func !=(b: XAxisPosition): Bool {
        return !(this == b)
    }
}

public enum YAxisLabelPosition <: Equatable<YAxisLabelPosition> {
    | OUTSIDE_CHART
    | INSIDE_CHART

    public operator func ==(b: YAxisLabelPosition): Bool {
        match ((this, b)) {
            case (OUTSIDE_CHART, OUTSIDE_CHART) => true
            case (INSIDE_CHART, INSIDE_CHART) => true
            case _ => false
        }
    }
    public operator func !=(b: YAxisLabelPosition): Bool {
        return !(this == b)
    }
}

public enum LegendHorizontalAlignment <: Equatable<LegendHorizontalAlignment> {
    | LEFT
    | CENTER
    | RIGHT

    public operator func ==(b: LegendHorizontalAlignment): Bool {
        match ((this, b)) {
            case (LEFT, LEFT) => true
            case (CENTER, CENTER) => true
            case (RIGHT, RIGHT) => true
            case _ => false
        }
    }
    public operator func !=(b: LegendHorizontalAlignment): Bool {
        return !(this == b)
    }
}

public enum LegendVerticalAlignment <: Equatable<LegendVerticalAlignment> {
    TOP | CENTER | BOTTOM

    public operator func ==(b: LegendVerticalAlignment): Bool {
        match ((this, b)) {
            case (TOP, TOP) => true
            case (CENTER, CENTER) => true
            case (BOTTOM, BOTTOM) => true
            case _ => false
        }
    }
    public operator func !=(b: LegendVerticalAlignment): Bool {
        return !(this == b)
    }
}

public enum LegendOrientation <: Equatable<LegendOrientation> {
    | HORIZONTAL
    | VERTICAL

    public operator func ==(b: LegendOrientation): Bool {
        match ((this, b)) {
            case (HORIZONTAL, HORIZONTAL) => true
            case (VERTICAL, VERTICAL) => true
            case _ => false
        }
    }
    public operator func !=(b: LegendOrientation): Bool {
        return !(this == b)
    }
}

public enum LegendDirection <: Equatable<LegendDirection> {
    | LEFT_TO_RIGHT
    | RIGHT_TO_LEFT

    public operator func ==(b: LegendDirection): Bool {
        match ((this, b)) {
            case (LEFT_TO_RIGHT, LEFT_TO_RIGHT) => true
            case (RIGHT_TO_LEFT, RIGHT_TO_LEFT) => true
            case _ => false
        }
    }
    public operator func !=(b: LegendDirection): Bool {
        return !(this == b)
    }
}
