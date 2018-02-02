
#include <iostream>
#include "programs.h"

void framebuffer_size_callback(GLFWwindow* window, int width, int height);
void processInput(GLFWwindow *window);

void useRayTracerProg();
void useRenderProg();

const unsigned int SCR_WIDTH = WIN_WIDTH;
const unsigned int SCR_HEIGHT = WIN_HEIGHT;

//Our programs
GLuint renderProg;
GLuint rayTracerProg;

GLuint texHandle  ;

int main()
{

    glfwInit();
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 4);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);


    // glfw window creation
    // --------------------
    GLFWwindow* window = glfwCreateWindow(SCR_WIDTH, SCR_HEIGHT, "LearnOpenGL", NULL, NULL);
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

	texHandle  = genTexture();

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
	glUseProgram(rayTracerProg);

	glUniform1f(glGetUniformLocation(rayTracerProg, "roll"), (float)512*0.01f);
	glDispatchCompute(512/16, 512/16, 1); // 512^2 threads in blocks of 16^2
}

void useRenderProg(){
	glUseProgram(renderProg);

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

