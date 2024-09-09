/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package chart.pie

public interface IScatterDataSet <: ILineScatterCandleRadarDataSet<EntryOhos> {

    /**
     * Returns the currently set scatter shape size
     *
     * @return
     */
    func getScatterShapeSize(): Float64

    /**
     * Returns radius of the hole in the shape
     *
     * @return
     */
    func getScatterShapeHoleRadius(): Float64

    /**
     * Returns the color for the hole in the shape
     *
     * @return
     */
    func getScatterShapeHoleColor(): UInt32

    /**
     * Returns the IShapeRenderer responsible for rendering this DataSet.
     *
     * @return
     */
    func getShapeRenderer(): IShapeRenderer
}
