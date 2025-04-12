abstract class BaseUseCase<Input, Output> {
  Future<Output> execute(Input input);
}

// Для випадків, коли не потрібні вхідні дані
abstract class BaseUseCaseNoInput<Output> {
  Future<Output> execute();
}

// Для випадків, коли не потрібні вихідні дані
abstract class BaseUseCaseNoOutput<Input> {
  Future<void> execute(Input input);
}

// Для випадків, коли не потрібні ні вхідні, ні вихідні дані
abstract class BaseUseCaseVoid {
  Future<void> execute();
} 