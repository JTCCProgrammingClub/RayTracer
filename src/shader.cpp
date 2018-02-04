#include "shader.h"

Shader::Shader(const std::string& shaderFilePath, 
		GLuint program, GLenum shaderType){

	//Load from file
	std::ifstream shaderFile(shaderFilePath);

	std::stringstream shaderSourceStream;
	shaderSourceStream << shaderFile.rdbuf();

	std::string shaderSrcString = shaderSourceStream.str();
	const char* shaderSrc = shaderSrcString.c_str();

	// setup a shader
	GLuint shader = glCreateShader(shaderType);

	glShaderSource(shader, 1, &shaderSrc, nullptr);
	glCompileShader(shader);

	glAttachShader(program, shader);
	glLinkProgram(program);
	glValidateProgram(program);

	glDeleteShader(shader);
}
