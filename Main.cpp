#include <glad/glad.h>
#include <GLFW/glfw3.h>

#include "Shader.h"
#include "ErrorLogger.h"

#include <iostream>

int main()
{

	GLFWwindow* window;

	// init GLFW
	if (!glfwInit())
		return -1;

	// create window
	window = glfwCreateWindow(800, 600, "Raytracer", nullptr, nullptr);
	if (!window)
	{
		std::cout << "Failed to create window" << std::endl;
		glfwTerminate();
		return -1;
	}

	glfwMakeContextCurrent(window);

	glfwSwapInterval(1);

	if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress))
	{
		std::cout << "Failed to initialize GLAD" << std::endl;
		return -1;
	}

	std::cout << glGetString(GL_VERSION) << std::endl;

	Shader shaderSource("res/shaders/vertexShader.vs.glsl", "res/shaders/fragmentShader.fs.glsl");

	float vertices[] = {
		-0.5f, -0.5f, 0.0f,
		 0.5f, -0.5f, 0.0f, 
		 0.0f,  0.5f, 0.0f  
	};

	GLuint VBO;
	GLuint VAO;

	GLCall(glGenVertexArrays(1, &VAO));
	GLCall(glGenBuffers(1, &VBO));
	GLCall(glBindVertexArray(VAO));

	GLCall(glBindBuffer(GL_ARRAY_BUFFER, VBO));
	GLCall(glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW));

	GLCall(glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void*)0));
	GLCall(glEnableVertexAttribArray(0));

	GLCall(glBindBuffer(GL_ARRAY_BUFFER, 0));

	GLCall(glBindVertexArray(0));

	// render loop
	while (!glfwWindowShouldClose(window))
	{

		shaderSource.UseProgram();

		/* Render here */
		GLCall(glClearColor(0.2f, 0.3f, 0.3f, 1.0f));
		GLCall(glClear(GL_COLOR_BUFFER_BIT));
		
		// Use the program object we created earlier for rendering    
		GLCall(glUseProgram(shaderSource.program));
		GLCall(glBindVertexArray(VAO));
		GLCall(glDrawArrays(GL_TRIANGLES, 0, 3));

		/* Swap front and back buffers */
		glfwSwapBuffers(window);

		/* Poll for and process events */
		glfwPollEvents();
	}

	GLCall(glDeleteProgram(shaderSource.program));

	glfwTerminate();

	return 0;
}
