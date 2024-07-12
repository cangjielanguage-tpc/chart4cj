/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package core.pie

public class PieDataSet <: DataSet<PiEntry> & IPieDataSet  {
    /**
     * the space in pixels between the chart-slices, default 0f
     */
    private var mSliceSpace: Float64 = 0.0;
    private var mAutomaticallyDisableSliceSpacing: Bool = false;
    /**
     * indicates the selection distance of a pie slice
     */
    private var mShift: Float64 = 18.0;
    private var mXValuePosition: ValuePosition = ValuePosition.INSIDE_SLICE;
    private var mYValuePosition: ValuePosition = ValuePosition.INSIDE_SLICE;
    private var mValueLineColor: UInt32 = 0xff000000;
    private var mUseValueColorForLine: Bool = false;
    private var mValueLineWidth: Float64 = 1.0;
    private var mValueLinePart1OffsetPercentage: Float64 = 75.0;
    private var mValueLinePart1Length: Float64 = 0.3;
    private var mValueLinePart2Length: Float64 = 0.4;
    private var mValueLineVariableLength: Bool = true;
    private var mHighlightColor: ?UInt32 = None;

    public init(yVals: ArrayList<PiEntry>, label: String) {
        super(yVals, label);
        this.calcMinMax()
    }

    public func copy(): DataSet<PiEntry> {
        let entries = ArrayList<PiEntry>();
        match (this.mEntries) {
            case None => ()
            case Some(m) => for (i in 0..m.size) {
                entries.append(m.get(i)().copy());
            }
        }
        let copied = PieDataSet(entries, this.getLabel());
        this.copyTo(copied);
        return copied;
    }

    public func myCalcMinMax(e: PiEntry): Unit {
        super.myCalcMinMax(e);
    }

    /**
     * Sets the space that is left out between the piechart-slices in vp.
     * Default: 0 --> no space, maximum 20f
     *
     * @param spaceDp
     */
    public func setSliceSpace(spaceDp: Float64): Unit {
        var dp: Float64 = spaceDp
        if (spaceDp > 20.0) {
            dp = 20.0
        }

        if (spaceDp < 0.0) {
            dp = 0.0
        }

        this.mSliceSpace = Utils.handleDataValues(dp)
    }
    
    public func getSliceSpace(): Float64 {
        return this.mSliceSpace;
    }

    /**
     * When enabled, slice spacing will be 0.0 when the smallest value is going to be
     * smaller than the slice spacing itself.
     *
     * @param autoDisable
     */
    public func setAutomaticallyDisableSliceSpacing(autoDisable: Bool): Unit {
        this.mAutomaticallyDisableSliceSpacing = autoDisable
    }

    /**
     * When enabled, slice spacing will be 0.0 when the smallest value is going to be
     * smaller than the slice spacing itself.
     *
     * @return
     */
    public func isAutomaticallyDisableSliceSpacingEnabled(): Bool {
        return this.mAutomaticallyDisableSliceSpacing;
    }

    /**
     * sets the distance the highlighted piechart-slice of this DataSet is
     * "shifted" away from the center of the chart, default 12f
     *
     * @param shift
     */
    public func setSelectionShift(shift: Float64): Unit {
        this.mShift = Utils.handleDataValues(shift)
    }
    
    public func getSelectionShift(): Float64 {
        return this.mShift;
    }

    public func getXValuePosition(): ValuePosition {
        return this.mXValuePosition;
    }

    public func setXValuePosition(xValuePosition: ValuePosition): Unit {
        this.mXValuePosition = xValuePosition
    }
    
    public func getYValuePosition(): ValuePosition {
        return this.mYValuePosition;
    }

    public func setYValuePosition(yValuePosition: ValuePosition): Unit {
        this.mYValuePosition = yValuePosition
    }

    /**
     * When valuePosition is OutsideSlice, indicates line color
     */
    public func getValueLineColor(): UInt32 {
        return this.mValueLineColor;
    }

    public func setValueLineColor(valueLineColor: UInt32): Unit {
        this.mValueLineColor = valueLineColor
    }

    
    public func isUseValueColorForLineEnabled(): Bool {
        return this.mUseValueColorForLine;
    }

    public func setUseValueColorForLine(enabled: Bool): Unit {
        this.mUseValueColorForLine = enabled
    }

    /**
     * When valuePosition is OutsideSlice, indicates line width
     */
    public func getValueLineWidth(): Float64 {
        return this.mValueLineWidth;
    }

    public func setValueLineWidth(valueLineWidth: Float64): Unit {
        this.mValueLineWidth = valueLineWidth
    }

    /**
     * When valuePosition is OutsideSlice, indicates offset as percentage out of the slice size
     */
    public func getValueLinePart1OffsetPercentage(): Float64 {
        return this.mValueLinePart1OffsetPercentage;
    }

    public func setValueLinePart1OffsetPercentage(valueLinePart1OffsetPercentage: Float64): Unit {
        this.mValueLinePart1OffsetPercentage = valueLinePart1OffsetPercentage
    }

    /**
     * When valuePosition is OutsideSlice, indicates length of first half of the line
     */
    public func getValueLinePart1Length(): Float64 {
        return this.mValueLinePart1Length;
    }
    public func setValueLinePart1Length(valueLinePart1Length: Float64): Unit {
        this.mValueLinePart1Length = valueLinePart1Length
    }

    /**
     * When valuePosition is OutsideSlice, indicates length of second half of the line
     */
    public func getValueLinePart2Length(): Float64 {
        return this.mValueLinePart2Length;
    }

    public func setValueLinePart2Length(valueLinePart2Length: Float64): Unit {
        this.mValueLinePart2Length = valueLinePart2Length
    }

    /**
     * When valuePosition is OutsideSlice, this allows variable line length
     */
    public func isValueLineVariableLength(): Bool {
        return this.mValueLineVariableLength;
    }

    public func setValueLineVariableLength(valueLineVariableLength: Bool): Unit {
        this.mValueLineVariableLength = valueLineVariableLength
    }

    /** Gets the color for the highlighted sector */
    // @Nullable
    public func getHighlightColor(): UInt32 {
        return this.mHighlightColor();
    }

    /** Sets the color for the highlighted sector (null for using entry color) */
    public func setHighlightColor(color: UInt32): Unit {
        this.mHighlightColor = color
    }

    public operator func ==(s: Any): Bool  {
      return  match (s) {
        	case v: PieDataSet => refEq(this,v)
            case _ => false

        }

    }

    public operator func !=(s: Any): Bool {
          return !(this == s)
    }
}
