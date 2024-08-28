/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package mpchart.radar

public class RadarData <: ChartData<IRadarDataSet, RadarEntry> {
    private var mLabels: Array<String> = Array<String>()

    public init(dataSets: ArrayList<IRadarDataSet>) {
        super(dataSets)
        this.notifyDataChanged()
    }

    /**
     * Sets the labels that should be drawn around the RadarChart at the end of each web line.
     *
     * @param labels
     */
    func setLabels(labels: Array<String>): Unit {
        this.mLabels = labels
    }

    func getLabels(): Array<String> {
        return this.mLabels
    }

    public func getEntryForHighlight(highlight: Highlight): ?RadarEntry {
        let dataSet: ?IRadarDataSet = this.getDataSetByIndex(highlight.getDataSetIndex())
        if(let Some(dataSet) <- dataSet) {
           return dataSet.getEntryForIndex(Int64(floor(highlight.getX())))
        } else {
            None
        }

    }
}
