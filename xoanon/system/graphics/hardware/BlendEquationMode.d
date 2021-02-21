module xoanon.graphics.hardware.BlendEquationMode;

import base.GL3types;

enum BlendEquationMode : GLenum
{
	Add				= GL_FUNC_ADD,
	Subtract		= GL_FUNC_SUBTRACT,
	ReverseSubtract	= GL_FUNC_REVERSE_SUBTRACT,
	Min				= GL_MIN,
	Max				= GL_MAX
}
