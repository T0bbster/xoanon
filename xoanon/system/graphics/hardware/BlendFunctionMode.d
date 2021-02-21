module xoanon.graphics.hardware.BlendFunctionMode;

import base.GL3types;

enum BlendFunctionMode
{
	Zero						= GL_ZERO,
	One							= GL_ONE,
	SourceColor					= GL_SRC_COLOR,
	OneMinusSourceColor			= GL_ONE_MINUS_SRC_COLOR,
	DestinationColor			= GL_DST_COLOR,
	OneMinusDestinationColor	= GL_ONE_MINUS_DST_COLOR,
	SourceAlpha					= GL_SRC_ALPHA,
	OneMinusSourceAlpha			= GL_ONE_MINUS_SRC_ALPHA,
	DestinationAlpha			= GL_DST_ALPHA,
	OneMinusDestinationAlpha	= GL_ONE_MINUS_DST_ALPHA,
	BlendColor					= GL_CONSTANT_COLOR,
	OneMinusBlendColor			= GL_ONE_MINUS_CONSTANT_COLOR,
	BlendAlpha					= GL_CONSTANT_ALPHA,
	OneMinusBlendAlpha			= GL_ONE_MINUS_CONSTANT_ALPHA,
	SourceAlphaSaturate			= GL_SRC_ALPHA_SATURATE
}
