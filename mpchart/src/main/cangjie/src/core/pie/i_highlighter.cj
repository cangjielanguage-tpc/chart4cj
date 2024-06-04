/**
 * Created on 2024/5/9
 */
package core.pie

public interface IHighlighter {

    /**
     * Returns a Highlight object corresponding to the given x- and y- touch positions in pixels.
     *
     * @param x
     * @param y
     * @return
     */
    func getHighlight(x: Float64, y: Float64): ?Highlight
}
