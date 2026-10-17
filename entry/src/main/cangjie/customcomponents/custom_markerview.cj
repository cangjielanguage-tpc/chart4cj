/**
 * Created on 2025/7/15
 */
package ohos_app_cangjie_entry.customcomponents

public class BarMarkerView <: IMarker {
  private var mOffset: MPPointF = MPPointF()
  private var mOffset2: MPPointF = MPPointF()
  private var mWeakChart: ?BarChartModel = Option<BarChartModel>.None
    
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

  public func setChartView(chart: BarChartModel): Unit {
    this.mWeakChart = chart
  }

  public func getChartView(): ?BarChartModel {
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

    let barentry: ?BarEntry = e as BarEntry
    if(let Some(entry) <- barentry) {
        let yValues: Array<Float64> = entry.getYVals()

        let text: String = "x: ${e.getX().format(".1")} y: ${e.getY().format(".1")}"

        let textMetrics: TextMetrics = c.measureText(text)
        var measureWidth: Float64 = vp2px(textMetrics.width.vp)().value
        var measureHeight: Float64 = vp2px(textMetrics.height.vp)().value
        let padding: Float64 = 5.0

        c.beginPath()
        c.fillStyle(0xffffdead)
        let left: Float64 = posX + offset.x
        let top: Float64 = posY + offset.y
        c.fillRect(left - measureWidth / 2.0 - padding, top - measureHeight - 4.0 * padding, measureWidth + 2.0 * padding, measureHeight + 3.0 * padding)
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

        c.fillStyle(Color.BLACK)
        c.textAlign(TextAlignStyle.Center)
        c.fillText(text, left, top - 3.0 * padding)
        c.closePath()
        c.restore()
    }

  }
}