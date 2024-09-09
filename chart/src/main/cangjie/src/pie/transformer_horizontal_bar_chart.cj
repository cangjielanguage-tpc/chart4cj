/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package chart.pie

public class TransformerHorizontalBarChart <: Transformer {
    public init(viewPortHandler: ViewPortHandler) {
        super(viewPortHandler)
    }

    /**
     * Prepares the matrix that contains all offsets.
     *
     * @param inverted
     */
    public func prepareMatrixOffset(inverted: Bool): Unit {
        this.mMatrixOffset.reset()

        // offset.postTranslate(mOffsetLeft, getHeight() - mOffsetBottom)

        if (!inverted) {
            this.mMatrixOffset.postTranslate(
                this.mViewPortHandler.offsetLeft(),
                this.mViewPortHandler.getChartHeight() - this.mViewPortHandler.offsetBottom()
            )
        } else {
            this.mMatrixOffset.setTranslate(
                -(this.mViewPortHandler.getChartWidth() - this.mViewPortHandler.offsetRight()),
                this.mViewPortHandler.getChartHeight() - this.mViewPortHandler.offsetBottom()
            )
            this.mMatrixOffset.postScale(-1.0, 1.0)
        }
        //mMatrixOffset.set(offset)

        // mMatrixOffset.reset()
        //
        // mMatrixOffset.postTranslate(mOffsetLeft, getHeight() -
        // mOffsetBottom)
    }
}
