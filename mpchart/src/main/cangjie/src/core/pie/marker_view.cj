/**
 * Created on 2024/6/14
 */
package core.pie

public class MarkerView <: IMarker {
    private var mOffset: MPPointF = MPPointF()
    private var mOffset2: MPPointF = MPPointF()
    private var mWeakChart: ?ChartModel<ChartData<IDataSet<EntryOhos>, EntryOhos>, IDataSet<EntryOhos>, EntryOhos> = None

    public init() {}

    public func setOffsetByMPPointF(offset: MPPointF) {
        this.mOffset = offset
    }

    public func setOffset(offsetX: Float64, offsetY: Float64): Unit {
        this.mOffset.x = offsetX
        this.mOffset.y = offsetY
    }

    public func getOffset(): MPPointF {
        return this.mOffset
    }

    public func setChartView(chart: ChartModel<ChartData<IDataSet<EntryOhos>, EntryOhos>, IDataSet<EntryOhos>, EntryOhos>): Unit {
        this.mWeakChart = chart
    }

    public func getChartView(): ?ChartModel<ChartData<IDataSet<EntryOhos>, EntryOhos>, IDataSet<EntryOhos>, EntryOhos> {
        return this.mWeakChart
    }

    public func getOffsetForDrawingAtPoint(posX: Float64, posY: Float64): MPPointF {
        let offset: MPPointF = this.getOffset()
        this.mOffset2.x = offset.x
        this.mOffset2.y = offset.y
        return this.mOffset2
    }

    public func draw(c: CanvasRenderingContext2D, posX: Float64, posY: Float64, e: EntryOhos, highlight: Highlight) {
        let offset: MPPointF = this.getOffsetForDrawingAtPoint(posX, posY)
        c.save()

        let roundX = Float64.parse(e.getX().format(".1"))
        let roundY = Float64.parse(e.getY().format(".1"))
        let text: String = "x: ${round(roundX)} y:${round(roundY)}"

        let textMetrics: TextMetrics = c.measureText(text)
        var measureWidth: Float64 = textMetrics.width
        var measureHeight: Float64 = textMetrics.height
        let padding: Float64 = 5.0

        c.beginPath()
        c.fillStyle(Color(0xFFbcbcbc))
        let left: Float64 = posX + offset.x
        let top: Float64 = posY + offset.y
        c.fillRect(left - measureWidth / 2.0 - padding, top - measureHeight - 4.0 * padding, measureWidth + 2.0 * padding,
            measureHeight + 3.0 * padding)
        if (measureWidth < 32.0) {
            measureWidth = 32.0
        }
        if (measureHeight < 12.0) {
            measureHeight = 12.0
        }
        c.beginPath()
        c.moveTo(left - 2.0 * padding, top - 2.0 * padding)
        c.lineTo(left, top + padding / 2.0)
        c.lineTo(left + 2.0 * padding, top - 2.0 * padding)
        c.fill()
        c.closePath()

        //c.fillStyle = Color.Black //todo 标准库不支持
        //c.textAlignStyle = Center
        c.fillText(text, left, top - 3.0 * padding)
        c.closePath()
        c.restore()
    }
}
