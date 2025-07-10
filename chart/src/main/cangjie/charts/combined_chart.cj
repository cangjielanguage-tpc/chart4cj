/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.charts

import ohos.state_macro_manage.*

@Component
public class CombinedChart {
    var model: CombinedChartModel = CombinedChartModel.build()
    private var setting: RenderingContextSettings = RenderingContextSettings(antialias: true)
    private var context2D: CanvasRenderingContext2D = CanvasRenderingContext2D(this.setting)

    func build() {
        Column() {
            Canvas(this.context2D).onReady(
                {
                    =>
                    this.model.setContext2D(this.context2D)
                }
            ).onAreaChange(
                {
                oldArea: Area, newArea: Area => if (((newArea.width != oldArea.width) || (newArea.height != oldArea.
                    height))) {
                    this.model.onChartSizeChanged(newArea.width, newArea.height, oldArea.width, oldArea.height)
                    let jobs = this.model.mJobs
                    let length = jobs.size
                    for (i in 0..length) {
                        jobs[i].run<CombinedData,IBarLineScatterCandleBubbleDataSet<EntryOhos>, EntryOhos>()
                    }
                    jobs.clear()
                }
            })
        }
    }
}

