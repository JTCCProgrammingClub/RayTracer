#version 430

uniform sampler2D srcTex;
in vec2 texCoord;
out vec4 color;

void main() {
	float c = texture(srcTex, texCoord).x;
	color = texture(srcTex, texCoord);
}
