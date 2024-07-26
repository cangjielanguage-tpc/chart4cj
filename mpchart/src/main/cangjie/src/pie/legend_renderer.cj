/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package mpchart.pie

public class LegendRenderer <: Renderer {
    /**
     * paint for the legend labels
     */
    protected var mLegendLabelPaint: Paint = Paint()
    /**
     * paint used for the legend forms
     */
    protected var mLegendFormPaint: Paint = Paint()
    /**
     * the legend object this renderer renders
     */
    protected var mLegend: ?Legend = Option<Legend>.None

    public init(viewPortHandler: ViewPortHandler, legend: Legend) {
        super(viewPortHandler)

        this.mLegend = legend

        this.mLegendLabelPaint = Paint()
        this.mLegendLabelPaint.setTextSize(Utils.handleDataValues(9.0))
        this.mLegendLabelPaint.setTextAlign(TextAlignStyle.Left)
        this.mLegendLabelPaint.setTextBaseline(TextBaseline.Bottom)

        this.mLegendFormPaint = Paint()
        this.mLegendFormPaint.setStyle(Style.FILL)
    }

    /**
     * Returns the Paint object used for drawing the Legend labels.
     *
     * @return
     */
    public func getLabelPaint(): Paint {
        return this.mLegendLabelPaint
    }

    /**
     * Returns the Paint object used for drawing the Legend forms.
     *
     * @return
     */
    public func getFormPaint(): Paint {
        return this.mLegendFormPaint
    }

    protected var computedEntries: ArrayList<LegendEntry> = ArrayList<LegendEntry>()

    private func computeLegendMatchDataSet<D, S, E>(dataSet: ?S, data: ?D, i: Int64): Unit where D <: ChartData<S, E>,
        S <: IDataSet<E>, E <: EntryOhos {
        let clrs: ArrayList<UInt32> = dataSet().getColors()
        let entryCount: Int64 = dataSet().getEntryCount()
        match (dataSet) {
            case Some(pieDataSet: IPieDataSet) =>
                for (j in 0..entryCount) {
                    this.computedEntries.append(
                        LegendEntry(
                            pieDataSet.getEntryForIndex(j).getLabel(),
                            dataSet().getForm(),
                            dataSet().getFormSize(),
                            dataSet().getFormLineWidth(),
                            dataSet().getFormLineDashEffect(),
                            clrs[j]
                        )
                    )
                }
                let label = pieDataSet.getLabel()
                if (label != "") {
                    this.computedEntries.append(
                        LegendEntry(
                            dataSet().getLabel(),
                            LegendForm.NONE,
                            Float64.NaN,
                            Float64.NaN,
                            Option<DashPathEffect>.None,
                            ColorTemplate.COLOR_NONE
                        )
                    )
                }
            case Some(barDataSet: IBarDataSet) =>
                let sLabels: Array<String> = barDataSet.getStackLabels();

                let minEntries: Int64 = min(clrs.size, barDataSet.getStackSize());

                for (j in 0..minEntries) {
                    var label: String = ""
                    if (sLabels.size > 0) {
                        let labelIndex: Int64 = j % minEntries;
                        label = if (labelIndex < sLabels.size) {
                            sLabels[labelIndex]
                        } else {
                            ""
                        }
                    } else {
                        label = ""
                    }

                    let dashEffect = dataSet().getFormLineDashEffect(); // 使用空对象作为默认值
                    this.computedEntries.append(
                        LegendEntry(
                            label,
                            dataSet().getForm(),
                            dataSet().getFormSize(),
                            dataSet().getFormLineWidth(),
                            dashEffect,
                            clrs[j]
                        )
                    );
                }

                let label = barDataSet.getLabel();
                if (label != "") {
                    // add the legend description label
                    let dashEffect = dataSet().getFormLineDashEffect();
                    this.computedEntries.append(
                        LegendEntry(
                            dataSet().getLabel(),
                            LegendForm.NONE,
                            Float64.NaN,
                            Float64.NaN,
                            dashEffect,
                            ColorTemplate.COLOR_NONE
                        )
                    );
                }
            case _ =>
                var j: Int64 = 0;
                while (j < clrs.size && j < entryCount) {
                    var label: String = ""

                    // if multiple colors are set for a DataSet, group them
                    if (j < clrs.size - 1 && j < entryCount - 1) {
                        label = ""
                    } else { // add label to the last entry
                        if (data.isNone()) {
                            label = ""
                        }
                        let dataObj = data().getDataSetByIndex(i);
                        if (dataObj.isNone()) {
                            label = ""
                        } else {
                            label = dataObj().getLabel()
                        }
                    }
                    var clrsData: UInt32 = 0;
                    if (clrs.isEmpty()) {
                        clrsData = 0
                    }
                    clrsData = (clrs[j])
                    let dashEffect = dataSet().getFormLineDashEffect(); // 使用空对象作为默认值
                    this.computedEntries.append(
                        LegendEntry(
                            label,
                            dataSet().getForm(),
                            dataSet().getFormSize(),
                            dataSet().getFormLineWidth(),
                            dashEffect,
                            clrsData
                        )
                    );
                    j ++
                }
        }
    }
    /**
     * Prepares the legend and calculates all needed forms, labels and colors.
     *
     * @param data
     */
    public func computeLegend<D, S, E>(data: ?D): Unit where D <: ChartData<S, E>, S <: IDataSet<E>, E <: EntryOhos {
        if (this.mLegend.isSome() && !this.mLegend().isLegendCustom() && data.isSome()) {
            this.computedEntries.clear()

            // loop for building up the colors and labels used in the legend
            for (i in 0..data().getDataSetCount()) {
                let dataSet: Option<S> = data().getDataSetByIndex(i)
                if (dataSet.isNone()) {
                    continue
                }

                computeLegendMatchDataSet(dataSet, data, i)

                if (this.mLegend.isSome() && this.mLegend().getExtraEntries().isSome()) {
                    let dataSource: ?Array<LegendEntry> = this.mLegend().getExtraEntries()
                    if (let Some(data) <- dataSource) {
                        for (i in 0..data.size) {
                            this.computedEntries.append(data[i])
                        }
                    }
                }

                match (this.mLegend) {
                    case Some(l) =>
                        l.setEntries(this.computedEntries)
                        let tf: FontFamily = l.getTypeface()

                        this.mLegendLabelPaint.setFontFamily(tf)

                        this.mLegendLabelPaint.setTextSize(l.getTextSize())
                        this.mLegendLabelPaint.setColor(l.getTextColor())

                        // calculate all dimensions of the mLegend
                        l.calculateDimensions(this.mLegendLabelPaint, this.mViewPortHandler())
                    case _ => ()
                }
            }
        }
    }

