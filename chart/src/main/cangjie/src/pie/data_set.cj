/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package chart.pie

/**
 * The DataSet class represents one group or type of entries (Entry) in the
 * Chart that belong together. It is designed to logically separate different
 * groups of values inside the Chart (e.g. the values for a specific line in the
 * LineChart, or the values of a specific group of bars in the BarChart).
 *
 */
public abstract open class DataSet<E> <: BaseDataSet<E> where E <: EntryOhos {
    /**
     * the entries that this DataSet represents / holds together
     */
    protected var mEntries: ?ArrayList<E> = None
    /**
     * maximum y-value in the value array
     */
    protected var mYMax: Float64 = -Float64.Max
    /**
     * minimum y-value in the value array
     */
    protected var mYMin: Float64 = Float64.Max
    /**
     * maximum x-value in the value array
     */
    protected var mXMax: Float64 = -Float64.Max
    /**
     * minimum x-value in the value array
     */
    protected var mXMin: Float64 = Float64.Max

    /**
     * Creates a new DataSet object with the given values (entries) it represents. Also, a
     * label that describes the DataSet can be specified. The label can also be
     * used to retrieve the DataSet from a ChartData object.
     *
     * @param entries
     * @param label
     */
    public init(entries: ?ArrayList<E>, label: String) {
        super(label: label)
        this.mEntries = entries
        if (this.mEntries.isNone()) {
            this.mEntries = ArrayList<E>()
        }
    }

    public func calcMinMax(): Unit {
        this.mYMax = -Float64.Max
        this.mYMin = Float64.Max
        this.mXMax = -Float64.Max
        this.mXMin = Float64.Max
        if (this.mEntries.isNone() || this.mEntries().size == 0) {
            return
        }
        for (entry in this.mEntries()) {
            match (entry) {
            	case bubblesEntry: BubblesEntry => this.myCalcMinMaxBubble(bubblesEntry)
            	case waterfallEntry: WaterfallEntry => this.myCalcMinMaxWaterfall(waterfallEntry)
            	case barEntry: BarEntry => this.myBarCalcMinMax(barEntry)
            	case candleEntry: CandleEntry => this.myCandleCalcMinMax(candleEntry)
            	case _ => this.myCalcMinMax(entry)
            }
        }
    }
    public open func myCalcMinMaxBubble(e: BubblesEntry): Unit {
        if (e.getX() < this.mXMin) {
            this.mXMin = e.getX()
        }

        if (e.getX() > this.mXMax) {
            this.mXMax = e.getX()
        }

        if (e.getY() < this.mYMin) {
            this.mYMin = e.getY()
        }

        if (e.getY() > this.mYMax) {
            this.mYMax = e.getY()
        }
    }
    public open func myCalcMinMaxWaterfall(e: WaterfallEntry): Unit {
    }

    public open func myCandleCalcMinMax(e: CandleEntry): Unit {
        if (e.getLow() < this.mYMin) {
            this.mYMin = e.getLow()
        }

        if (e.getHigh() > this.mYMax) {
            this.mYMax = e.getHigh()
        }

        if (e.getX() < this.mXMin) {
            this.mXMin = e.getX()
        }

        if (e.getX() > this.mXMax) {
            this.mXMax = e.getX()
        }
    }

    public func myBarCalcMinMax(e: BarEntry): Unit {
        if (!e.getY().isNaN()) {
            if (e.getYVals().size <= 0) {
                if (e.getY() < this.mYMin) {
                    this.mYMin = e.getY()
                }

                if (e.getY() > this.mYMax) {
                    this.mYMax = e.getY()
                }
            } else {
                if (-e.getNegativeSum() < this.mYMin) {
                    this.mYMin = -e.getNegativeSum()
                }

                if (e.getPositiveSum() > this.mYMax) {
                    this.mYMax = e.getPositiveSum()
                }
            }
            if (e.getX() < this.mXMin) {
                this.mXMin = e.getX()
            }

            if (e.getX() > this.mXMax) {
                this.mXMax = e.getX()
            }
        }
    }

    public func myCalcMinMax(e: ?E): Unit {
        match (e) {
            case Some(t) =>
                this.calcMinMaxX(t)
                match (t) {
                    case v: CandleEntry => this.candleCalcMinMaxY(v)
                    case _ => this.myCalcMinMaxY(t)
                }

            case None => return
        }
    }

