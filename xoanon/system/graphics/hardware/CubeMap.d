module graphics.hardware.CubeMap;

import base.GL3functions;
import base.GL3types;
import graphics.hardware.WrappingMode;
import graphics.hardware.TexImage2D;
import graphics.hardware.TextureTarget;
import graphics.hardware.Texture;

class CubeMap : TextureData 
{
	public this()
	{
		super(TextureTarget.Cubemap);
	}
	
	private WrappingMode wrapS;
	public void WrapS(WrappingMode value)
	in
	{
		assert(this.bound);
	}
	body
	{
		glTexParameteri(this.target, GL_TEXTURE_WRAP_S, value);
		this.wrapS = value;
	}
  	public WrappingMode WrapS()
  	{
  		return this.wrapS;
  	}
  	
  	private WrappingMode wrapT;
	public void WrapT(WrappingMode value)
	in
	{
		assert(this.bound);
	}
	body
	{
		glTexParameteri(this.target, GL_TEXTURE_WRAP_T, value);
		this.wrapT = value;
	}
  	public WrappingMode WrapT()
  	{
  		return this.wrapT;
  	}
	
	public TexturePosX PositiveX;
	public TexturePosY PositiveY;
	public TexturePosZ PositiveZ;
	public TextureNegX NegativeX;
	public TextureNegY NegativeY;
	public TextureNegZ NegativeZ;
}

enum CubemapTarget
{
	CubemapPosX					= GL_TEXTURE_CUBE_MAP_POSITIVE_X,
	CubemapPosY					= GL_TEXTURE_CUBE_MAP_POSITIVE_Y,
	CubemapPosZ					= GL_TEXTURE_CUBE_MAP_POSITIVE_Z,
	CubemapNegX					= GL_TEXTURE_CUBE_MAP_NEGATIVE_X,
	CubemapNegY					= GL_TEXTURE_CUBE_MAP_NEGATIVE_Y,
	CubemapNegZ					= GL_TEXTURE_CUBE_MAP_NEGATIVE_Z,
}

class CubemapTexture
{
	private CubemapTarget target;
	private bool initialized = false;
	private bool compressed = false;
	
	public this(CubemapTarget target)
	{
		this.target = target;
	}
	
	public void Initialize(uint width, uint height, void[] data, ImageDataType type, ImageFormat imageFormat, TextureInternalFormat internalFormat, uint mipmapLevel = 0, bool border = false)
  	{
  		glTexImage2D(this.target, mipmapLevel, internalFormat, width, height, border, imageFormat, type, data.ptr);
  		this.initialized = true;
  	}
	
	public void SetData(uint width, uint height, void[] data, ImageDataType type, ImageFormat format, uint mipmapLevel = 0, uint xOffset = 0, uint yOffset = 0)
	in
	{
		assert(this.initialized);
		assert(!this.compressed);
	}
	body
	{
		glTexSubImage2D(this.target, mipmapLevel, xOffset, yOffset, width, height, format, type, data.ptr);
	}
	
	public void InitializeCompressed(uint width, uint height, void[] data, CompressedTextureInternalFormat internalFormat, uint mipmapLevel = 0, bool border = false)
  	{
  		glCompressedTexImage2D(this.target, mipmapLevel, internalFormat, width, height, border, data.length * data[0].sizeof, data.ptr);
  		this.compressed = true;
  	}
	
	public void SetCompressedData(uint width, uint height, void[] data, CompressedTextureInternalFormat format, uint mipmapLevel = 0, uint xOffset = 0, uint yOffset = 0)
	in
	{
		assert(!this.initialized);
		assert(this.compressed);
	}
	body
	{
		glCompressedTexSubImage2D(this.target, mipmapLevel, xOffset, yOffset, width, height, format, data.length * data[0].sizeof, data.ptr);
	}
	
	public void InitializeFromFramebuffer(uint x, uint y, uint width, uint height, TextureInternalFormat internalFormat, uint mipmapLevel = 0, uint border = 0)
  	{
		glCopyTexImage2D(this.target, mipmapLevel, internalFormat, x, y, width, height, border);
		this.initialized = true;
  	}
	
	public void SetFromFramebuffer(uint x, uint y, uint width, uint height, uint mipmapLevel = 0, uint xOffset = 0, uint yOffset = 0)
	in
	{
		assert(this.initialized);
		assert(!this.compressed);
	}
	body
  	{
		glCopyTexSubImage2D(this.target, mipmapLevel, xOffset, yOffset, x, y, width, height);
  	}
}

class TexturePosX : CubemapTexture
{
	public this()
	{
		super(CubemapTarget.CubemapPosX);
	}
}

class TexturePosY : CubemapTexture
{
	public this()
	{
		super(CubemapTarget.CubemapPosY);
	}
}

class TexturePosZ : CubemapTexture
{
	public this()
	{
		super(CubemapTarget.CubemapPosZ);
	}
}

class TextureNegX : CubemapTexture
{
	public this()
	{
		super(CubemapTarget.CubemapNegX);
	}
}

class TextureNegY : CubemapTexture
{
	public this()
	{
		super(CubemapTarget.CubemapNegY);
	}
}

class TextureNegZ : CubemapTexture
{
	public this()
	{
		super(CubemapTarget.CubemapNegZ);
	}
}