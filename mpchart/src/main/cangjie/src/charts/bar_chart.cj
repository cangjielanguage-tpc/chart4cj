/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package mpchart.charts

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*

@Component
public class BarChart {
    var model: BarChartModel = BarChartModel.build()
    private var setting: RenderingContextSettings = RenderingContextSettings(antialias: true)
    private var context2D: CanvasRenderingContext2D = CanvasRenderingContext2D(this.setting)

    func build() {
        Column() {
            Stack(Alignment.TopStart) {
                Canvas(this.context2D).onReady(
                    {
                        =>
                        this.model.setContext2D(this.context2D)
                        this.model.onDraw(this.context2D)
                    }
                ).onAreaChange(
                    {
                    oldArea: Area, newArea: Area => if (((newArea.width != oldArea.width) || (newArea.height != oldArea.
                        height))) {
                        this.model.onChartSizeChanged(400.0, 400.0, oldArea.width, oldArea.height)
                        let jobs = this.model.mJobs
                        let length = jobs.size
                        for (i in 0..length) {
                            jobs[i].run()
                        }
                        jobs.clear()
                    }
                }).onTouch({
                    event => this.model.onTouchEvent(event)
                })
            }
        }
    }
}
