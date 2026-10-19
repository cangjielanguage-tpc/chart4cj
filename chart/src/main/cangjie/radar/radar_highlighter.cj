/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.radar

public class RadarHighlighter <: PieRadarHighlighter<RadarChartModel, RadarData, IRadarDataSet, RadarEntry> {
    public init(chart: RadarChartModel) {
        super(chart)
    }

    protected func getClosestHighlight(index: Int64, x: Float64, y: Float64): Highlight {
        let highlights = this.getHighlightsAtIndex(index)

        let distanceToCenter = this.mChart().distanceToCenter(x, y) / this.mChart().getFactor()

        var closest: Highlight = Highlight(0.0)
        var distance = Float64.Max

        for (i in 0..highlights.size) {
            let high = highlights[i]

            let cdistance = abs(high.getY() - distanceToCenter)

            if (cdistance < distance) {
                closest = high
                distance = cdistance
            }
        }

        return closest
    }

    /**
     * Returns an array of Highlight objects for the given index. The Highlight
     * objects give information about the value at the selected index and the
     * DataSet it belongs to. INFORMATION: This method does calculations at
     * runtime. Do not over-use in performance critical situations.
     *
     * @param index
     * @return
     */
    protected func getHighlightsAtIndex(index: Int64): ArrayList<Highlight> {
        if ((this.mChart().getData() as RadarData).isNone()) {
            return ArrayList<Highlight>([])
        }
        var highlightBuffer: ArrayList<Highlight> = ArrayList<Highlight>([])

        let animator = this.mChart().getAnimator()
        if (animator.isNone()) {
            return ArrayList<Highlight>([])
        }
        let phaseX = animator().getPhaseX()
        let phaseY = animator().getPhaseY()
        let sliceangle = this.mChart().getSliceAngle()
        let factor = this.mChart().getFactor()

        var pOut = MPPointF.getInstance(0.0, 0.0)
        let count: Int64 = (this.mChart().getData() as RadarData)().getDataSetCount()
        for (i in 0..count) {
            if (let Some(dataSet: IRadarDataSet) <- (this.mChart().getData() as RadarData)().getDataSetByIndex(i)) {
                let entry = dataSet.getEntryForIndex(index)()

                let y = entry.getY() - this.mChart().getYChartMin()

                let centerOffsets: ?MPPointF = this.mChart().getCenterOffsets()
                if (let Some(centerOffsets) <- centerOffsets) {
                    pOut = Utils.getPosition(
                        centerOffsets,
                        y * factor * phaseY,
                        sliceangle * Float64(index) * phaseX + this.mChart().getRotationAngle(),
                        pOut
                    )
                }

                highlightBuffer.add(
                    Highlight(Float64(index), y: entry.getY(), dataSetIndex: i, dataIndex: 0, stackIndex: 0, xPx: pOut.x,
                    yPx: pOut.y, axis: dataSet.getAxisDependency()))
            } else {
                continue
            }
        }

        return highlightBuffer
    }
}
