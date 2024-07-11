/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package core.utils

/**
 * 仅用于translate 和 scale，rotate、skew未移植
 */
public class Matrix {
    public static let MSCALE_X: Int64 = 0
    //!< use with getValues/setValues
    public static let MSKEW_X: Int64 = 1
    //!< use with getValues/setValues
    public static let MTRANS_X: Int64 = 2
    //!< use with getValues/setValues
    public static let MSKEW_Y: Int64 = 3
    //!< use with getValues/setValues
    public static let MSCALE_Y: Int64 = 4
    //!< use with getValues/setValues
    public static let MTRANS_Y: Int64 = 5
    //!< use with getValues/setValues
    public static let MPERSP_0: Int64 = 6
    //!< use with getValues/setValues
    public static let MPERSP_1: Int64 = 7
    //!< use with getValues/setValues
    public static let MPERSP_2: Int64 = 8
    //!< use with getValues/setValues

    private var data: Array<Float64> = [1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0]

    public func reset() {
        this.data = [1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0]
    }

    public func set(matrix: Matrix) {
        this.data[Matrix.MSCALE_X] = matrix.getValues()[Matrix.MSCALE_X]
        this.data[Matrix.MSKEW_X] = matrix.getValues()[Matrix.MSKEW_X]
        this.data[Matrix.MTRANS_X] = matrix.getValues()[Matrix.MTRANS_X]
        this.data[Matrix.MSKEW_Y] = matrix.getValues()[Matrix.MSKEW_Y]
        this.data[Matrix.MSCALE_Y] = matrix.getValues()[Matrix.MSCALE_Y]
        this.data[Matrix.MTRANS_Y] = matrix.getValues()[Matrix.MTRANS_Y]
        this.data[Matrix.MPERSP_0] = matrix.getValues()[Matrix.MPERSP_0]
        this.data[Matrix.MPERSP_1] = matrix.getValues()[Matrix.MPERSP_1]
        this.data[Matrix.MPERSP_2] = matrix.getValues()[Matrix.MPERSP_2]
    }

    public func getValues(): Array<Float64> {
        return this.data
    }

    public func setValues(values: Array<Float64>) {
        this.data = values
    }

    /**
     * 在矩阵上应用缩放变换。
     * @param scaleX - 水平方向的缩放因子。
     * @param scaleY - 垂直方向的缩放因子。
     * @param centerX - 可选参数，缩放的中心点的X坐标。
     * @param centerY - 可选参数，缩放的中心点的Y坐标。
     */
    public func postScale(scaleX: Float64, scaleY: Float64, centerX!: Float64 = 0.0, centerY!: Float64 = 0.0) {
        // 缩放矩阵的水平和垂直缩放因子
        this.data[Matrix.MSCALE_X] *= scaleX
        this.data[Matrix.MSCALE_Y] *= scaleY

        // 如果提供了中心点的X坐标，则按照中心点缩放
        if (centerX != 0.0) {
            this.data[Matrix.MTRANS_X] = scaleX * (this.data[Matrix.MTRANS_X] - centerX) + centerX
        } else {
            // 否则，只在X方向上应用缩放
            this.data[Matrix.MTRANS_X] *= scaleX
        }

        // 如果提供了中心点的Y坐标，则按照中心点缩放
        if (centerY != 0.0) {
            this.data[Matrix.MTRANS_Y] = scaleY * (this.data[Matrix.MTRANS_Y] - centerY) + centerY
        } else {
            // 否则，只在Y方向上应用缩放
            this.data[Matrix.MTRANS_Y] *= scaleY
        }
    }

    public func setScale(scaleX: Float64, scaleY: Float64, centerX!: Float64 = 0.0, centerY!: Float64 = 0.0) {
        this.data[Matrix.MSCALE_X] = scaleX
        this.data[Matrix.MSCALE_Y] = scaleY
        if (centerX != 0.0) {
            this.data[Matrix.MTRANS_X] += -centerX * scaleX
        } else {
            this.data[Matrix.MTRANS_X] = 0.0
        }
        if (centerY != 0.0) {
            this.data[Matrix.MTRANS_Y] += -centerY * scaleY
        } else {
            this.data[Matrix.MTRANS_Y] = 0.0
        }
    }

    public func postTranslate(dx: Float64, dy: Float64) {
        this.data[Matrix.MTRANS_X] += dx
        this.data[Matrix.MTRANS_Y] += dy
    }

    public func setTranslate(dx: Float64, dy: Float64) {
        if (!dx.isNaN()) {
            this.data[Matrix.MTRANS_X] = dx
        }
        if (!dy.isNaN()) {
            this.data[Matrix.MTRANS_Y] = dy
        }
        this.data[Matrix.MSCALE_X] = 1.0
        this.data[Matrix.MSCALE_Y] = 1.0
    }

    public func postConcat(matrix: Matrix) {
        let values = matrix.getValues()
        this.postScale(values[Matrix.MSCALE_X], values[Matrix.MSCALE_Y])
        this.postTranslate(values[Matrix.MTRANS_X], values[Matrix.MTRANS_Y])
    }

    public func mapPoints(pts: Array<Float64>) {
        this.checkValue()
        for (i in 0..pts.size) {
            if (i % 2 == 0) { //x轴
                pts[i] = pts[i] * this.data[Matrix.MSCALE_X] + this.data[Matrix.MTRANS_X]
            } else { //y轴
                pts[i] = pts[i] * this.data[Matrix.MSCALE_Y] + this.data[Matrix.MTRANS_Y]
            }
        }
    }

    public func mapRect(rect: MyRect) {
        let translate_x: Float64 = this.data[Matrix.MTRANS_X]
        let translate_y: Float64 = this.data[Matrix.MTRANS_Y]
        let scale_x: Float64 = this.data[Matrix.MSCALE_X]
        let scale_y: Float64 = this.data[Matrix.MSCALE_Y]

        let yValue1: Float64 = rect.top * scale_y + translate_y
        let yValue2: Float64 = rect.bottom * scale_y + translate_y
        if (yValue1 < yValue2) {
            rect.set(rect.left * scale_x + translate_x, yValue1, rect.right * scale_x + translate_x, yValue2)
        } else {
            rect.set(rect.left * scale_x + translate_x, yValue2, rect.right * scale_x + translate_x, yValue1)
        }
    }

    public func invert(matrix: Matrix) {
        let values: Array<Float64> = matrix.getValues()
        values[Matrix.MSCALE_X] = 1.0 / (this.data[Matrix.MSCALE_X] / 1.0)
        values[Matrix.MSCALE_Y] = 1.0 / (this.data[Matrix.MSCALE_Y] / 1.0)
        values[Matrix.MTRANS_X] = -this.data[Matrix.MTRANS_X] * values[Matrix.MSCALE_X]
        values[Matrix.MTRANS_Y] = -this.data[Matrix.MTRANS_Y] * values[Matrix.MSCALE_Y]
        matrix.setValues(values)
        return matrix
    }

    private func checkValue() {
        for (i in 0..this.data.size) {
            if (this.data[i].isNaN()) {
                if (i == Matrix.MSCALE_X || i == Matrix.MSCALE_Y || i == Matrix.MPERSP_2) {
                    this.data[i] = 1.0
                } else {
                    this.data[i] = 0.0
                }
            }
        }
    }
}
