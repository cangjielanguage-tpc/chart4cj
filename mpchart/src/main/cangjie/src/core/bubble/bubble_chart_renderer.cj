/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package core.bubble

public class BubbleChartRenderer <: BarLineScatterCandleBubbleRenderer {
    public var mChart: BubbleDataProvider

    public init(chart: BubbleDataProvider, animator: ChartAnimator, viewPortHandler: ViewPortHandler) {
        super(animator, viewPortHandler);
        this.mChart = chart

        this.mRenderPaint.setStyle(Style.FILL);

        this.mHighlightPaint.setStyle(Style.STROKE);
        this.mHighlightPaint.setStrokeWidth(Utils.handleDataValues(1.5));
    }

    public func initBuffers(): Unit {}

    public func drawData(c: CanvasRenderingContext2D): Unit {
        let bubbleData: ?BubbleData = this.mChart.getBubbleData();

        if (let Some(b) <- bubbleData) {
            for (i in 0..b.getDataSets().size) {
                if (b.getDataSets()[i].isVisible()) {
                    this.drawDataSet(c, b.getDataSets()[i]);
                }
            }
        } else {
            return
        }
    }

    private var sizeBuffer: Array<Float64> = Array<Float64>(4, item: 0.0);
    private var pointBuffer: Array<Float64> = Array<Float64>(2, item: 0.0);

    protected func getShapeSize(entrySize: Float64, maxSize: Float64, reference: Float64, normalizeSize: Bool): Float64 {
        let factor: Float64 = if (normalizeSize) {
            if (maxSize == 0.0) {
                1.0
            } else {
                sqrt(entrySize / maxSize)
            }
        } else {
            entrySize
        }
        let shapeSize: Float64 = reference * factor
        return shapeSize;
    }

    protected func drawDataSet(c: CanvasRenderingContext2D, dataSet: IBubbleDataSet): Unit {
        if (dataSet.getEntryCount() < 1) {
            return;
        }

        let trans: ?Transformer = this.mChart.getTransformer(dataSet.getAxisDependency());
        if (let Some(m) <- this.mAnimator) {
            if (let Some(v) <- this.mViewPortHandler) {
                let phaseY: Float64 = m.getPhaseY();
                if (let Some(bounds) <- this.mXBounds) {
                    bounds.set(this.mChart, dataSet)
                }

                this.sizeBuffer[0] = 0.0
                this.sizeBuffer[2] = 1.0

                trans?.pointValuesToPixel(this.sizeBuffer)

                let normalizeSize: Bool = dataSet.isNormalizeSizeEnabled();

                // calculate the full width of 1 step on the x-axis
                let maxBubbleWidth: Float64 = abs(this.sizeBuffer[2] - this.sizeBuffer[0]);
                let maxBubbleHeight: Float64 = abs(v.contentBottom() - v.contentTop());
                let referenceSize: Float64 = min(maxBubbleHeight, maxBubbleWidth);
                if (let Some(b) <- this.mXBounds) {
                    for (j in Int64(b.mins)..=Int64(b.range + b.mins)) {
                        let entry: BubbleEntry = dataSet.getEntryForIndex(j);

                        this.pointBuffer[0] = entry.getX()
                        this.pointBuffer[1] = (entry.getY()) * phaseY
                        trans?.pointValuesToPixel(this.pointBuffer)
                        let shapeHalf: Float64 = this.getShapeSize(entry.getSize(), dataSet.getMaxSize(),
                            referenceSize, normalizeSize) / 2.0
                        if (!v.isInBoundsTop(this.pointBuffer[1] + shapeHalf) ||
                            !v.isInBoundsBottom(this.pointBuffer[1] - shapeHalf)) {
                            continue;
                        }

                        if (!v.isInBoundsLeft(this.pointBuffer[0] + shapeHalf)) {
                            continue;
                        }

                        if (!v.isInBoundsRight(this.pointBuffer[0] - shapeHalf)) {
                            break;
                        }
                        let color: UInt32 = dataSet.getColor(j);
                        this.mRenderPaint.setColor(Color(color))

                        Utils.resetContext2DStyle(c, this.mRenderPaint);

                        c.beginPath();
                        c.arc(this.pointBuffer[0], this.pointBuffer[1], shapeHalf, 0.0, 2.0 * Float64.PI,
                            anticlockwise: true);
                        c.stroke();
                        c.fill();
                        c.closePath();
                    }
                } else {
                    return
                }
            }
        }
    }

