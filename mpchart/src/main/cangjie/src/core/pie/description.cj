/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package core.pie

public class Description <: ComponentBase {
    /**
     * the text used in the description
     */
    private var text: String = "Description Label"
    /**
     * the custom position of the description text
     */
    private var mPosition: ?MPPointF = None
    /**
     * the alignment of the description text
     */
    private var mTextAlign: TextAlignStyle = TextAlignStyle.Right

    public init() {
        super()
        // default size
        this.mTextSize = Utils.handleDataValues(8.0)
    }

    /**
     * Sets the text to be shown as the description.
     *
     * @param text
     */
    public func setText(text: String): Unit {
        this.text = text
    }

    /**
     * Returns the description text.
     *
     * @return
     */
    public func getText(): String {
        return this.text
    }

    /**
     * Sets a custom position for the description text in pixels on the screen.
     *
     * @param x - xcoordinate
     * @param y - ycoordinate
     */
    public func setPosition(x: Float64, y: Float64): Unit {
        match (this.mPosition) {
            case None => this.mPosition = MPPointF.getInstance(x, y)
            case Some(m) =>
                m.x = x
                m.y = y
        }
    }

    /**
     * Returns the customized position of the description, or null if none set.
     *
     * @return
     */
    public func getPosition(): ?MPPointF {
        return this.mPosition
    }

    /**
     * Sets the text alignment of the description text. Default RIGHT.
     *
     * @param align
     */
    public func setTextAlign(align: TextAlignStyle) {
        this.mTextAlign = align
    }

    /**
     * Returns the text alignment of the description.
     *
     * @return
     */
    public func getTextAlign(): TextAlignStyle {
        return this.mTextAlign
    }
}
