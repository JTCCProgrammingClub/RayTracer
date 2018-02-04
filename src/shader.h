#include "app.h"

//#include "ErrorLogger.h"

#include <iostream>
#include <fstream>
#include <string>
#include <sstream>

//	Names are going to get confusing in this class so just be careful

class Shader
{
public:

	Shader(const std::string& shaderFilePath,
		GLuint program, GLenum shaderType);

		/*
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
		glShaderSource(vertexShader, 1, &vss, nullptr);
		glCompileShader(vertexShader);

		// Create fragment shader
		GLuint fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
		const char* fss = fragmentShaderSource.c_str();
		glShaderSource(fragmentShader, 1, &fss, nullptr);
		glCompileShader(fragmentShader);

		// TODO: Write code for compute shader

		// Create shader program
		program = glCreateProgram();

		glAttachShader(program, vertexShader);
		glAttachShader(program, fragmentShader);
		glLinkProgram(program);
		glValidateProgram(program);

		glDeleteShader(vertexShader);
		glDeleteShader(fragmentShader);

	}

	void UseProgram()
	{
		glUseProgram(program);
	}
	*/

private:

};