    public func renderLegend(c: CanvasRenderingContext2D): Unit {
        if (this.mLegend.isNone() || !this.mLegend().isEnabled()) {
            return
        }

        let tf: FontFamily = this.mLegend().getTypeface()

        this.mLegendLabelPaint.setFontFamily(tf)

        this.mLegendLabelPaint.setTextSize(this.mLegend().getTextSize())
        this.mLegendLabelPaint.setColor(this.mLegend().getTextColor())

        // 计算标签行高

        let labelLineHeight: Float64 = Utils.getLineHeight(this.mLegendLabelPaint, c)

        // 计算标签行间距，包括额外的垂直空间
        let labelLineSpacing: Float64 = Utils.getLineSpacing(this.mLegendLabelPaint, c)
            + Utils.handleDataValues(this.mLegend().getYEntrySpace())
        // 计算形状偏移以使其与文本垂直居中
        let formYOffset: Float64 = labelLineHeight - Utils.calcTextHeight(c, this.mLegendLabelPaint, "ABC") / 2.0
        // 获取图例条目
        let entries: Array<LegendEntry> = this.mLegend().getEntries()

        // 获取形状到文本的间距
        let formToTextSpace: Float64 = Utils.handleDataValues(this.mLegend().getFormToTextSpace())

        // 获取水平条目之间的空间
        let xEntrySpace: Float64 = Utils.handleDataValues(this.mLegend().getXEntrySpace())

        // 获取图例方向
        let orientation: LegendOrientation = this.mLegend().getOrientation()
        // 获取图例水平对齐方式
        let horizontalAlignment: LegendHorizontalAlignment = this.mLegend().getHorizontalAlignment()

        // 获取图例垂直对齐方式
        let verticalAlignment: LegendVerticalAlignment = this.mLegend().getVerticalAlignment()

        // 获取图例方向
        let direction: LegendDirection = this.mLegend().getDirection()

        // 获取默认形状的大小
        let defaultFormSize: Float64 = Utils.handleDataValues(this.mLegend().getFormSize())

        // 条目之间的空间
        let stackSpace: Float64 = Utils.handleDataValues(this.mLegend().getStackSpace())
        // 获取垂直偏移量
        let yoffset: Float64 = this.mLegend().getYOffset()

        // 获取水平偏移量
        let xoffset: Float64 = this.mLegend().getXOffset()

        // 设置原点的X坐标
        var originPosX: Float64 = 0.0

        match (horizontalAlignment) {
            case LegendHorizontalAlignment.LEFT =>
                if (orientation == LegendOrientation.VERTICAL) {
                    originPosX = xoffset
                } else {
                    if (let Some(handle) <- this.mViewPortHandler) {
                        originPosX = handle.contentLeft() + xoffset
                    }
                }
                if (let Some(handle) <- this.mViewPortHandler) {
                    AppLog.info(
                        "1. originPosX(${originPosX})= xoffset(${xoffset}) + mViewPortHandler.contentLeft(${handle.contentLeft()})"
                    )
                }

                if (direction == LegendDirection.RIGHT_TO_LEFT) {
                    originPosX += this.mLegend().mNeededWidth
                }

            case LegendHorizontalAlignment.RIGHT =>
                if (let Some(handle) <- this.mViewPortHandler) {
                    if (orientation == LegendOrientation.VERTICAL) {
                        originPosX = handle.getChartWidth() - xoffset
                    } else {
                        originPosX = handle.contentRight() - xoffset
                    }
                }

                if (direction == LegendDirection.LEFT_TO_RIGHT) {
                    originPosX -= this.mLegend().mNeededWidth
                }

            case LegendHorizontalAlignment.CENTER =>
                if (let Some(handle) <- this.mViewPortHandler) {
                    if (orientation == LegendOrientation.VERTICAL) {
                        originPosX = handle.getChartWidth() / 2.0
                    } else {
                        originPosX = handle.contentLeft()
                            + this.mViewPortHandler().contentWidth() / 2.0
                    }
                }

                originPosX += if (direction == LegendDirection.LEFT_TO_RIGHT) {
                    xoffset
                } else {
                    -xoffset
                }

                // Horizontally laid out legends do the center offset on a line basis,
                // So here we offset the vertical ones only.
                if (orientation == LegendOrientation.VERTICAL) {
                    originPosX += if (direction == LegendDirection.LEFT_TO_RIGHT) {
                        -this.mLegend().mNeededWidth / 2.0 + xoffset
                    } else {
                        this.mLegend().mNeededWidth / 2.0 - xoffset
                    }
                }
        }

        match (orientation) { // "HORIZONTAL"
            case LegendOrientation.HORIZONTAL =>
                let calculatedLineSizes: ArrayList<FSize> = this.mLegend().getCalculatedLineSizes()
                let calculatedLabelSizes: ArrayList<FSize> = this.mLegend().getCalculatedLabelSizes()
                let calculatedLabelBreakPoints: ArrayList<Bool> = this.mLegend().getCalculatedLabelBreakPoints()

                var posX: Float64 = originPosX
                var posY: Float64 = 0.0

                match (verticalAlignment) { // "BOTTOM"
                    case LegendVerticalAlignment.TOP =>
                        posY = yoffset
                        AppLog.info("2.0 posY(${posY})= yoffset(${yoffset})")

                    case LegendVerticalAlignment.BOTTOM => if (let Some(handle) <- this.mViewPortHandler) {
                        posY = handle.getChartHeight() - yoffset - this.mLegend().mNeededHeight
                        AppLog.info(
                            "2.1 posY(${posY})= mViewPortHandler.getChartHeight(${handle.getChartHeight()})-mNeededHeight(${this.mLegend().mNeededHeight})-yoffset(${yoffset})"
                        )
                    }

                    case LegendVerticalAlignment.CENTER => if (let Some(handle) <- this.mViewPortHandler) {
                        posY = (handle.getChartHeight() - this.mLegend().mNeededHeight) / 2.0 + yoffset
                        AppLog.info(
                            "2.1 posY(${posY})= mViewPortHandler.getChartHeight(${handle.getChartHeight()})-mNeededHeight/2(${this.mLegend().mNeededHeight / 2.0})+yoffset(${yoffset})"
                        )
                    }
                }

                var lineIndex: Int64 = 0

                for (i in 0..entries.size) {
                    let e: LegendEntry = entries[i]
                    let drawingForm: Bool = e.form != LegendForm.NONE
                    let formSize: Float64 = if (e.formSize.isNaN()) {
                        defaultFormSize
                    } else {
                        Utils.handleDataValues(e.formSize)
                    }

                    if (i < calculatedLabelBreakPoints.size && calculatedLabelBreakPoints.get(i)()) {
                        posX = originPosX
                        posY += labelLineHeight + labelLineSpacing
                        AppLog.info(
                            "3.0 i(${i}) posX=${posX} posY(${posY})=labelLineHeight(${labelLineHeight})+labelLineSpacing(${labelLineSpacing})"
                        )
                    }

                    if (posX == originPosX && horizontalAlignment == LegendHorizontalAlignment.CENTER && // "LEFT"
                        lineIndex <
                        calculatedLineSizes.size) {
                        posX += if (direction == LegendDirection.RIGHT_TO_LEFT) {
                            calculatedLineSizes.get(lineIndex)().width
                        } else {
                            -calculatedLineSizes.get(lineIndex)().width / 2.0
                        }

                        lineIndex++
                    }

                    let isStacked: Bool = e.label.isEmpty() // grouped forms have null labels

                    if (drawingForm) {
                        if (direction == LegendDirection.RIGHT_TO_LEFT) {
                            posX -= formSize
                        }

                        this.drawForm(c, posX, posY + formYOffset, e, this.mLegend())
                        AppLog.info("drawForm posX = ${posX}")

                        if (direction == LegendDirection.LEFT_TO_RIGHT) { // "LEFT_TO_RIGHT"
                            AppLog.info("3.2 i(${i}) posX(${posX})+=formSize(${formSize})")
                            posX += formSize
                        }
                    }

                    if (!isStacked) {
                        if (drawingForm) {
                            AppLog.info("3.3 i(${i}) posX(${posX})+=formToTextSpace(${formToTextSpace})")
                            posX += if (direction == LegendDirection.RIGHT_TO_LEFT) {
                                -formToTextSpace
                            } else {
                                formToTextSpace
                            }
                        }

                        if (direction == LegendDirection.RIGHT_TO_LEFT) {
                            posX -= calculatedLabelSizes.get(i)().width
                        }

                        this.drawLabel(c, posX, posY + labelLineHeight, e.label)
                        AppLog.info("drawLabel posX = ${posX}, e.label = ${e.label}}")

                        if (direction == LegendDirection.LEFT_TO_RIGHT) {
                            AppLog.info(
                                "3.5 i(${i}) posX(${posX})+=calcTextWidth(${Utils.calcTextWidth(c, this.mLegendLabelPaint, e.label)})"
                            )
                            posX += calculatedLabelSizes.get(i)().width
                        }
                        AppLog.info("3.6 i(${i}) posX(${posX})+=xEntrySpace(${xEntrySpace}) stackSpace(${stackSpace})")
                        posX += if (direction == LegendDirection.RIGHT_TO_LEFT) {
                            -xEntrySpace
                        } else {
                            xEntrySpace
                        }
                    } else {
                        posX += if (direction == LegendDirection.RIGHT_TO_LEFT) {
                            -stackSpace
                        } else {
                            stackSpace
                        }
                    }
                }

            case LegendOrientation.VERTICAL =>
                // contains the stacked legend size in pixels
                var stack: Float64 = 0.0
                var wasStacked: Bool = false
                var posY: Float64 = 0.0

                match (verticalAlignment) {
                    case LegendVerticalAlignment.TOP =>
                        posY = if (horizontalAlignment == LegendHorizontalAlignment.CENTER) {
                            0.0
                        } else {
                            if (let Some(handle) <- this.mViewPortHandler) {
                                handle.contentTop()
                            } else {
                                0.0
                            }
                        }
                        posY += yoffset

                    case LegendVerticalAlignment.BOTTOM =>
                        posY = if (horizontalAlignment == LegendHorizontalAlignment.CENTER) {
                            if (let Some(handle) <- this.mViewPortHandler) {
                                handle.getChartHeight()
                            } else {
                                0.0
                            }
                        } else {
                            if (let Some(handle) <- this.mViewPortHandler) {
                                handle.contentBottom()
                            } else {
                                0.0
                            }
                        }

                        posY -= this.mLegend().mNeededHeight + yoffset

                    case LegendVerticalAlignment.CENTER => if (let Some(handle) <- this.mViewPortHandler) {
                        posY = handle.getChartHeight() / 2.0 - this.mLegend().mNeededHeight / 2.0 +
                            this.mLegend().getYOffset()
                    }
                }

                for (i in 0..entries.size) {
                    let e: LegendEntry = entries[i]
                    let drawingForm: Bool = e.form != LegendForm.NONE
                    let formSize: Float64 = if (e.formSize.isNaN()) {
                        defaultFormSize
                    } else {
                        Utils.handleDataValues(e.formSize)
                    }

                    var posX: Float64 = originPosX

                    if (drawingForm) {
                        if (direction == LegendDirection.LEFT_TO_RIGHT) {
                            posX += stack
                        } else {
                            posX -= formSize - stack
                        }

                        this.drawForm(c, posX, posY + formYOffset, e, this.mLegend())

                        if (direction == LegendDirection.LEFT_TO_RIGHT) {
                            posX += formSize
                        }
                    }

                    if (e.label != "") {
                        if (drawingForm && !wasStacked) {
                            posX += if (direction == LegendDirection.LEFT_TO_RIGHT) {
                                formToTextSpace
                            } else {
                                -formToTextSpace
                            }
                        } else if (wasStacked) {
                            posX = originPosX
                        }

                        if (direction == LegendDirection.RIGHT_TO_LEFT) {
                            posX -= Utils.calcTextWidth(c, this.mLegendLabelPaint, e.label)
                        }

                        if (!wasStacked) {
                            this.drawLabel(c, posX, posY + labelLineHeight, e.label)
                        } else {
                            posY += labelLineHeight + labelLineSpacing
                            this.drawLabel(c, posX, posY + labelLineHeight, e.label)
                        }

                        // make a step down
                        posY += labelLineHeight + labelLineSpacing
                        stack = 0.0
                    } else {
                        stack += formSize + stackSpace
                        wasStacked = true
                    }
                }
        }
    }

