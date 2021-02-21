module graphics.hardware.TextureTarget;

import base.GL3types;

enum TextureTarget
{
	Texture1D 					= GL_TEXTURE_1D,
	Texture1DArray 				= GL_TEXTURE_1D_ARRAY,
	Texture2D 					= GL_TEXTURE_2D,
	Texture2DArray 				= GL_TEXTURE_2D_ARRAY,
	Texture3D 					= GL_TEXTURE_3D,
	TextureRectangle 			= GL_TEXTURE_RECTANGLE,
	BufferTexture 				= GL_TEXTURE_BUFFER,
	Cubemap 					= GL_TEXTURE_CUBE_MAP,
	Texture2DMultisample 		= GL_TEXTURE_2D_MULTISAMPLE,
	Texture2DMultisampleArray 	= GL_TEXTURE_2D_MULTISAMPLE_ARRAY
}
