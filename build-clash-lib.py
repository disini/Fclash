#!/usr/bin/python3
import os

if __name__ == "__main__":
    os.chdir("clash")
    os.system("go build -buildmode=c-shared -o ./libclash.so")
    os.chdir("..")
