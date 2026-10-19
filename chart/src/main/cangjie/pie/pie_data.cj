/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.pie

/**
 * A PieData object can only represent one DataSet. Unlike all other charts, the
 * legend labels of the PieChart are created from the x-values array, and not
 * from the DataSet labels. Each PieData object can only represent one
 * PieDataSet (multiple PieDataSets inside a single PieChart are not possible).
 *
 */
public class PieData <: ChartData<IPieDataSet, PiEntry> {
    public init() {
        super()
    }

    public init(dataSet: IPieDataSet) {
        super([dataSet])
         this.notifyDataChanged()
    }


    /**
     * Sets the PieDataSet this data object should represent.
     *
     * @param dataSet
     */
    public func setDataSet(dataSet: IPieDataSet): Unit {
        this.mDataSets.clear()
        this.mDataSets.add(dataSet)
        this.notifyDataChanged()
    }

    /**
     * Returns the DataSet this PieData object represents. A PieData object can
     * only contain one DataSet.
     *
     * @return
     */
    public func getDataSet(): ?IPieDataSet {
        return this.mDataSets.get(0)
    }

    public override func getDataSets(): ArrayList<IPieDataSet> {
        let dataSets: ArrayList<IPieDataSet> = super.getDataSets()

        if (dataSets.size < 1) {
            AppLog.info("chart,Found multiple data sets while pie chart only allows one")
        }

        return dataSets
    }

    /**
     * The PieData object can only have one DataSet. Use getDataSet() method instead.
     *
     * @param index
     * @return
     */

    public override func getDataSetByIndex(index: Int64): ?IPieDataSet {
        return if (index == 0) {
            this.getDataSet()
        } else {
            None
        }
    }


    public override func getDataSetByLabel(label: String, ignorecase: Bool): ?IPieDataSet {
        return if (ignorecase) {
            if (Utils.equalsIgnoreCase(label, this.mDataSets.get(0)().getLabel())) {
                this.mDataSets.get(0)
            } else {
                None
            }
        } else {
            if (label == this.mDataSets.get(0)().getLabel()) {
                this.mDataSets.get(0)
            } else {
                None
            }
        }
    }


    public override func getEntryForHighlight(highlight: Highlight): ?PiEntry {
        match(this.getDataSet()) {
            case Some(dataSet) =>
               return dataSet.getEntryForIndex(Int64(highlight.getX()))
            case None => None
        }

    }

    /**
     * Returns the sum of all values in this PieData object.
     *
     * @return
     */
    public func getYValueSum(): Float64 {
        var sum: Float64 = 0.0
        var index: Int64 = 0
        if(let Some(dataSet) <- this.getDataSet()) {
            index = dataSet.getEntryCount()
            for (i in 0..index) {
                sum += dataSet.getEntryForIndex(i)().getY()
            }
        }
        return sum
    }
}