    public func drawValues(c: CanvasRenderingContext2D, isHorizontalFlip!: Bool): Unit {
        let bubbleData: ?BubbleData = this.mChart.getBubbleData();

        if (let Some(b) <- bubbleData) {
            if ((this as DataRenderer)().isDrawingValuesAllowed(this.mChart) && this.mXBounds.isSome()) {
                let dataSets: ArrayList<IBubbleDataSet> = b.getDataSets();

                let lineHeight: Float64 = Utils.calcTextHeight(c, this.mValuePaint, "1");

                for (i in 0..dataSets.size) {
                    let dataSet: IBubbleDataSet = dataSets[i];

                    if (!this.shouldDrawValues(dataSet) || dataSet.getEntryCount() < 1) {
                        continue;
                    }

                    // apply the text-styling defined by the DataSet
                    this.applyValueTextStyle(dataSet)
                    if (this.mAnimator.isSome() || this.mViewPortHandler.isSome()) {
                        continue
                    }
                    let phaseX: Float64 = max(0.0, min(1.0, this.mAnimator().getPhaseX()));
                    let phaseY: Float64 = this.mAnimator().getPhaseY();

                    this.mXBounds?.set(this.mChart, dataSet)
                    let positions: Array<Float64> = this.mChart.getTransformer(dataSet.getAxisDependency())().
                        generateTransformedValuesBubble(dataSet, phaseY, Int64(this.mXBounds().mins), Int64(this.mXBounds().maxs))

                    let alpha: Float64 = if (phaseX == 1.0) {
                        phaseY
                    } else {
                        phaseX;
                    }

                    let iconsOffset: MPPointF = MPPointF.getInstance(dataSet.getIconsOffset());
                    iconsOffset.x = Utils.handleDataValues(iconsOffset.x)
                    iconsOffset.y = Utils.handleDataValues(iconsOffset.y)

                    var j: Int64 = 0
                    while (j < positions.size) {
                        var valueTextColor: UInt32 = dataSet.getValueTextColor(Int64(j / 2 + Int64(this.mXBounds().mins))
                        );
                        valueTextColor = UInt32(ChartColor.argb(round(255.0 * alpha),
                                ChartColor.red(Int64(valueTextColor)), ChartColor.green(Int64(valueTextColor)),
                                ChartColor.blue(Int64(valueTextColor))))

                        let x: Float64 = positions[j];
                        let y: Float64 = positions[j + 1];

                        if ((!this.mViewPortHandler().isInBoundsLeft(x) || !this.mViewPortHandler().isInBoundsY(y))) {
                            j += 2
                            continue;
                        }

                        let entry: BubbleEntry = dataSet.getEntryForIndex(j / 2 + Int64(this.mXBounds().mins));

                        if (dataSet.isDrawValuesEnabled()) {
                            this.drawValue(c, dataSet.getValueFormatter()(), entry.getSize(), entry, i, x,
                                y + (0.5 * lineHeight), Color(valueTextColor));
                        }
                        if (let Some(i) <- entry.getIcon()) {
                            if (dataSet.isDrawIconsEnabled()) {
                                Utils.drawImage(
                                    c,
                                    i,
                                    (x + iconsOffset.x),
                                    (y + iconsOffset.y)
                                )
                            }
                        }

                        j += 2
                    }

                    MPPointF.recycleInstance(iconsOffset);
                }
            }
        } else {
            return
        }
    }

    public func drawExtras(c: CanvasRenderingContext2D): Unit {
    }

    private var _hsvBuffer: Array<Float64> = Array<Float64>(3, item: 0.0);

