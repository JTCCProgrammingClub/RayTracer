#include "programs.h"



//GLuint genRenderProg(GLuint texHandle){
GLuint genRenderProg(){
	GLuint progHandle = glCreateProgram();
	GLuint vp = glCreateShader(GL_VERTEX_SHADER);
	GLuint fp = glCreateShader(GL_FRAGMENT_SHADER);

	const char *vpSrc[] = {
		"#version 430\n",
		"in vec2 pos;\
		 out vec2 texCoord;\
		 void main() {\
			 texCoord = pos*0.5f + 0.5f;\
			 gl_Position = vec4(pos.x, pos.y, 0.0, 1.0);\
		 }"
	};

	const char *fpSrc[] = {
		"#version 430\n",
		"uniform sampler2D srcTex;\
		 in vec2 texCoord;\
		 out vec4 color;\
		 void main() {\
			 float c = texture(srcTex, texCoord).x;\
			 color = vec4(c, 1.0, 1.0, 1.0);\
		 }"
	};

	glShaderSource(vp, 2, vpSrc, NULL);
	glShaderSource(fp, 2, fpSrc, NULL);

	glCompileShader(vp);
	glCompileShader(fp);

	glAttachShader(progHandle, vp);
	glAttachShader(progHandle, fp);

	glBindFragDataLocation(progHandle, 0,  "color");
	glLinkProgram(progHandle);

	glUseProgram(progHandle);

	//associate our texture with srcTex input var in the shader
	glUniform1i(glGetUniformLocation(progHandle, "srcTex"),  0);

	GLuint vertArray;
	glGenVertexArrays(1, &vertArray);
	glBindVertexArray(vertArray);

	GLuint posBuf;
	glGenBuffers(1, &posBuf);
	glBindBuffer(GL_ARRAY_BUFFER, posBuf);

	float data[] = {
		-1.0f, -1.0f,
		-1.0f, 1.0f,
		1.0f, -1.0f,
		1.0f, 1.0f
	};

	glBufferData(GL_ARRAY_BUFFER, sizeof(float)*8, data, GL_STREAM_DRAW);
	GLint posPtr  = glGetAttribLocation(progHandle, "pos");
	glVertexAttribPointer(posPtr, 2, GL_FLOAT, GL_FALSE, 0, 0);
	glEnableVertexAttribArray(posPtr);

	return progHandle;

}

/*
void initRenderProg(){
	glUseProgram(progHandle);

}
