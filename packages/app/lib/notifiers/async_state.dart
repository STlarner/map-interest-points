enum AsyncStatus { initial, loading, success, error }

class AsyncState<T> {
  const AsyncState._({required this.status, this.data, this.error});

  factory AsyncState.initial() =>
      const AsyncState._(status: AsyncStatus.initial);

  factory AsyncState.loading() =>
      const AsyncState._(status: AsyncStatus.loading);

  factory AsyncState.success(T data) =>
      AsyncState._(status: AsyncStatus.success, data: data);

  factory AsyncState.error(String error) =>
      AsyncState._(status: AsyncStatus.error, error: error);

  final AsyncStatus status;
  final T? data;
  final String? error;
}
