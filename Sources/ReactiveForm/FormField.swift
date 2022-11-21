/// A property wrapper type that creates a ``FormControl``.
@propertyWrapper
public struct FormField<Value: Equatable> {
  public static subscript<EnclosingSelf>(
    _enclosingInstance observed: EnclosingSelf,
    wrapped wrappedKeyPath: KeyPath<EnclosingSelf, Value>,
    storage storageKeyPath: KeyPath<EnclosingSelf, Self>
  ) -> Value where EnclosingSelf: ValidateControlRegistry {
    get {
      observed[keyPath: storageKeyPath].projectedValue.value
    }
    set {
      let value = observed[keyPath: wrappedKeyPath]
      let field = observed[keyPath: storageKeyPath]
      field.projectedValue.value = value
      if !field.projectedValue.isRegistered {
        observed.register(field.projectedValue)
        field.projectedValue.markAsRegister()
      }
    }
  }

  private var value: Value

  public private(set) var projectedValue: FormControl<Value>

  @available(*, unavailable, message: "This property wrapper can only be applied to classes")
  public var wrappedValue: Value {
    get { fatalError() }
    set {}
  }

  public init(
    wrappedValue value: Value,
    validators: [Validator<Value>] = []
  ) {
    self.value = value
    self.projectedValue = .init(
      value,
      validators: validators
    )
  }
}
