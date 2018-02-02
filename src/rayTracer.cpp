#include "programs.h"

GLuint tex;
GLuint genRayTracerProg(){
	GLuint progHandle = glCreateProgram();
	GLuint cs = glCreateShader(GL_COMPUTE_SHADER);

	//
	//
	// In order to write to a texture, we have to introduce it as image2D.
	// local_size_x/y/z layout variables define the work group size.
	// gl_GlobalInvocationID is a uvec3 variable giving the global ID of the thread,
	// gl_LocalInvocationID is the local index within the work group, and
	// gl_WorkGroupID is the work group's index
	const char *csSrc[] = {
		"#version 430\n",
		"uniform float roll;\
		 uniform image2D destTex;\
		 layout (local_size_x = 16, local_size_y = 16) in;\
		 void main() {\
			 ivec2 storePos = ivec2(gl_GlobalInvocationID.xy);\
			 float localCoef = length(vec2(ivec2(gl_LocalInvocationID.xy)-8)/8.0);\
			 float globalCoef = sin(float(gl_WorkGroupID.x+gl_WorkGroupID.y)*0.1 + roll)*0.5;\
			 imageStore(destTex, storePos, vec4(1.0-globalCoef*localCoef, 0.0, 0.0, 0.0));\
		 }"
	};

	glShaderSource(cs, 2, csSrc, NULL);
	glCompileShader(cs);

	glAttachShader(progHandle, cs);
	glLinkProgram(progHandle);

	glUseProgram(progHandle);
	glUniform1i(glGetUniformLocation(progHandle, "destTex"), 0);

	return progHandle;

}

GLuint genTexture(){
	//Texture our rayTracer program will draw to and our render program
	//will read from
	glGenTextures(1, &tex);
	glActiveTexture(GL_TEXTURE0);
	glBindTexture(GL_TEXTURE_2D, tex);
	/*
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	*/
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA32F, texWidth, textHeight,
			0, GL_RGBA, GL_FLOAT, NULL);
	glBindImageTexture(0, tex, 0, GL_FALSE, 0, GL_WRITE_ONLY, GL_RGBA32F);
	return tex;
}
