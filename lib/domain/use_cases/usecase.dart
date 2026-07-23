abstract interface class UseCase<Output, Input> {
  Future<Output> execute(Input input);
}

class NoParams {
  const NoParams();
}
