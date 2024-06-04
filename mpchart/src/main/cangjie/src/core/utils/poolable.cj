/**
 * Created on 2024/4/16
 */
package core.utils

public abstract class Poolable {
    public static let NO_OWNER: Int64 = -1
    public var currentOwnerId: Int64 = NO_OWNER

    public open func instantiate(): ?Poolable
}
