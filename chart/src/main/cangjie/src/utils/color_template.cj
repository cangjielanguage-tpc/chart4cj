/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package chart.utils

public class ChartColor {
    init() {}

    public static func argb(a: Float64, r: Int64, g: Int64, b: Int64): Int64 {
        return (Int64(a) << 24) | (r << 16) | (g << 8) | b
    }

    public static func rgb(r: Int64, g: Int64, b: Int64): Int64 {
        return (r << 16) | (g << 8) | b
    }

    public static func alpha(color: Int64): Int64 {
        return (color >> 24) & 0xff
    }

    public static func red(color: Int64): Int64 {
        return (color >> 16) & 0xff
    }

    public static func green(color: Int64): Int64 {
        return (color >> 8) & 0xff
    }

    public static func blue(color: Int64): Int64 {
        return (color) & 0xff
    }

    public static func RGBToHSV(r: Int64, g: Int64, b: Int64, hsv: ArrayList<Float64>): Unit {
        var h: Float64 = 0.0
        var s: Float64 = 0.0
        var v: Float64 = 0.0
        let arr: Array<Float64> = [Float64(r), Float64(g), Float64(b)]
        arr.sort()
        let max: Float64 = arr[2]
        let min: Float64 = arr[0]
        v = max / 255.0
        if (max == 0.0) {
            s = 0.0
        } else {
            s = 1.0 - (min / max)
        }
        if (max == min) {
            h = 0.0
        } else if (max == Float64(r) && g >= b) {
            h = 60.0 * (Float64(g - b) / (max - min)) + 0.0
        } else if (max == Float64(r) && g < b) {
            h = 60.0 * (Float64(g - b) / (max - min)) + 360.0
        } else if (max == Float64(g)) {
            h = 60.0 * (Float64(b - r) / (max - min)) + 120.0
        } else if (max == Float64(b)) {
            h = 60.0 * (Float64(r - g) / (max - min)) + 240.0
        }
        h = floor(h)
        s = floor(s * 100.0)
        v = floor(v * 100.0)
        hsv.remove(0..hsv.size)
        hsv.appendAll([h, s, v])
    }

    public static func HSVToColor(alpha: Float64, arr: Array<Int64>): Int64 {
        var h: Float64 = Float64(arr[0])
        var s: Float64 = Float64(arr[1])
        var v: Float64 = Float64(arr[2])
        s = s / 100.0
        v = v / 100.0
        var r = 0.0
        var g = 0.0
        var b = 0.0
        let i = floor(Float64(Int64(h / 60.0) % 6))
        let f = h / 60.0 - i
        let p = v * (1.0 - s)
        let q = v * (1.0 - f * s)
        let t = v * (1.0 - (1.0 - f) * s)
        match (i) {
            case 0.0 =>
                r = v
                g = t
                b = p
            case 1.0 =>
                r = q
                g = v
                b = p
            case 2.0 =>
                r = p
                g = v
                b = t
            case 3.0 =>
                r = p
                g = q
                b = v
            case 4.0 =>
                r = t
                g = p
                b = v
            case 5.0 =>
                r = v
                g = p
                b = q
            case _ => ()
        }
        r = floor(r * alpha)
        g = floor(g * alpha)
        b = floor(b * alpha)
        return ChartColor.rgb(Int64(r), Int64(g), Int64(b))
    }
}

public class ColorTemplate {
    init() {}

    /**
     * an "invalid" color that indicates that no color is set
     */
    public static let COLOR_NONE: UInt32 = 0x00112233
    /**
     * this "color" is used for the Legend creation and indicates that the next
     * form should be skipped
     */
    public static let COLOR_SKIP: UInt32 = 0x00112234
    public static let DKGRAY: UInt32 = 0xFF444444
    /**
     * THE COLOR THEMES ARE PREDEFINED (predefined color integer arrays), FEEL
     * FREE TO CREATE YOUR OWN WITH AS MANY DIFFERENT COLORS AS YOU WANT
     */
    public static let LIBERTY_COLORS: Array<Int64> = [ChartColor.rgb(207, 248, 246), ChartColor.rgb(148, 212, 212),
    ChartColor.rgb(136, 180, 187), ChartColor.rgb(118, 174, 175), ChartColor.rgb(42, 109, 130)]

