module xoanon.graphics.hardware.BufferTexture;

import xoanon.graphics.hardware.BufferObject;
import xoanon.graphics.hardware.TextureTarget;
import xoanon.base.GL3functions;
import xoanon.base.GL3types;
import xoanon.graphics.hardware.Texture;

enum BufferTextureFormat
{
	R8					= GL_R8,
	R8i					= GL_R8I,
	R8ui				= GL_R8UI,
	R16					= GL_R16,
	R16f				= GL_R16F,
	R16i				= GL_R16I,
	R16ui				= GL_R16UI,
	R32f				= GL_R32F,
	R32i				= GL_R32I,
	R32ui				= GL_R32UI,
	RG8					= GL_RG8,
	RG8i				= GL_RG8I,
	RG8ui				= GL_RG8UI,
	RG16				= GL_RG16,
	RG16f				= GL_RG16F,
	RG16i				= GL_RG16I,
	RG16ui				= GL_RG16UI,
	RG32f				= GL_RG32F,
	RG32i				= GL_RG32I,
	RGBA8				= GL_RGBA8,
	RGBA16				= GL_RGBA16,
	RGBA16f				= GL_RGBA16F,
	RGBA32f				= GL_RGBA32F,
	RGBA8i				= GL_RGBA8I,
	RGBA8ui				= GL_RGBA8UI,
	RGBA16i				= GL_RGBA16I,
	RGBA16ui			= GL_RGBA16UI,
	RGBA32i				= GL_RGBA32I,
	RGBA32ui			= GL_RGBA32UI,
}

class BufferTexture : Texture
{
	public this()
	{
		super(TextureTarget.BufferTexture);
	}
	
	public void SetData(TextureBuffer buffer, BufferTextureFormat format)
	{
		glTexBuffer(GL_TEXTURE_BUFFER, format, buffer.object);
	}
}
