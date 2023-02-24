#!/usr/bin/python3
import os
import sys

if __name__ == "__main__":
    os.chdir("clash")
    os.environ["CGO_ENABLED"] = "1"
    file_name = "libclash.so"
    if sys.platform == 'win32':
        file_name = "libclash.dll"
    elif sys.platform == "darwin":
        file_name = "libclash.dylib"
    os.system(f"go build -buildmode=c-shared -o {file_name}")

    os.chdir("..")
