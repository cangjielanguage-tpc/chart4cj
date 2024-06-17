/**
 * Created on 2024/6/17
 */
package core.bar

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
    }
}