    public func drawHighlighted(c: CanvasRenderingContext2D, indices: Array<Highlight>): Unit {
        let bubbleData: ?BubbleData = this.mChart.getBubbleData();
        if (let Some(b) <- bubbleData) {
            if (this.mAnimator.isSome() && this.mViewPortHandler.isSome()) {
                let phaseY: Float64 = this.mAnimator().getPhaseY();

                for (i in 0..indices.size) {
                    let set: ?IBubbleDataSet = b.getDataSetByIndex(indices[i].getDataSetIndex());
                    if (set.isNone() || !set().isHighlightEnabled()) {
                        continue;
                    }

                    let entry: ?BubbleEntry = set().getEntryForXValue(indices[i].getX(), indices[i].getY(),
                        rounding: Rounding.CLOSEST);

                    if (entry.isNone() || entry().getY() != indices[i].getY()) {
                        continue;
                    }

                    if (!this.isInBoundsX(entry(), (set as IBarLineScatterCandleBubbleDataSet<EntryOhos>)())) {
                        continue;
                    }

                    let trans: ?Transformer = this.mChart.getTransformer(set().getAxisDependency());

                    this.sizeBuffer[0] = 0.0
                    this.sizeBuffer[2] = 1.0

                    trans?.pointValuesToPixel(this.sizeBuffer)

                    let normalizeSize: Bool = set().isNormalizeSizeEnabled();

                    // calculate the full width of 1 step on the x-axis
                    let maxBubbleWidth: Float64 = abs(this.sizeBuffer[2] - this.sizeBuffer[0]);
                    let maxBubbleHeight: Float64 = abs(
                        this.mViewPortHandler().contentBottom() - this.mViewPortHandler().contentTop());
                    let referenceSize: Float64 = min(maxBubbleHeight, maxBubbleWidth);

                    this.pointBuffer[0] = entry().getX()
                    this.pointBuffer[1] = (entry().getY()) * phaseY
                    trans?.pointValuesToPixel(this.pointBuffer)

                    indices[i].setDraw(this.pointBuffer[0], this.pointBuffer[1]);

                    let shapeHalf: Float64 = this.getShapeSize(
                        entry().getSize(),
                        set().getMaxSize(),
                        referenceSize,
                        normalizeSize
                    ) / 2.0

                    if (!this.mViewPortHandler().isInBoundsTop(this.pointBuffer[1] + shapeHalf) ||
                        !this.mViewPortHandler().isInBoundsBottom(this.pointBuffer[1] - shapeHalf)) {
                        continue;
                    }

                    if (!this.mViewPortHandler().isInBoundsLeft(this.pointBuffer[0] + shapeHalf)) {
                        continue;
                    }

                    if (!this.mViewPortHandler().isInBoundsRight(this.pointBuffer[0] - shapeHalf)) {
                        break;
                    }

                    let originalColor: UInt32 = set().getColor(Int64(entry().getX()));

                    ChartColor.RGBToHSV(ChartColor.red(Int64(originalColor)), ChartColor.green(Int64(originalColor)),
                        ChartColor.blue(Int64(originalColor)), ArrayList<Float64>(this._hsvBuffer));
                    this._hsvBuffer[2] *= 0.5
                    let color: UInt32 = UInt32(ChartColor.HSVToColor(
                            Float64(ChartColor.alpha(Int64(originalColor))),
                            Array<Int64>(this._hsvBuffer.size, item: Int64(this._hsvBuffer[i]))
                        ));

                    this.mHighlightPaint.setColor(Color(color));
                    this.mHighlightPaint.setStrokeWidth(set().getHighlightCircleWidth());
                    Utils.resetContext2DStyle(c, this.mHighlightPaint);
                    c.beginPath();
                    c.arc(this.pointBuffer[0], this.pointBuffer[1], shapeHalf, 0.0, 2.0 * Float64.PI);
                    c.stroke();
                    c.closePath();
                }
            }
        } else {
            return
        }
    }
}