    public open func candleCalcMinMaxY(e: CandleEntry): Unit {
        if (e.getHigh() < this.mYMin) {
            this.mYMin = e.getHigh()
        }

        if (e.getHigh() > this.mYMax) {
            this.mYMax = e.getHigh()
        }

        if (e.getLow() < this.mYMin) {
            this.mYMin = e.getLow()
        }

        if (e.getLow() > this.mYMax) {
            this.mYMax = e.getLow()
        }
    }

    public func calcMinMaxY(fromX: Float64, toX: Float64): Unit {
        this.mYMax = -Float64.Max
        this.mYMin = Float64.Max

        match (this.mEntries) {
            case None => return
            case Some(m) =>
                if (m.size == 0) {
                    return
                }
                let indexFrom: Int64 = this.getEntryIndex(fromX, Float64.NaN, Rounding.DOWN)
                let indexTo: Int64 = this.getEntryIndex(toX, Float64.NaN, Rounding.UP)

                if (indexTo < indexFrom) {
                    return
                }

                for (i in indexFrom..indexTo) {
                    this.myCalcMinMaxY(m.get(i)())
                }
        }
    }

    protected func calcMinMaxX(e: E): Unit {
        if (e.getX() < this.mXMin) {
            this.mXMin = e.getX()
        }

        if (e.getX() > this.mXMax) {
            this.mXMax = e.getX()
        }
    }

    protected open func myCalcMinMaxY(e: E): Unit {
        if (e.getY() < this.mYMin) {
            this.mYMin = e.getY()
        }

        if (e.getY() > this.mYMax) {
            this.mYMax = e.getY()
        }
    }

    public func getEntryCount(): Int64 {
        match (this.mEntries) {
            case Some(m) => m.size
            case None => return 0
        }
    }

    /**
     * Returns the array of entries that this DataSet represents.
     *
     * @return
     */
    public func getEntries(): ?ArrayList<E> {
        return this.mEntries
    }

    /**
     * Sets the array of entries that this DataSet represents, and calls notifyDataSetChanged()
     *
     * @return
     */
    public func setEntries(entries: ArrayList<E>): Unit {
        this.mEntries = entries
        this.notifyDataSetChanged()
    }

    /**
     *
     * @param dataSet
     */
    public func copy(): DataSet<E>

    protected func copyTo(dataSet: DataSet<E>): Unit {
        super.copyTo(dataSet)
    }

    public func toString(): String {
        var str: String = this.toSimpleString()
        match (this.mEntries) {
            case _ => return str
            case Some(m) => for (i in 0..m.size) {
                str += m.get(i)().toString() + " "
            }
        }
        return str
    }

    /**
     * Returns a simple string representation of the DataSet with the type and
     * the number of Entries.
     *
     * @return
     */
    public func toSimpleString(): String {
        var size = 0
        if (let Some(entries) <- this.mEntries) {
            size = entries.size
        }

        let str: String = "DataSet, label: " + this.getLabel() + ", entries: " + size.toString() + "\n"
        return str
    }

    public func getYMin(): Float64 {
        return this.mYMin
    }

    public func getYMax(): Float64 {
        return this.mYMax
    }

    public func getXMin(): Float64 {
        return this.mXMin
    }

    public func getXMax(): Float64 {
        return this.mXMax
    }

    public func addEntryOrdered(e: E): Unit {
        match (this.mEntries) {
            case None => this.mEntries = ArrayList<E>()
            case Some(m) =>
                this.myCalcMinMax(e)

                if (m.size > 0 && m.get(m.size - 1)().getX() > e.getX()) {
                    let closestIndex: Int64 = this.getEntryIndex(e.getX(), e.getY(), Rounding.UP)
                } else {
                    m.append(e)
                }
        }
    }

    public func clear(): Unit {
        this.mEntries?.clear()
        this.notifyDataSetChanged()
    }

    public func addEntry(e: ?E): Bool {
        match (e) {
            case None => return false
            case Some(m) =>
                var values: ?ArrayList<E> = this.getEntries()
                if (values.isNone()) {
                    values = ArrayList<E>()
                }

                this.myCalcMinMax(m)

                // add the entry
                values().append(m)
                return true
        }
    }

    public func removeEntry(e: E): Bool {
        match (this.mEntries) {
            case Some(v) =>
                var index: Int64 = 0
                for (i in 0..v.size) {
                    if (refEq(v[i], e)) {
                        index = i
                        break
                    }
                }
                v.remove(index)
                this.calcMinMax()
                return true

            case None => return false
        }
    }

