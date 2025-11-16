class Value<T> {
  final bool hasValue;
  final T? value;

  const Value.absent()
      : hasValue = false,
        value = null;
  const Value.present(this.value) : hasValue = true;
}