    // private mLineFormPath:Path2D = new Path2D()
    /**
     * Draws the Legend-form at the given position with the color at the given
     * index.
     *
     * @param c      canvas to draw with
     * @param x      position
     * @param y      position
     * @param entry  the entry to render
     * @param legend the legend context
     */
    func drawForm(c: CanvasRenderingContext2D, x: Float64, y: Float64, entry: LegendEntry, legend: Legend): Unit {
        if (entry.formColor == ColorTemplate.COLOR_SKIP || entry.formColor == ColorTemplate.COLOR_NONE ||
            entry.formColor == 0) {
            return
        }

        c.save()
        var form: LegendForm = entry.form
        if (form == LegendForm.DEFAULT) {
            form = legend.getForm()
        }

        this.mLegendFormPaint.setColor(Color(entry.formColor))
        let formSize: Float64 = Utils.handleDataValues(
            if (entry.formSize.isNaN()) {
            legend.getFormSize()
        } else {
            entry.formSize
        })
        let half: Float64 = formSize / 2.0

        match (form) {
            case LegendForm.DEFAULT => ()
            case LegendForm.CIRCLE =>
                this.mLegendFormPaint.setStyle(Style.FILL)
                Utils.resetContext2DStyle(c, this.mLegendFormPaint)
                c.beginPath()
                c.arc(x + half, y, half, 0.0, 2.0 * Float64.PI)
                c.closePath()
                c.fill()

            case LegendForm.SQUARE =>
                this.mLegendFormPaint.setStyle(Style.FILL)
                Utils.resetContext2DStyle(c, this.mLegendFormPaint)
                c.fillRect(x, y - half, formSize, 2.0 * half)

            case LegendForm.LINE =>
                let formLineWidth: Float64 = Utils.handleDataValues(
                    if (entry.formLineWidth.isNaN()) {
                    legend.getFormLineWidth()
                } else {
                    entry.formLineWidth
                })
                let formLineDashEffect: ?DashPathEffect = if (entry.formLineDashEffect.isNone()) {
                    legend.getFormLineDashEffect()
                } else {
                    entry.formLineDashEffect
                }

                this.mLegendFormPaint.setStyle(Style.STROKE)
                this.mLegendFormPaint.setStrokeWidth(formLineWidth)
                this.mLegendFormPaint.setDashPathEffect(formLineDashEffect /*!*/ )

                Utils.resetContext2DStyle(c, this.mLegendFormPaint)

                c.beginPath()
                c.moveTo(x, y)
                c.lineTo(x + formSize, y)
                c.stroke()
                c.closePath()

            case LegendForm.NONE => ()
            case LegendForm.EMPTY => ()
            case _ => ()
        }
        c.restore()
    }

    /**
     * Draws the provided label at the given position.
     *
     * @param c      to draw with
     * @param x
     * @param y
     * @param label the label to draw
     */
    func drawLabel(c: CanvasRenderingContext2D, x: Float64, y: Float64, label: String): Unit {
        AppLog.info("-------------------sLabels drawLabel: " + label)
        Utils.resetContext2DStyle(c, this.mLegendLabelPaint)
        c.fillText(label, x, y)
    }
}
