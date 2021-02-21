//in
attribute vec4 Position;
attribute vec4 Normal;

uniform vec4 Color;
uniform mat4 World;
uniform mat4 View;
uniform mat4 Projection;

//out
varying vec4 ColorOut;
varying vec4 NormalOut;

void main(void)
{
	ColorOut = Color;
	NormalOut = Normal;
	gl_Position = Projection * View * World * Position;
}