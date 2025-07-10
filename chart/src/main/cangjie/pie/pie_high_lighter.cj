/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.pie

public class PieHighlighter <: IHighlighter {
    var pieChartModel: PieChartModel
    protected var mHighlightBuffer: Array<Highlight> = Array<Highlight>()

    public init(chart: PieChartModel) {
        this.pieChartModel = chart
    }

    public func getHighlight(x: Float64, y: Float64): ?Highlight {
        if(let Some(data) <- this.getData()) {
            if (data.getMaxEntryCountSet().isNone()) {
                return None
            }
        }

        let touchDistanceToCenter: Float64 = this.pieChartModel.distanceToCenter(x,y)
        if (touchDistanceToCenter > this.pieChartModel.getRadius()) {
            return None
        } else {
            let angle: Float64 = this.pieChartModel.getAngleForPoint(x,y)
            let index = Int64(this.pieChartModel.getIndexForAngle(angle))
            if(index < 0 || index >= this.getData()().getMaxEntryCountSet()().getEntryCount()) {
                return None
            } else {
                return this.getClosestHighlight(index,x,y)
            }
        }
    }

    public func getClosestHighlight(index: Int64, x: Float64, y: Float64): Highlight {
        let chartData: ?PieData = this.getData()
        if(let Some(data) <- chartData){
            let set: ?IPieDataSet = data.getDataSet()
            let entry: PiEntry = set().getEntryForIndex(index)()
            return Highlight(Float64(index), y: entry.getY(), xPx: x,yPx: y,axis: set().getAxisDependency())
        } else {
            return (Highlight(0.0))
        }
    }

    protected func getData(): ?PieData {
        return this.pieChartModel.getPieData()
    }
}
