cmake_minimum_required(VERSION 3.24)
project(riscv_translator)

set(CMAKE_CXX_STANDARD 17)

add_executable(riscv_translator trans_main.cpp translator.cpp translator.h)
