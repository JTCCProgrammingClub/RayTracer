#include "programs.h"
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
	GLuint cs = glCreateShader(GL_COMPUTE_SHADER);

	const char *csSrc[] = {
		"#version 430\n",
		"uniform float roll;\
		layout(rgba32f, binding = 0) uniform image2D destTex;\
		 layout (local_size_x = 1, local_size_y = 1) in;\
		 void main() {\
			 ivec2 storePos = ivec2(gl_GlobalInvocationID.xy);\
			 imageStore(destTex, storePos, vec4(1.0, 0.0, 0.0, 1.0));\
		 }"
	};

	glShaderSource(cs, 2, csSrc, NULL);
	glCompileShader(cs);

	glAttachShader(progHandle, cs);
	glLinkProgram(progHandle);


	int rvalue;
    glGetProgramiv(progHandle, GL_LINK_STATUS, &rvalue);
    if (!rvalue) {
        fprintf(stderr, "Error in linking compute shader program\n");
        GLchar log[10240];
        GLsizei length;
        glGetProgramInfoLog(progHandle, 10239, &length, log);
        fprintf(stderr, "Linker log:\n%s\n", log);
		std::exit(41);
    }   


	glUseProgram(progHandle);
	glUniform1i(glGetUniformLocation(progHandle, "destTex"), 0);

	return progHandle;

}
