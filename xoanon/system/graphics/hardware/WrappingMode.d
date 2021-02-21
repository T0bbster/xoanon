module xoanon.graphics.hardware.WrappingMode;

import base.GL3types;

enum WrappingMode : GLenum
{
	ClampToEdge 	= GL_CLAMP_TO_EDGE,
	ClamToBorder	= GL_CLAMP_TO_BORDER,
	Repeat			= GL_REPEAT,
	MirroredRepeat	= GL_MIRRORED_REPEAT
}
