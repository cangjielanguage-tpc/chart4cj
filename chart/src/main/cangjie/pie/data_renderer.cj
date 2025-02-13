/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.pie

public abstract class DataRenderer <: Renderer {
    /**
     * the animator object used to perform animations on the chart data
     */
    protected var mAnimator: ?ChartAnimator = Option<ChartAnimator>.None
    /**
     * main paint object used for rendering
     */
    protected var mRenderPaint: ChartPaint

    /**
     * paint used for highlighting values
     */
    protected var mHighlightPaint: ChartPaint
    protected var mDrawPaint: ChartPaint
    /**
     * paint object for drawing values (text representing values of chart
     * entries)
     */
    public var mValuePaint: ChartPaint

    public init(animator: ?ChartAnimator, viewPortHandler: ViewPortHandler) {
        super(viewPortHandler);

        this.mAnimator = animator

        this.mRenderPaint = ChartPaint()
        this.mRenderPaint.setStyle(Style.FILL);

        this.mDrawPaint = ChartPaint()

        this.mValuePaint = ChartPaint()

        this.mValuePaint.setColor("#3F3F3F")
        this.mValuePaint.setTextAlign(TextAlignStyle.Center)
        this.mValuePaint.setTextSize(9.0)

        this.mHighlightPaint = ChartPaint()
        this.mHighlightPaint.setStyle(Style.STROKE)
        this.mHighlightPaint.setStrokeWidth(2.0)
        this.mHighlightPaint.setColor("#FFBB73")
    }

    /**
     * Returns the ChartPaint object this renderer uses for drawing the values
     * (value-text).
     *
     * @return
     */
    public func getPaintValues(): ChartPaint {
        return this.mValuePaint
    }

    /**
     * Returns the ChartPaint object this renderer uses for drawing highlight
     * indicators.
     *
     * @return
     */
    public func getPaintHighlight(): ChartPaint {
        return this.mHighlightPaint
    }

    /**
     * Returns the ChartPaint object used for rendering.
     *
     * @return
     */
    public func getPaintRender(): ChartPaint {
        return this.mRenderPaint
    }

    /**
     * Applies the required styling (provided by the DataSet) to the value-paint
     * object.
     *
     * @param set
     */
    protected func applyValueTextStyle<S, E>(dateSet: S) where S <: IDataSet<E>, E <: EntryOhos {
        this.mValuePaint.setFontFamily(dateSet.getValueTypeface())
        this.mValuePaint.setTextSize(dateSet.getValueTextSize())
    }

    /**
     * Initializes the buffers used for rendering with a new size. Since this
     * method performs memory allocations, it should only be called if
     * necessary.
     */
    public func initBuffers(): Unit

    /**
     * Draws the actual data in form of lines, bars, ... depending on Renderer subclass.
     *
     * @param c
     */
    public func drawData(c: CanvasRenderingContext2D): Unit

    /**
     * Loops over all Entries and draws their values.
     *
     * @param c
     */
    public func drawValues(c: CanvasRenderingContext2D, isHorizontalFlip!: Bool): Unit

    /**
     * Draws the value of the given entry by using the provided IValueFormatter.
     *
     * @param c            canvas
     * @param formatter    formatter for custom value-formatting
     * @param value        the value to be drawn
     * @param entry        the entry the value belongs to
     * @param dataSetIndex the index of the DataSet the drawn Entry belongs to
     * @param x            position
     * @param y            position
     * @param color
     */
    public func drawValue(c: CanvasRenderingContext2D, formatter: IValueFormatter, value: Float64, entry: EntryOhos,
        dataSetIndex: Int64, x: Float64, y: Float64, color: Color, isHorizontalFlip!: Bool = false): Unit {
        if (isHorizontalFlip) {
            c.save()
            c.scale(-1, 1)
        }
        this.mValuePaint.setColor(color)
        Utils.resetContext2DStyle(c, this.mValuePaint)
        match (this.mValuePaint.getStyle()) {
            case Style.STROKE =>

                c.beginPath()
                if (let Some(handle) <- this.mViewPortHandler) {
                    if (isHorizontalFlip) {
                        c.strokeText(formatter.getFormattedValue(value, entry, dataSetIndex, handle), -x, y)
                    } else {
                        c.strokeText(formatter.getFormattedValue(value, entry, dataSetIndex, handle), x, y)
                    }
                }
                c.closePath()
            case Style.FILL =>
                c.beginPath();
                if (let Some(handle) <- this.mViewPortHandler) {
                    c.fillText(formatter.getFormattedValue(value, entry, dataSetIndex, handle), x, y);
                }
                c.closePath();
            case Style.FILL_AND_STROKE =>
                c.beginPath();
                if (let Some(handle) <- this.mViewPortHandler) {
                    c.fillText(formatter.getFormattedValue(value, entry, dataSetIndex, handle), x, y);
                }
                c.closePath();
        }
    }

    /**
     * Draws any kind of additional information (e.g. line-circles).
     *
     * @param c
     */
    public func drawExtras(c: CanvasRenderingContext2D): Unit

    /**
     * Draws all highlight indicators for the values that are currently highlighted.
     *
     * @param c
     * @param indices the highlighted values
     */
    public func drawHighlighted(c: CanvasRenderingContext2D, indices: Array<Highlight>): Unit
}
