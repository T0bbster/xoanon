module graphics.hardware.TexImage3D;

import graphics.hardware.TextureTarget;
import graphics.hardware.WrappingMode;
import base.GL3functions;
import base.GL3types;
import graphics.hardware.Texture;

class TexImage3D : TextureData
{
	public this(TextureTarget target)
	{
		super(target);
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
	
  	private WrappingMode wrapR;
	public void WrapR(WrappingMode value)
	in
	{
		assert(this.bound);
	}
	body
	{
		glTexParameteri(this.target, GL_TEXTURE_WRAP_R, value);
		this.wrapR = value;
	}
  	public WrappingMode WrapR()
  	{
  		return this.wrapR;
  	}
  	
	public void Initialize(uint width, uint height, uint depth, void[] data, ImageDataType type, ImageFormat imageFormat, TextureInternalFormat internalFormat, uint mipmapLevel = 0, bool border = false)
  	in
	{
		assert(this.bound);
	}
	body
  	{
  		glTexImage3D(this.target, mipmapLevel, internalFormat, width, height, depth, border, imageFormat, type, data.ptr);
  		this.initialized = true;
  	}
	
	public void SetData(uint width, uint height, uint depth, void[] data, ImageDataType type, ImageFormat format, uint mipmapLevel = 0, uint xOffset = 0, uint yOffset = 0, uint zOffset = 0)
	in
	{
		assert(this.bound);
		assert(this.initialized);
		assert(!this.compressed);
	}
	body
	{
		glTexSubImage3D(this.target, mipmapLevel, xOffset, yOffset, zOffset, width, height, depth, format, type, data.ptr);
	}
	
	public void InitializeCompressed(uint width, uint height, uint depth, void[] data, CompressedTextureInternalFormat internalFormat, uint mipmapLevel = 0, bool border = false)
  	in
	{
		assert(this.bound);
	}
	body
  	{
  		glCompressedTexImage3D(this.target, mipmapLevel, internalFormat, width, height, depth, border, data.length * data[0].sizeof, data.ptr);
  		this.compressed = true;
  	}
	
	public void SetCompressedData(uint width, uint height, uint depth, void[] data, CompressedTextureInternalFormat format, uint mipmapLevel = 0, uint xOffset = 0, uint yOffset = 0, uint zOffset = 0)
	in
	{
		assert(this.bound);
		assert(!this.initialized);
		assert(this.compressed);
	}
	body
	{
		glCompressedTexSubImage3D(this.target, mipmapLevel, xOffset, yOffset, zOffset, width, height, depth, format, data.length * data[0].sizeof, data.ptr);
	}
	
	public void SetFromFramebuffer(uint x, uint y, uint width, uint height, uint depth, uint mipmapLevel = 0, uint xOffset = 0, uint yOffset = 0, uint zOffset = 0)
	in
	{
		assert(this.bound);
		assert(this.initialized);
		assert(!this.compressed);
	}
	body
  	{
		glCopyTexSubImage3D(this.target, mipmapLevel, xOffset, yOffset, zOffset, x, y, width, height, depth);
  	}
}

class Texture3D : TexImage3D
{
	public this()
	{
		super(TextureTarget.Texture3D);
	}
}

class Texture2DArray : TexImage3D
{
	public this()
	{
		super(TextureTarget.Texture2DArray);
	}
}