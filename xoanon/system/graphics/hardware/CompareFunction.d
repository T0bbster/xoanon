module graphics.hardware.CompareFunction;

import base.GL3types;

enum CompareFunction : GLenum
{
	Less 			= GL_LESS,
	LessEqual 		= GL_LEQUAL,
	Equal 			= GL_EQUAL,
	GreaterEqual 	= GL_GEQUAL,
	Greater 		= GL_GREATER,
	NotEqual 		= GL_NOTEQUAL,
	Always 			= GL_ALWAYS,
	Never 			= GL_NEVER
}
