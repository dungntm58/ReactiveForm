import Combine

protocol ValidateControlRegistry {
    func register(_ control: ValidatableControl)
}

protocol Validatable {
  var isValid: Bool { get }
  var isInvalid: Bool { get }
  var isPristine: Bool { get }
  var isDirty: Bool { get }

  func validate()
}

protocol ValidatableControl: Validatable {
  var objectWillChange: ObservableObjectPublisher { get }
}

protocol AbstractControl: ValidatableControl, ObservableObject {
  associatedtype Value where Value: Equatable

  var value: Value { get set }
  var validators: [Validator<Value>] { get }
  var errors: ValidationErrors<Value> { get }
}

typealias AbstractForm = Validatable & ObservableObject
