package core.components

/**
 * enum for the position of the x-labels relative to the chart
 */
public enum XAxisPosition {
    | TOP
    | BOTTOM
    | BOTH_SIDED
    | TOP_INSIDE
    | BOTTOM_INSIDE

    public operator func ==(b: XAxisPosition): Bool {
        this == b
    }

    public operator func !=(b: XAxisPosition): Bool {
        this != b
    }
}

public enum YAxisLabelPosition {
    | OUTSIDE_CHART
    | INSIDE_CHART

    public operator func ==(b: YAxisLabelPosition): Bool {
        this == b
    }

    public operator func !=(b: YAxisLabelPosition): Bool {
        this != b
    }
}

public enum LegendHorizontalAlignment {
    | LEFT
    | CENTER
    | RIGHT

    public operator func ==(b: LegendHorizontalAlignment): Bool {
        this == b
    }

    public operator func !=(b: LegendHorizontalAlignment): Bool {
        this != b
    }
}

public enum LegendVerticalAlignment {
    TOP | CENTER | BOTTOM

    public operator func ==(b: LegendVerticalAlignment): Bool {
        this == b
    }

    public operator func !=(b: LegendVerticalAlignment): Bool {
        this != b
    }
}

public enum LegendOrientation {
    | HORIZONTAL
    | VERTICAL

    public operator func ==(b: LegendOrientation): Bool {
        this == b
    }

    public operator func !=(b: LegendOrientation): Bool {
        this != b
    }
}

public enum LegendDirection {
    | LEFT_TO_RIGHT
    | RIGHT_TO_LEFT

    public operator func ==(b: LegendDirection): Bool {
        this == b
    }

    public operator func !=(b: LegendDirection): Bool {
        this != b
    }
}
