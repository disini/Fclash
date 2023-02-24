int testFinally() {
  try {
    return 5;
  } finally {
    print("finally was executed after return in try block");
  }
}

void main(List<String> args) {
  testFinally();
}
