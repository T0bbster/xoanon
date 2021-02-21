module graphics.hardware.TextureFilter;

import base.GL3types;

enum MagFilterMode : GLenum
{
	Nearest 				= GL_NEAREST,
	Linear 					= GL_LINEAR,
	NearestMipmapNearest 	= GL_NEAREST_MIPMAP_NEAREST,
	NearestMipmapLinear 	= GL_NEAREST_MIPMAP_LINEAR,
	LinearMipmapNearest		= GL_LINEAR_MIPMAP_NEAREST,
	LinearMipmapLinear		= GL_LINEAR_MIPMAP_LINEAR
}

enum MinFilterMode : GLenum
{
	Nearest = GL_NEAREST,
	Linear 	= GL_LINEAR,
}

struct TextureFilter 
{
	public MagFilterMode Magnification;
	public MinFilterMode Minification;
	
	public static TextureFilter opCall(MagFilterMode Magnification, MinFilterMode Minification)
	{
		TextureFilter res;
		res.Magnification = Magnification;
		res.Minification = Minification;
		return res;
	}
}
