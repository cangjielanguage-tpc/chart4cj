/**
 * Created on 2024/5/8
 */
package core.pie

public abstract class Renderer {
    /**
     * the component that handles the drawing area of the chart and it's offsets
     */
    protected var mViewPortHandler: ?ViewPortHandler

    public init(viewPortHandler: ?ViewPortHandler) {
        this.mViewPortHandler = viewPortHandler
    }
}
