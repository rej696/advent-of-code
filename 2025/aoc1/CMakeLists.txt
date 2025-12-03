cmake_minimum_required(VERSION 3.14)

project(aoc CXX)

file(READ ${CMAKE_CURRENT_SOURCE_DIR}/raw_input.txt FILE_CONTENT)
set(FILE_CONTENT "R\"(${FILE_CONTENT})\"")
file(WRITE ${CMAKE_CURRENT_SOURCE_DIR}/input.txt ${FILE_CONTENT})

set(CMAKE_CXX_STANDARD 23)

add_executable(aoc main.cpp)


