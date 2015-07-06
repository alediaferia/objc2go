project(objc2go)
cmake_minimum_required(VERSION 3.2)

find_package(BISON)
find_package(FLEX)

BISON_TARGET(
  objc2go_parser
  objc2go.y
  ${CMAKE_CURRENT_BINARY_DIR}/objc2go.c)

FLEX_TARGET(
  objc2go_scanner
  objc2go.l
  ${CMAKE_CURRENT_BINARY_DIR}/objc2go_lexer.c)

include_directories(${CMAKE_CURRENT_BINARY_DIR})
add_executable(objc2go
  ${BISON_objc2go_parser_OUTPUTS}
  ${FLEX_objc2go_scanner_OUTPUTS})
target_link_libraries(objc2go ${FLEX_LIBRARY} ${BISON_LIBRARIES})