    public func getEntryIndexByEntry(e: E): Int64 {
        var index: Int64 = -1
        match (this.mEntries) {
            case Some(v) => for (i in 0..v.size) {
                if (refEq(v[i], e)) {
                    index = i
                    break
                }
            }
            case None => index = -1
        }
        return index
    }

    public func getEntryForXValue(xValue: Float64, closestToY: Float64, rounding!: Rounding = Rounding.CLOSEST): ?E {
        var myRounding: Rounding = rounding

        let index: Int64 = this.getEntryIndex(xValue, closestToY, myRounding)
        if (index > -1) {
            if (let Some(entries) <- this.mEntries) {
                return entries[index]
            }
        }

        return None
    }

    public func getEntryForIndex(index: Int64): ?E {
        return this.mEntries().get(index)
    }

    private func getEntryIndexFunc(xValue: Float64): Int64 {
        var low: Int64 = 0
        var high: Int64 = this.mEntries().size - 1
        var closest: Int64 = high
        while (low < high) {
            let m: Int64 = Int64(floor((Float64(low + high) / 2.0)))
            let d1: Float64 = this.mEntries().get(m)().getX() - xValue
            let d2: Float64 = this.mEntries().get(m + 1)().getX() - xValue
            let ad1: Float64 = abs(d1)
            let ad2: Float64 = abs(d2)

            if (ad2 < ad1) {
                // [m + 1] is closer to xValue
                // Search in an higher place
                low = m + 1
            } else if (ad1 < ad2) {
                // [m] is closer to xValue
                // Search in a lower place
                high = m
            } else {
                // We have multiple sequential x-value with same distance
                if (d1 >= 0.0) {
                    // Search in a lower place
                    high = m
                } else if (d1 < 0.0) {
                    // Search in an higher place
                    low = m + 1
                }
            }
            closest = high
        }
        return closest
    }

    public func getEntryIndex(xValue: Float64, closestToY: Float64, rounding: Rounding): Int64 {
        if (this.mEntries.isNone() || this.mEntries().size == 0) {
            return -1
        }
        var closest = getEntryIndexFunc(xValue)
        if (closest != -1) {
            let closestXValue: Float64 = this.mEntries().get(closest)().getX()
            if (rounding == Rounding.UP) {
                // If rounding up, and found x-value is lower than specified x, and we can go upper...
                if (closestXValue < xValue && closest < this.mEntries().size - 1) {
                    closest++
                }
            } else if (rounding == Rounding.DOWN) {
                // If rounding down, and found x-value is upper than specified x, and we can go lower...
                if (closestXValue > xValue && closest > 0) {
                    closest--
                }
            }
            // Search by closest to y-value
            if (!closestToY.isNaN()) {
                while (closest > 0 && this.mEntries().get(closest - 1)().getX() == closestXValue) {
                    closest -= 1
                }

                var closestYValue: Float64 = this.mEntries().get(closest)().getY()
                var closestYIndex: Int64 = closest

                while (true) {
                    closest += 1
                    if (closest >= this.mEntries().size) {
                        break
                    }

                    let value: EntryOhos = this.mEntries().get(closest)()

                    if (value.getX() != closestXValue) {
                        break
                    }

                    if (abs(value.getY() - closestToY) <= abs(closestYValue - closestToY)) {
                        closestYValue = closestToY
                        closestYIndex = closest
                    }
                }
                closest = closestYIndex
            }
        }
        return closest
    }

    public func getEntriesForXValue(xValue: Float64): ArrayList<E> {
        let entries: ArrayList<E> = ArrayList<E>()
        if (this.mEntries.isNone()) {
            return entries
        }
        var low: Int64 = 0
        var high: Int64 = this.mEntries().size - 1

        while (low <= high) {
            var m: Int64 = (high + low) / 2
            m = Int64(Utils.parseInt(Float64(m)))
            var entry: E = this.mEntries().get(m)()
            // if we have a match
            if (xValue == entry.getX()) {
                while (m > 0 && this.mEntries().get(m - 1)().getX() == xValue) {
                    m--
                }

                high = this.mEntries().size

                // loop over all "equal" entries
                for (m in 0..high) {
                    if (let Some(entries) <- this.mEntries) {
                        entry = entries[m]
                        if (entry.getX() == xValue) {
                            entries.append(entry)
                        } else {
                            break
                        }
                    }
                }

                break
            } else {
                if (xValue > entry.getX()) {
                    low = m + 1
                } else {
                    high = m - 1
                }
            }
        }

        return entries
    }
}
