import Combine

/// A form with a publisher that emits before the form has changed.
///
/// The form collects all controls from its properties
/// that are marked as ``FormControl``.
///
///     class ProfileForm: ObservableForm {
///       var name = FormControl("", validators: [.required])
///       var email = FormControl("", validators: [.email])
///     }
open class ObservableForm: AbstractForm, ValidateControlRegistry {
  /// Stores subscribers of `objectWillChange` from controls.
  private var cancellables: Set<AnyCancellable> = []
  private var controls: [ValidatableControl] = []

  /// A Boolean value indicating whether the form is valid.
  public var isValid: Bool {
    controls.allSatisfy {
      $0.isValid
    }
  }

  /// A Boolean value indicating whether the form is invalid.
  public var isInvalid: Bool {
    !isValid
  }

  /// A Boolean value indicating whether the form has not been changed yet.
  /// All of its controls are ``FormControl/isPristine``
  /// when the value is true.
  public var isPristine: Bool {
    !isDirty
  }

  /// A Boolean value indicating whether the form has been changed.
  /// Some of its controls are ``FormControl/isDirty``
  /// when the value is true.
  public var isDirty: Bool {
    controls.contains {
      $0.isDirty
    }
  }

  /// Creates a observable form and sets to initial state.
  public init() {}

  /// Updates the validity of all controls in the form
  /// and also updates the validity of the form.
  public func validate() {
    controls.forEach {
      $0.validate()
    }
  }

  func register(_ control: ValidatableControl) {
    controls.append(control)
    forward(from: control)
  }
}

private extension ObservableForm {
  /// Forwards `objectWillChange` of FormControl
  /// due to the nested `ObservableObject`.
  func forward(from control: ValidatableControl) {
    control
      .objectWillChange
      .sink(receiveValue: objectWillChange.send)
      .store(in: &cancellables)
  }
}
