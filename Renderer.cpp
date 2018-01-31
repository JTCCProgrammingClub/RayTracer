#include <glad/glad.h>
#include <GLFW/glfw3.h>

#include "Headers\Renderrer.h"

#include <iostream>
#include <fstream>
#include <string>
#include <sstream>

int main()
{

	GLFWwindow* window;

	// init GLFW
	if (!glfwInit())
		return -1;

	// create window
	window = glfwCreateWindow(800, 600, "OpenGL Window", NULL, NULL);
	if (!window)
	{
		std::cout << "Failed to create window" << std::endl;
		glfwTerminate();
		return -1;
	}

	glfwMakeContextCurrent(window);

	if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress))
	{
		std::cout << "Failed to initialize GLAD" << std::endl;
		return -1;
	}

	ShaderProgramSource source = parseShader("res/shaders/basic.shader");

	// render loop
	while (!glfwWindowShouldClose(window))
	{
		/* Render here */

		/* Swap front and back buffers */
		glfwSwapBuffers(window);

		/* Poll for and process events */
		glfwPollEvents();
	}
	glfwTerminate();
	return 0;
}
