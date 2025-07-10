/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package chart.charts

import ohos.state_macro_manage.*

@Component
public class PieChart {
    var model: PieChartModel = PieChartModel.build()
    private var setting: RenderingContextSettings = RenderingContextSettings(antialias: true)
    private var context2D: CanvasRenderingContext2D = CanvasRenderingContext2D(this.setting)

    func build() {
        Column() {
            Canvas(this.context2D).onReady({
                => this.model.setContext2D(this.context2D)
            }).onAreaChange(
                {
                oldArea: Area, newArea: Area => if (((newArea.width != oldArea.width) || (newArea.height != oldArea.
                    height))) {
                    this.model.onChartSizeChanged(newArea.width, newArea.height, oldArea.width, oldArea.height)
                    this.model.onDraw(this.context2D)
                    let jobs = this.model.mJobs
                    let length = jobs.size
                    for (i in 0..length) {
                        jobs[i].run<PieData, IPieDataSet, PiEntry>()
                    }
                    jobs.clear()
                }
            }).onTouch({
                event => this.model.onTouchEvent(event)
            })
            //           .priorityGesture(
            //             TapGesture({ count: 1 })
            //               .onAction({event: GestureEvent =>
            //                 if (event && this.model) {
            //                   this.model.onSingleTapUp(false, event)
            //                 }
            //               })
            //           )
        }
    }
}
