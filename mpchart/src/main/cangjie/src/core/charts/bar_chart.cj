package core.charts
@Component
public class BarChart {
    var model: BarChartModel = BarChartModel.build()
    private var setting: RenderingContextSettings = RenderingContextSettings(antialias: true)
    private var context2D: CanvasRenderingContext2D = CanvasRenderingContext2D(this.setting)

    func render() {
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
                        this.model.onChartSizeChanged(300.0, 300.0, oldArea.width, oldArea.height)
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
