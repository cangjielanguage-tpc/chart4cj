/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.radar

public class RadarHighlighter <: IHighlighter {
    var radarChartModel: RadarChartModel
    protected var mHighlightBuffer: Array<Highlight> = Array<Highlight>()

    public init(chart: RadarChartModel) {
        this.radarChartModel = chart
    }

    public func getHighlight(x: Float64, y: Float64): ?Highlight {
        if(let Some(data) <- this.getData()) {
            if (data.getMaxEntryCountSet().isNone()) {
                return None
            }
        }

        let touchDistanceToCenter: Float64 = this.radarChartModel.distanceToCenter(x,y)
        if (touchDistanceToCenter > this.radarChartModel.getRadius()) {
            return None
        } else {
            let angle: Float64 = this.radarChartModel.getAngleForPoint(x,y)
            let index = Int64(this.radarChartModel.getIndexForAngle(angle))
            if(index < 0 || index >= this.getData()().getMaxEntryCountSet()().getEntryCount()) {
                return None
            } else {
                return this.getClosestHighlight(index,x,y)
            }
        }
    }

    public func getClosestHighlight(index: Int64, x: Float64, y: Float64): ?Highlight {
        let highlights: ArrayList<Highlight> = this.getHighlightsAtIndex(index)

        let distanceToCenter: Float64 = this.radarChartModel.distanceToCenter(x, y) / this.radarChartModel.getFactor()

        var closest: ?Highlight = Option<Highlight>.None
        var distance: Float64 = Float64.Max

        for (i in 0..highlights.size) {
            let highlight: ?Highlight = highlights.get(i)
            if(let Some(high) <- highlight) {
                let cdistance: Float64 = abs(high.getY() - distanceToCenter)
                if (cdistance < distance) {
                    closest = high
                    distance = cdistance
                }
            }


        }

        return closest
    }

    protected func getHighlightsAtIndex(index: Int64): ArrayList<Highlight> {
        if (this.radarChartModel.getRadarData().isNone()) {
            return ArrayList<Highlight>()
        }
        var highlightBuffer: ArrayList<Highlight> = ArrayList<Highlight>()

        let animator = this.radarChartModel.getAnimator()
        if (animator.isNone()) {
            return ArrayList<Highlight>()
        }
        let phaseX = animator().getPhaseX()
        let phaseY = animator().getPhaseY()
        let sliceangle = this.radarChartModel.getSliceAngle()
        let factor = this.radarChartModel.getFactor()

        var pOut = MPPointF.getInstance(0.0, 0.0)

        for (i in 0..this.radarChartModel.getRadarData()().getDataSetCount()) {
            let dataSet: ?IRadarDataSet = this.radarChartModel.getRadarData()().getDataSetByIndex(i)
            if (dataSet.isNone()) {
                continue
            }
            let radarEntry: ?RadarEntry = dataSet().getEntryForIndex(index)
            if(let Some(entry) <- radarEntry) {
                let y = entry.getY() - this.radarChartModel.getYChartMin()

                let centerOffsets: ?MPPointF = this.radarChartModel.getCenterOffsets()
                if (centerOffsets.isSome()) {
                    pOut = Utils.getPosition(
                        centerOffsets(),
                        y * factor * phaseY,
                        sliceangle * Float64(index) * phaseX + this.radarChartModel.getRotationAngle(),
                        pOut
                    )
                }

                highlightBuffer.add(Highlight(Float64(index), y: entry.getY(), dataSetIndex: i, dataIndex: 0, stackIndex: 0, xPx: pOut.x, yPx: pOut.y, axis: dataSet().getAxisDependency()))
            }


        }
        MPPointF.recycleInstance(pOut)

        return highlightBuffer
    }

    protected func getData(): ?RadarData {
        return this.radarChartModel.getRadarData()
    }
}
