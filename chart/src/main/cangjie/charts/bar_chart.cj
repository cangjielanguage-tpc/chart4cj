/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package chart.charts

//import ohos.base.*
//import ohos.component.*
//import ohos.state_manage.*
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
                        this.model.onChartSizeChanged(px2vp(newArea.width.px)().value, px2vp(newArea.height.px)().value, px2vp(oldArea.width.px)().value, px2vp(oldArea.height.px)().value)
                        let jobs = this.model.mJobs
                        let length = jobs.size
                        for (i in 0..length) {
                            jobs[i].run<BarData,IBarDataSet,BarEntry>()
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
