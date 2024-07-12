/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package core.line

public interface IFillFormatter {

    /**
     * Returns the vertical (y-axis) position where the filled-line of the
     * LineDataSet should end.
     *
     * @param dataSet the ILineDataSet that is currently drawn
     * @param dataProvider
     * @return
     */
    func getFillLinePosition(dataSet: ILineDataSet, dataProvider: LineDataProvider): Float64
}
