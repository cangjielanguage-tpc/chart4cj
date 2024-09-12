/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package chart.utils

public enum Style <: Equatable<Style> {
    | FILL
    | STROKE
    | FILL_AND_STROKE

    public operator func ==(b: Style): Bool {
        match ((this, b)) {
            case (FILL, FILL) => true
            case (STROKE, STROKE) => true
            case (FILL_AND_STROKE, FILL_AND_STROKE) => true
            case _ => false
        }
    }

    public operator func !=(b: Style): Bool {
        return !(this == b)
    }
}
public enum TextAligns {
    | CENTER
    | END
    | LEFT
    | RIGHT
    | START

    public func toString(): String {
        match (this) {
            case CENTER => "center"
            case END => "end"
            case LEFT => "left"
            case RIGHT => "right"
            case START => "start"
        }
    }
}

public enum FontStyleType {
    | NORMAL
    | ITALIC

    public func toString(): String {
        match (this) {
            case NORMAL => "normal"
            case ITALIC => "italic"
        }
    }
}

public enum FontWeightType {
    | NORMAL
    | BOLD
    | BOLDER
    | LIGHTER
    | WEIGHT_100
    | WEIGHT_200
    | WEIGHT_300
    | WEIGHT_400
    | WEIGHT_500
    | WEIGHT_600
    | WEIGHT_700
    | WEIGHT_800
    | WEIGHT_900

    public func toString(): String {
        match (this) {
            case NORMAL => "normal"
            case BOLD => "bold"
            case BOLDER => "bolder"
            case LIGHTER => "lighter"
            case WEIGHT_100 => "100"
            case WEIGHT_200 => "200"
            case WEIGHT_300 => "300"
            case WEIGHT_400 => "400"
            case WEIGHT_500 => "500"
            case WEIGHT_600 => "600"
            case WEIGHT_700 => "700"
            case WEIGHT_800 => "800"
            case WEIGHT_900 => "900"
        }
    }
}

public enum FontSizeUnit {
    | PX
    | VP

    public func toString(): String {
        match (this) {
            case PX => "px"
            case VP => "vp"
        }
    }
}

public enum FontFamily {
    | SANS_SERIF
    | SERIF
    | MONOSPACE
    | NONE

    public func toString(): String {
        match (this) {
            case SANS_SERIF => "sans-serif"
            case SERIF => "serif"
            case MONOSPACE => "monospace"
            case MONE => ""
        }
    }
}

// - font-style(可选)，用于指定字体样式，支持如下几种样式：'normal','italic'。
// - font-weight(可选)，用于指定字体的粗细，支持如下几种类型：'normal', 'bold', 'bolder', 'lighter', 100, 200, 300, 400, 500, 600, 700, 800, 900。
// - font-size(可选)，指定字号和行高，单位支持px、vp。使用时需要添加单位。
// - font-family(可选)，指定字体系列，支持如下几种类型：'sans-serif', 'serif', 'monospace'。

/**
 * 矩形圆角绘制位置类型，顶部/底部/都有
 */
public enum RoundCornerType {
    | UP
    | DOWN
    | BOTH
}

public enum PanActionType {
    | DOWN
    | MOVE
    | UP
}

public enum LongPressType {
    | DOWN
    | UP
    | CANCEL
}

public enum PinchActionType {
    | START
    | UPDATE
    | END
    | CANCEL
}

public enum FillType {
    | EMPTY
    | COLOR
    | LINEAR_GRADIENT
    | DRAWABLE
}

public enum FillDirection <: Equatable<FillDirection> {
    | DOWN
    | UP
    | RIGHT
    | LEFT

    public operator func ==(b: FillDirection): Bool {
        match ((this, b)) {
            case (DOWN, DOWN) => true
            case (UP, UP) => true
            case (RIGHT, RIGHT) => true
            case (LEFT, LEFT) => true
            case _ => false
        }
    }

    public operator func !=(b: FillDirection): Bool {
        return !(this == b)
    }
}

public enum XAxisLabelPosition {
    | LEFT
    | CENTER
    | RIGHT

    public func toString(): String {
        match (this) {
            case CENTER => "center"
            case LEFT => "left"
            case RIGHT => "right"
        }
    }
}

public enum AxisDependency <: Equatable<AxisDependency> {
    | LEFT
    | RIGHT

    public operator func ==(b: AxisDependency): Bool {
        match ((this, b)) {
            case (LEFT, LEFT) => true
            case (RIGHT, RIGHT) => true
            case _ => false
        }
    }

    public operator func !=(b: AxisDependency): Bool {
        return !(this == b)
    }
    public func toString(): String {
        match (this) {
            case LEFT => "left"
            case RIGHT => "right"
        }
    }
}

public enum Rounding <: Equatable<Rounding> {
    | UP
    | DOWN
    | CLOSEST

    public operator func ==(b: Rounding): Bool {
        match ((this, b)) {
            case (UP, UP) => true
            case (DOWN, DOWN) => true
            case (CLOSEST, CLOSEST) => true
            case _ => false
        }
    }

    public operator func !=(b: Rounding): Bool {
        return !(this == b)
    }
}

public enum LegendForm <: Equatable<LegendForm> {
    /**
     * Avoid drawing a form
     */
    | NONE

    /**
     * Do not draw the a form, but leave space for it
     */
    | EMPTY

    /**
     * Use default (default dataset's form to the legend's form)
     */
    | DEFAULT

    /**
     * Draw a square
     */
    | SQUARE

    /**
     * Draw a circle
     */
    | CIRCLE

    /**
     * Draw a horizontal line
     */
    | LINE

    public operator func ==(b: LegendForm): Bool {
        match ((this, b)) {
            case (NONE, NONE) => true
            case (EMPTY, EMPTY) => true
            case (DEFAULT, DEFAULT) => true
            case (SQUARE, SQUARE) => true
            case (CIRCLE, CIRCLE) => true
            case (LINE, LINE) => true
            case _ => false
        }
    }

    public operator func !=(b: LegendForm): Bool {
        return !(this == b)
    }
}
public enum Mode <: Equatable<Mode> {
    | LINEAR
    | STEPPED
    | CUBIC_BEZIER
    | HORIZONTAL_BEZIER

    public operator func ==(b: Mode): Bool {
        match ((this, b)) {
            case (LINEAR, LINEAR) => true
            case (STEPPED, STEPPED) => true
            case (CUBIC_BEZIER, CUBIC_BEZIER) => true
            case (HORIZONTAL_BEZIER, HORIZONTAL_BEZIER) => true
            case _ => false
        }
    }

    public operator func !=(b: Mode): Bool {
        return !(this == b)
    }
}

public func to<T>(any: Any): T {
    match (any) {
        case v: T => v
        case v: ?T => v.getOrThrow()
        case _ => throw Exception()
    }
}

public func tos<T>(any: Any): ?T {
    match (any) {
        case v: T => v
        case v: ?T => v
        case _ => throw Exception()
    }
}