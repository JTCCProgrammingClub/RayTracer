#version 430,
uniform float roll;

layout(rgba32f, binding = 0) uniform image2D destTex;
layout (local_size_x = 1, local_size_y = 1) in;

void main() {
	ivec2 storePos = ivec2(gl_GlobalInvocationID.xy);
	imageStore(destTex, storePos, vec4(1.0, 0.0, 0.0, 1.0));
}
