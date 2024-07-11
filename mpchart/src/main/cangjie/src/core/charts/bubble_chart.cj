/**
 * Created on 2024/6/25
 */
package core.charts

@Component
public class BubbleChart {
    var model: BubbleChartModel = BubbleChartModel.build()
    private var setting: RenderingContextSettings = RenderingContextSettings(antialias: true)
    private var context2D: CanvasRenderingContext2D = CanvasRenderingContext2D(this.setting)

    func render() {
        Column() {
            Canvas(this.context2D).onReady({
                => this.model.setContext2D(this.context2D)
            }).onAreaChange(
                {
                oldArea: Area, newArea: Area => if (((newArea.width != oldArea.width) || (newArea.height != oldArea.
                    height))) {
                    this.model.onChartSizeChanged(400.0, 400.0, oldArea.width, oldArea.height)
                    this.model.onDraw(this.context2D)
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
