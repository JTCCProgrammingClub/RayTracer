#include "programs.h"
#include "shader.h"
#include <iostream>

#define GLM_SWIZZLE
#include <glm/glm.hpp> 
#include <glm/gtc/matrix_transform.hpp> 
#include <glm/gtc/type_ptr.hpp> 

struct camData{
	glm::vec4 camPos = glm::vec4(5.0f, 10.0, 9.0f, 1.0f);
	glm::mat4 view = glm::lookAt(camPos.xyz(),
		glm::vec3(0.0f, 0.0f, 0.0f), glm::vec3(0.0f, 1.0f, 0.0f)); //Cam is 1.63 units in the air, 10 units away from origin, looking at the origin
		glm::mat4 proj = glm::perspective( glm::radians(45.0f), 1.0f/1, 0.1f, 10.0f); //May nned to fix aspect ratio

} camData;


GLuint genScreen(){
	GLuint texHandle;
	glGenTextures(1, &texHandle);

	glActiveTexture(GL_TEXTURE0);
	glBindTexture(GL_TEXTURE_2D, texHandle);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA32F, COMP_SIZE, COMP_SIZE, 0, GL_RGBA, GL_FLOAT, NULL);


	// Because we're also using this tex as an image (in order to write to it),
	// we bind it to an image unit as well
	glBindImageTexture(0, texHandle, 0, GL_FALSE, 0, GL_WRITE_ONLY, GL_RGBA32F);
	return texHandle;
}

GLuint genRayTracerProg(){
	for(int i=0; i<4;i++){
		for(int j=0; j<4;j++){
			std::cout << camData.view[i][j] << std::endl;
			std::cout << camData.proj[i][j] << std::endl;

		}
	}
	
	GLuint progHandle = glCreateProgram();
	Shader compShader("shaders/comp.glsl", progHandle, GL_COMPUTE_SHADER);

	// Initialize program
	glUseProgram(progHandle);


	glUniform1i(glGetUniformLocation(progHandle, "destTex"), 0);

	GLuint camDataBindingPoint = 1;
	GLuint camDataBuffer;
	GLuint camIndex = glGetUniformBlockIndex(progHandle, "camData");
	glUniformBlockBinding(progHandle, camIndex, camDataBindingPoint);

	glGenBuffers(1, &camDataBuffer);
	glBindBufferBase(GL_UNIFORM_BUFFER, camDataBindingPoint, camDataBuffer);
	glBindBuffer(GL_UNIFORM_BUFFER, camDataBuffer);

	glBufferData(GL_UNIFORM_BUFFER, sizeof(camData), &camData, GL_DYNAMIC_DRAW);



	return progHandle;

}