    public static let JOYFUL_COLORS: Array<Int64> = [ChartColor.rgb(217, 80, 138), ChartColor.rgb(254, 149, 7),
    ChartColor.rgb(254, 247, 120), ChartColor.rgb(106, 167, 134), ChartColor.rgb(53, 194, 209)]

    public static let PASTEL_COLORS: Array<Int64> = [ChartColor.rgb(64, 89, 128), ChartColor.rgb(149, 165, 124),
    ChartColor.rgb(217, 184, 162), ChartColor.rgb(191, 134, 134), ChartColor.rgb(179, 48, 80)]

    public static let COLORFUL_COLORS: Array<Int64> = [ChartColor.rgb(193, 37, 82), ChartColor.rgb(255, 102, 0),
    ChartColor.rgb(245, 199, 0), ChartColor.rgb(106, 150, 31), ChartColor.rgb(179, 100, 53)]

    public static let VORDIPLOM_COLORS: Array<Int64> = [ChartColor.rgb(192, 255, 140), ChartColor.rgb(255, 247, 140),
    ChartColor.rgb(255, 208, 140), ChartColor.rgb(140, 234, 255), ChartColor.rgb(255, 140, 157)]

    public static let MATERIAL_COLORS: Array<Int64> = [0x2ecc71, 0xf1c40f, 0xe74c3c, 0x3498db]

    /**
     * Converts the given hex-color-string to rgb.
     *
     * @param {string} hex - 要转换的十六进制颜色代码（例如，"#336699"）,或者带透明度的颜色代码（例如，”#99336699“）
     * @return {number} - 表示颜色的RGB值, 例如 0x336699 或者 0x99336699
     */
    public static func rgb(hex: String): Int64 {
        return Int64.parse("0x" + hex.replace("#", ""))
    }

    /**
     *
     * @return
     */
    public static func getHoloBlue(): Int64 {
        return ChartColor.rgb(51, 181, 229)
    }

    /**
     * Sets the alpha component of the given color.
     *
     * @param color
     * @param alpha 0 - 255
     * @return
     */
    public static func colorWithAlpha(color: Int64, alpha: Float64): Int64 {
        return (color & 0xffffff) | ((Int64(alpha) & 0xff) << 24)
    }

    /**
     * turn an array of resource-colors (contains resource-id integers) into an
     * array list of actual color integers
     *
     * @param r
     * @param colors an integer array of resource id's of colors
     * @return
     */
    public static func createColors(colors: Array<UInt32>): ArrayList<UInt32> {
        var result: ArrayList<UInt32> = ArrayList<UInt32>()
        result.appendAll(colors)
        return result
    }

    /**
     * from Color.rgb()
     * @param r
     * @param g
     * @param b
     */
    public static func colorRgb(r: Int64, g: Int64, b: Int64): Int64 {
        return 0xff000000 | (r << 16) | (g << 8) | b
    }

    /**
     * from Color.argb()
     * @param alpha
     * @param red
     * @param green
     * @param blue
     */
    public static func argb(alpha: Float64, red: Int64, green: Int64, blue: Int64): Int64 {
        return (Int64(alpha) << 24) | (red << 16) | (green << 8) | blue
    }

    /**
     * from Color red()
     * @param color
     */
    public static func red(color: Int64): Int64 {
        return (color >> 16) & 0xFF
    }

    /**
     * from Color green()
     * @param color
     */
    public static func green(color: Int64): Int64 {
        return (color >> 8) & 0xFF
    }

    /**
     * from Color blue()
     * @param color
     */
    public static func blue(color: Int64): Int64 {
        return color & 0xFF
    }
}
