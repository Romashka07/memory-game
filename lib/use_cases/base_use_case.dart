abstract class BaseUseCase<Input, Output> {
  Future<Output> execute(Input input);
} 