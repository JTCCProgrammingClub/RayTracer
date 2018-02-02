cmake_minimum_required (VERSION 3.9.0)

project(RayTracer)

set(GLFW_BUILD_DOCS OFF CACHE BOOL "" FORCE)
set(GLFW_BUILD_TESTS OFF CACHE BOOL "" FORCE)
set(GLFW_BUILD_EXAMPLES OFF CACHE BOOL "" FORCE)
set(CMAKE_BUILD_TYPE Debug)

#include_directories(glad)
find_package(glfw3)
#add_subdirectory(glfw-3.2.1)

add_executable(main 
    src/main.cpp 
    src/glad.c 
	src/rayTracer.cpp
	src/render.cpp
)
include_directories(${GLFW_INCLUDE_DIRS} )
target_link_libraries(main glfw)

#target_link_libraries(main ${GLFW_LIBRARIES})
