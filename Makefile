# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.10

# Default target executed when no arguments are given to make.
default_target: all

.PHONY : default_target

# Allow only one "make -f Makefile2" at a time, but pass parallelism.
.NOTPARALLEL:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/xander/Documents/Code/CPP/RayTracter/RayTracer

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/xander/Documents/Code/CPP/RayTracter/RayTracer

#=============================================================================
# Targets provided globally by CMake.

# Special rule for the target rebuild_cache
rebuild_cache:
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --cyan "Running CMake to regenerate build system..."
	/usr/bin/cmake -H$(CMAKE_SOURCE_DIR) -B$(CMAKE_BINARY_DIR)
.PHONY : rebuild_cache

# Special rule for the target rebuild_cache
rebuild_cache/fast: rebuild_cache

.PHONY : rebuild_cache/fast

# Special rule for the target edit_cache
edit_cache:
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --cyan "Running CMake cache editor..."
	/usr/bin/ccmake -H$(CMAKE_SOURCE_DIR) -B$(CMAKE_BINARY_DIR)
.PHONY : edit_cache

# Special rule for the target edit_cache
edit_cache/fast: edit_cache

.PHONY : edit_cache/fast

# The main all target
all: cmake_check_build_system
	$(CMAKE_COMMAND) -E cmake_progress_start /home/xander/Documents/Code/CPP/RayTracter/RayTracer/CMakeFiles /home/xander/Documents/Code/CPP/RayTracter/RayTracer/CMakeFiles/progress.marks
	$(MAKE) -f CMakeFiles/Makefile2 all
	$(CMAKE_COMMAND) -E cmake_progress_start /home/xander/Documents/Code/CPP/RayTracter/RayTracer/CMakeFiles 0
.PHONY : all

# The main clean target
clean:
	$(MAKE) -f CMakeFiles/Makefile2 clean
.PHONY : clean

# The main clean target
clean/fast: clean

.PHONY : clean/fast

# Prepare targets for installation.
preinstall: all
	$(MAKE) -f CMakeFiles/Makefile2 preinstall
.PHONY : preinstall

# Prepare targets for installation.
preinstall/fast:
	$(MAKE) -f CMakeFiles/Makefile2 preinstall
.PHONY : preinstall/fast

# clear depends
depend:
	$(CMAKE_COMMAND) -H$(CMAKE_SOURCE_DIR) -B$(CMAKE_BINARY_DIR) --check-build-system CMakeFiles/Makefile.cmake 1
.PHONY : depend

#=============================================================================
# Target rules for targets named main

# Build rule for target.
main: cmake_check_build_system
	$(MAKE) -f CMakeFiles/Makefile2 main
.PHONY : main

# fast build rule for target.
main/fast:
	$(MAKE) -f CMakeFiles/main.dir/build.make CMakeFiles/main.dir/build
.PHONY : main/fast

src/glad.o: src/glad.c.o

.PHONY : src/glad.o

# target to build an object file
src/glad.c.o:
	$(MAKE) -f CMakeFiles/main.dir/build.make CMakeFiles/main.dir/src/glad.c.o
.PHONY : src/glad.c.o

src/glad.i: src/glad.c.i

.PHONY : src/glad.i

# target to preprocess a source file
src/glad.c.i:
	$(MAKE) -f CMakeFiles/main.dir/build.make CMakeFiles/main.dir/src/glad.c.i
.PHONY : src/glad.c.i

src/glad.s: src/glad.c.s

.PHONY : src/glad.s

# target to generate assembly for a file
src/glad.c.s:
	$(MAKE) -f CMakeFiles/main.dir/build.make CMakeFiles/main.dir/src/glad.c.s
.PHONY : src/glad.c.s

src/main.o: src/main.cpp.o

.PHONY : src/main.o

# target to build an object file
src/main.cpp.o:
	$(MAKE) -f CMakeFiles/main.dir/build.make CMakeFiles/main.dir/src/main.cpp.o
.PHONY : src/main.cpp.o

src/main.i: src/main.cpp.i

.PHONY : src/main.i

# target to preprocess a source file
src/main.cpp.i:
	$(MAKE) -f CMakeFiles/main.dir/build.make CMakeFiles/main.dir/src/main.cpp.i
.PHONY : src/main.cpp.i

src/main.s: src/main.cpp.s

.PHONY : src/main.s

# target to generate assembly for a file
src/main.cpp.s:
	$(MAKE) -f CMakeFiles/main.dir/build.make CMakeFiles/main.dir/src/main.cpp.s
.PHONY : src/main.cpp.s

src/rayTracer.o: src/rayTracer.cpp.o

.PHONY : src/rayTracer.o

# target to build an object file
src/rayTracer.cpp.o:
	$(MAKE) -f CMakeFiles/main.dir/build.make CMakeFiles/main.dir/src/rayTracer.cpp.o
.PHONY : src/rayTracer.cpp.o

src/rayTracer.i: src/rayTracer.cpp.i

.PHONY : src/rayTracer.i

# target to preprocess a source file
src/rayTracer.cpp.i:
	$(MAKE) -f CMakeFiles/main.dir/build.make CMakeFiles/main.dir/src/rayTracer.cpp.i
.PHONY : src/rayTracer.cpp.i

src/rayTracer.s: src/rayTracer.cpp.s

.PHONY : src/rayTracer.s

# target to generate assembly for a file
src/rayTracer.cpp.s:
	$(MAKE) -f CMakeFiles/main.dir/build.make CMakeFiles/main.dir/src/rayTracer.cpp.s
.PHONY : src/rayTracer.cpp.s

src/render.o: src/render.cpp.o

.PHONY : src/render.o

# target to build an object file
src/render.cpp.o:
	$(MAKE) -f CMakeFiles/main.dir/build.make CMakeFiles/main.dir/src/render.cpp.o
.PHONY : src/render.cpp.o

src/render.i: src/render.cpp.i

.PHONY : src/render.i

# target to preprocess a source file
src/render.cpp.i:
	$(MAKE) -f CMakeFiles/main.dir/build.make CMakeFiles/main.dir/src/render.cpp.i
.PHONY : src/render.cpp.i

src/render.s: src/render.cpp.s

.PHONY : src/render.s

# target to generate assembly for a file
src/render.cpp.s:
	$(MAKE) -f CMakeFiles/main.dir/build.make CMakeFiles/main.dir/src/render.cpp.s
.PHONY : src/render.cpp.s

# Help Target
help:
	@echo "The following are some of the valid targets for this Makefile:"
	@echo "... all (the default if no target is provided)"
	@echo "... clean"
	@echo "... depend"
	@echo "... rebuild_cache"
	@echo "... main"
	@echo "... edit_cache"
	@echo "... src/glad.o"
	@echo "... src/glad.i"
	@echo "... src/glad.s"
	@echo "... src/main.o"
	@echo "... src/main.i"
	@echo "... src/main.s"
	@echo "... src/rayTracer.o"
	@echo "... src/rayTracer.i"
	@echo "... src/rayTracer.s"
	@echo "... src/render.o"
	@echo "... src/render.i"
	@echo "... src/render.s"
.PHONY : help



#=============================================================================
# Special targets to cleanup operation of make.

# Special rule to run CMake to check the build system integrity.
# No rule that depends on this can have commands that come from listfiles
# because they might be regenerated.
cmake_check_build_system:
	$(CMAKE_COMMAND) -H$(CMAKE_SOURCE_DIR) -B$(CMAKE_BINARY_DIR) --check-build-system CMakeFiles/Makefile.cmake 0
.PHONY : cmake_check_build_system

