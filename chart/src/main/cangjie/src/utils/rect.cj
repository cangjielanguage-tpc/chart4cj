/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package chart.utils

public class ChartRect {
    public var left: Float64 = 0.0
    public var top: Float64 = 0.0
    public var right: Float64 = 0.0
    public var bottom: Float64 = 0.0

    /**
     * Create a new rectangle with the specified coordinates. Note: no range
     * checking is performed, so the caller must ensure that left <= right and
     * top <= bottom.
     *
     * @param left   The X coordinate of the left side of the rectangle
     * @param top    The Y coordinate of the top of the rectangle
     * @param right  The X coordinate of the right side of the rectangle
     * @param bottom The Y coordinate of the bottom of the rectangle
     */
    public init(left!: Float64 = 0.0, top!: Float64 = 0.0, right!: Float64 = 0.0, bottom!: Float64 = 0.0) {
        this.left = left
        this.top = top
        this.right = right
        this.bottom = bottom
    }

    public init(r: ChartRect) {
        this.left = r.left
        this.top = r.top
        this.right = r.right
        this.bottom = r.bottom
    }

    /**
     * Returns a copy of {@code r} if {@code r} is not {@code null}, or {@code null} otherwise.
     *
     * @hide
     */
    public static func copyOrNull(r: ?ChartRect): ?ChartRect {
        return r
    }

    public func equals(o: ChartRect): Bool {
        return this.left == o.left && this.top == o.top && this.right == o.right && this.bottom == o.bottom
    }

    public func toString(): String {
        var sb: String = ""
        sb += "Rect("
        sb += this.left.toString()
        sb += ", "
        sb += this.top.toString()
        sb += " - "
        sb += this.right.toString()
        sb += ", "
        sb += this.bottom.toString()
        sb += ")"
        return sb
    }

    /**
     * Returns true if the rectangle is empty (left >= right or top >= bottom)
     */
    public func isEmpty(): Bool {
        return this.left >= this.right || this.top >= this.bottom
    }

    /**
     * @return the rectangle's width. This does not check for a valid rectangle
     * (i.e. left <= right) so the result may be negative.
     */
    public func width(): Float64 {
        return this.right - this.left
    }

    /**
     * @return the rectangle's height. This does not check for a valid rectangle
     * (i.e. top <= bottom) so the result may be negative.
     */
    public func height(): Float64 {
        return this.bottom - this.top
    }

    /**
     * @return the horizontal center of the rectangle. If the computed value
     *         is fractional, this method returns the largest integer that is
     *         less than the computed value.
     */
    public func centerX(): Float64 {
        return Float64(Int64(this.left + this.right) >> 1)
    }

    /**
     * @return the vertical center of the rectangle. If the computed value
     *         is fractional, this method returns the largest integer that is
     *         less than the computed value.
     */
    public func centerY(): Float64 {
        return Float64(Int64(this.top + this.bottom) >> 1)
    }

    /**
     * @return the exact horizontal center of the rectangle as a float.
     */
    public func exactCenterX(): Float64 {
        return (this.left + this.right) * 0.5
    }

    /**
     * @return the exact vertical center of the rectangle as a float.
     */
    public func exactCenterY(): Float64 {
        return (this.top + this.bottom) * 0.5
    }

    /**
     * Set the rectangle to (0,0,0,0)
     */
    public func setEmpty() {
        this.left = 0.0
        this.right = 0.0
        this.top = 0.0
        this.bottom = 0.0
    }

    /**
     * Set the rectangle's coordinates to the specified values. Note: no range
     * checking is performed, so it is up to the caller to ensure that
     * left <= right and top <= bottom.
     *
     * @param left   The X coordinate of the left side of the rectangle
     * @param top    The Y coordinate of the top of the rectangle
     * @param right  The X coordinate of the right side of the rectangle
     * @param bottom The Y coordinate of the bottom of the rectangle
     */
    public func set(left: Float64, top: Float64, right: Float64, bottom: Float64) {
        this.left = left
        this.top = top
        this.right = right
        this.bottom = bottom
    }

    /**
     * Offset the rectangle by adding dx to its left and right coordinates, and
     * adding dy to its top and bottom coordinates.
     *
     * @param dx The amount to add to the rectangle's left and right coordinates
     * @param dy The amount to add to the rectangle's top and bottom coordinates
     */
    public func offset(dx: Float64, dy: Float64) {
        this.left += dx
        this.top += dy
        this.right += dx
        this.bottom += dy
    }

    /**
     * Offset the rectangle to a specific (left, top) position,
     * keeping its width and height the same.
     *
     * @param newLeft   The new "left" coordinate for the rectangle
     * @param newTop    The new "top" coordinate for the rectangle
     */
    public func offsetTo(newLeft: Float64, newTop: Float64) {
        this.right += newLeft - this.left
        this.bottom += newTop - this.top
        this.left = newLeft
        this.top = newTop
    }

    /**
     * Insets the rectangle on all sides specified by the insets.
     * @hide
     * @param left The amount to add from the rectangle's left
     * @param top The amount to add from the rectangle's top
     * @param right The amount to subtract from the rectangle's right
     * @param bottom The amount to subtract from the rectangle's bottom
     */
    public func inset(left: Float64, top: Float64, right: Float64, bottom: Float64) {
        this.left += left
        this.top += top
        this.right -= right
        this.bottom -= bottom
    }

    /**
     * Returns true if (x,y) is inside the rectangle. The left and top are
     * considered to be inside, while the right and bottom are not. This means
     * that for a x,y to be contained: left <= x < right and top <= y < bottom.
     * An empty rectangle never contains any point.
     *
     * @param x The X coordinate of the point being tested for containment
     * @param y The Y coordinate of the point being tested for containment
     * @return true iff (x,y) are contained by the rectangle, where containment
     *              means left <= x < right and top <= y < bottom
     */
    public func contains(x: Float64, y: Float64): Bool {
        return this.left < this.right && this.top < this.bottom && x >= this.left && x < this.right && y >= this.top &&
            y < this.bottom
    }
}
