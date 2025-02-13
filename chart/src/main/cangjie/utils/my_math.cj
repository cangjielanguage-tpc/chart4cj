/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.utils

public class MyMath {
    /**
     * Constant by which to multiply an angular value in radians to obtain an
     * angular value in degrees.
     */
    private static let radians: Float64 = 57.29577951308232
    /**
     * Constant by which to multiply an angular value in degrees to obtain an
     * angular value in radians.
     */
    private static let degrees: Float64 = 0.017453292519943295

    /**
     * Converts an angle measured in degrees to an approximately
     * equivalent angle measured in radians.  The conversion from
     * degrees to radians is generally inexact.
     *
     * @param angdeg   an angle, in degrees
     * @return the measurement of the angle {@code angdeg}
     *          in radians.
     */
    public static func toRadians(ang: Float64): Float64 {
        return ang * MyMath.degrees
    }

    /*
    Converts an angle measured in radians to an approximately equivalent angle measured in degrees. The conversion from radians to degrees is generally inexact; users should not expect cos(toRadians(90.0)) to exactly equal 0.0.
    Params:
    angrad – an angle, in radians
     */
    public static func toDegrees(ang: Float64): Float64 {
        return ang * MyMath.radians
    }
}
