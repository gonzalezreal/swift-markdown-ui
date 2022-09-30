import Foundation

public struct _OptionalContent<Wrapped> {
  let wrapped: Wrapped?

  init(_ wrapped: Wrapped?) {
    self.wrapped = wrapped
  }
}
