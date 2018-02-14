#include <iostream>
#include "programs.h"
#include <math.h>


void framebuffer_size_callback(GLFWwindow* window, int width, int height);
void processInput(GLFWwindow *window);

void useRayTracerProg();
void useRenderProg();

//Our programs
GLuint renderProg;
GLuint rayTracerProg;

//the screen (a texture) our compute shader will draw too,
//and our frag will read from
GLuint screen;

float i;
int main()
	
{
    glfwInit();
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 4);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);


    // glfw window creation
    // --------------------
    GLFWwindow* window = glfwCreateWindow(WIN_WIDTH, WIN_HEIGHT, "JTPCC", NULL, NULL);
    if (window == NULL)
    {
        std::cout << "Failed to create GLFW window" << std::endl;
        glfwTerminate();
        return -1;
    }
    glfwMakeContextCurrent(window);
    glfwSetFramebufferSizeCallback(window, framebuffer_size_callback);


    // glad: load all OpenGL function pointers
    // ---------------------------------------
    if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress))
    {
        std::cout << "Failed to initialize GLAD" << std::endl;
        return -1;
    }    

	//init our screen
	screen = genScreen();
	// init rayTracer prog
	rayTracerProg  = genRayTracerProg();	
	// init render prog
	renderProg  = genRenderProg();	

    while (!glfwWindowShouldClose(window))
    {
        processInput(window);
        //glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
        //glClear(GL_COLOR_BUFFER_BIT);
		useRayTracerProg();
		glMemoryBarrier(GL_SHADER_IMAGE_ACCESS_BARRIER_BIT);
		useRenderProg();

        // glfw: swap buffers and poll IO events (keys pressed/released, mouse moved etc.)
        // -------------------------------------------------------------------------------
        glfwSwapBuffers(window);
        glfwPollEvents();
    }

    glfwTerminate();
    return 0;
}

void useRayTracerProg(){
	i+=.01f;
	glUseProgram(rayTracerProg);

	glUniform1i(glGetUniformLocation(rayTracerProg, "roll"),i);
	glDispatchCompute(COMP_SIZE, COMP_SIZE, 1); // 
}

void useRenderProg(){
    glClear(GL_COLOR_BUFFER_BIT);
	glUseProgram(renderProg);

    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, screen);

	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

void processInput(GLFWwindow *window)
{
    if(glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS)
        glfwSetWindowShouldClose(window, true);
}

void framebuffer_size_callback(GLFWwindow* window, int width, int height)
{
    // make sure the viewport matches the new window dimensions; note that width and 
    // height will be significantly larger than specified on retina displays.
    glViewport(0, 0, width, height);
}

