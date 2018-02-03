#pragma once

#include<glad\glad.h>

#include "ErrorLogger.h"

#include <iostream>
#include <fstream>
#include <string>
#include <sstream>

//	Names are going to get confusing in this class so just be careful

class Shader
{
public:

	GLuint program;

	Shader(const std::string& vertexShaderFilepath, const std::string& fragmentShaderFilepath)
	{
		std::string vertexShaderSource;
		std::string fragmentShaderSource;

		// Not rendered
		// std::string computeShaderSource;

		// The next 11 lines load GLSL into a stringstream so that OpenGL can understand and compile
		std::ifstream vertexShaderFile(vertexShaderFilepath);
		std::ifstream fragmentShaderFile(fragmentShaderFilepath);

		std::stringstream vertexShaderSourceStream;
		std::stringstream fragmentShaderSourceStream; 

		vertexShaderSourceStream << vertexShaderFile.rdbuf();
		fragmentShaderSourceStream << fragmentShaderFile.rdbuf();

		vertexShaderSource = vertexShaderSourceStream.str();
		fragmentShaderSource = fragmentShaderSourceStream.str();

		// Create vertex shader
		GLuint vertexShader = glCreateShader(GL_VERTEX_SHADER);
		const char* vss = vertexShaderSource.c_str();
		GLCall(glShaderSource(vertexShader, 1, &vss, nullptr));
		GLCall(glCompileShader(vertexShader));

		// Create fragment shader
		GLuint fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
		const char* fss = fragmentShaderSource.c_str();
		GLCall(glShaderSource(fragmentShader, 1, &fss, nullptr));
		GLCall(glCompileShader(fragmentShader));

		// TODO: Write code for compute shader

		// Create shader program
		program = glCreateProgram();

		GLCall(glAttachShader(program, vertexShader));
		GLCall(glAttachShader(program, fragmentShader));
		GLCall(glLinkProgram(program));
		GLCall(glValidateProgram(program));

		GLCall(glDeleteShader(vertexShader));
		GLCall(glDeleteShader(fragmentShader));

	}

	void UseProgram()
	{
		GLCall(glUseProgram(program));
	}

private:

};
