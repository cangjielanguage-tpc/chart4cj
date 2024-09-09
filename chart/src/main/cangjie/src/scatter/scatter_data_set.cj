/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package chart.scatter

public class ScatterDataSet <: LineScatterCandleRadarDataSet<EntryOhos> & IScatterDataSet {
    /**
     * the size the scattershape will have, in density pixels
     */
    private var mShapeSize: Float64 = 15.0
    /**
     * Renderer responsible for rendering this DataSet, default: square
     */
    protected var mShapeRenderer: IShapeRenderer = SquareShapeRenderer()
    /**
     * The radius of the hole in the shape (applies to Square, Circle and Triangle)
     * - default: 0.0
     */
    private var mScatterShapeHoleRadius: Float64 = 0.0
    /**
     * Color for the hole in the shape.
     * Setting to `ColorTemplate.COLOR_NONE` will behave as transparent.
     * - default: ColorTemplate.COLOR_NONE
     */
    private var mScatterShapeHoleColor: UInt32 = ColorTemplate.COLOR_NONE

    public init(yVals: ArrayList<EntryOhos>, label: String) {
        super(yVals, label)
        this.calcMinMax()
    }

    public func copy(): DataSet<EntryOhos> {
        var entries: ArrayList<EntryOhos> = ArrayList<EntryOhos>()
        if (let Some(entry) <- this.mEntries) {
            for (i in 0..entry.size) {
                entries.append(entry[i].copy())
            }
        }
        let copied: ScatterDataSet = ScatterDataSet(entries, this.getLabel())
        this.copyTo(copied)
        return copied
    }

    protected func copyTo(scatterDataSet: ScatterDataSet): Unit {
        super.copyTo(scatterDataSet)
        scatterDataSet.mShapeSize = this.mShapeSize
        scatterDataSet.mShapeRenderer = this.mShapeRenderer
        scatterDataSet.mScatterShapeHoleRadius = this.mScatterShapeHoleRadius
        scatterDataSet.mScatterShapeHoleColor = this.mScatterShapeHoleColor
    }

    /**
     * Sets the size in density pixels the drawn scattershape will have. This
     * only applies for non custom shapes.
     *
     * @param size
     */
    public func setScatterShapeSize(size: Float64) {
        this.mShapeSize = size
    }

    public func getScatterShapeSize(): Float64 {
        return this.mShapeSize
    }

    /**
     * Sets the ScatterShape this DataSet should be drawn with. This will search for an available IShapeRenderer and set this
     * renderer for the DataSet.
     *
     * @param shape
     */
    public func setScatterShape(shape: ChartShape): Unit {
        this.mShapeRenderer = ScatterDataSet.getRendererForShape(shape)
    }

    /**
     * Sets a new IShapeRenderer responsible for drawing this DataSet.
     * This can also be used to set a custom IShapeRenderer aside from the default ones.
     *
     * @param shapeRenderer
     */
    public func setShapeRenderer(shapeRenderer: IShapeRenderer): Unit {
        this.mShapeRenderer = shapeRenderer
    }

    public func getShapeRenderer(): IShapeRenderer {
        return this.mShapeRenderer
    }

    /**
     * Sets the radius of the hole in the shape (applies to Square, Circle and Triangle)
     * Set this to <= 0 to remove holes.
     *
     * @param holeRadius
     */
    public func setScatterShapeHoleRadius(holeRadius: Float64): Unit {
        this.mScatterShapeHoleRadius = holeRadius
    }

    public func getScatterShapeHoleRadius(): Float64 {
        return this.mScatterShapeHoleRadius
    }

    /**
     * Sets the color for the hole in the shape.
     *
     * @param holeColor
     */
    public func setScatterShapeHoleColor(holeColor: UInt32): Unit {
        this.mScatterShapeHoleColor = holeColor
    }

    public func getScatterShapeHoleColor(): UInt32 {
        return this.mScatterShapeHoleColor
    }

    public static func getRendererForShape(shape: ChartShape): IShapeRenderer {
        match (shape) {
            case ChartShape.SQUARE => return SquareShapeRenderer()
            case ChartShape.CIRCLE => return CircleShapeRenderer()
            case ChartShape.TRIANGLE => return TriangleShapeRenderer()
            case ChartShape.CROSS => return CrossShapeRenderer()
            case ChartShape.X => return XShapeRenderer()
            case ChartShape.CHEVRON_UP => return ChevronUpShapeRenderer()
            case ChartShape.CHEVRON_DOWN => return ChevronDownShapeRenderer()
        }
    }

    public operator func ==(s: Any): Bool {
        return match (s) {
            case v: ScatterDataSet => refEq(this, v)
            case _ => false
        }
    }

    public operator func !=(s: Any): Bool {
        return !(this == s)
    }
}
