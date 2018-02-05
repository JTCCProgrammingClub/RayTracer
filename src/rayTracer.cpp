#include "programs.h"
#include "shader.h"
#include <iostream>

GLuint genScreen(){
	GLuint texHandle;
	glGenTextures(1, &texHandle);

	glActiveTexture(GL_TEXTURE0);
	glBindTexture(GL_TEXTURE_2D, texHandle);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_R32F, 512, 512, 0, GL_RED, GL_FLOAT, NULL);

	// Because we're also using this tex as an image (in order to write to it),
	// we bind it to an image unit as well
	glBindImageTexture(0, texHandle, 0, GL_FALSE, 0, GL_WRITE_ONLY, GL_R32F);
	return texHandle;
}

GLuint genRayTracerProg(){
	
	GLuint progHandle = glCreateProgram();
	Shader compShader("shaders/comp.glsl", progHandle, GL_COMPUTE_SHADER);

	// Initialize program
	glUseProgram(progHandle);
	glUniform1i(glGetUniformLocation(progHandle, "destTex"), 0);

	return progHandle;

}
