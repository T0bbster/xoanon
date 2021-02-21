module graphics.hardware.TexImage1D;

import graphics.hardware.TextureTarget;
import base.GL3functions;
import base.GL3types;
import graphics.hardware.WrappingMode;
import graphics.hardware.Texture;

package class TexImage1D : TextureData
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
  	

  	public void Initialize(uint width, void[] data, ImageDataType type, ImageFormat imageFormat, TextureInternalFormat internalFormat, uint mipmapLevel = 0, uint border = 0)
  	in
	{
		assert(this.bound);
	}
	body
  	{
  		glTexImage1D(this.target, mipmapLevel, internalFormat, width, border, imageFormat, type, data.ptr);
  		this.initialized = true;
  	}

	public void SetData(uint width, void[] data, ImageDataType type, ImageFormat format, uint mipmapLevel = 0, uint xOffset = 0)
	in
	{
		assert(this.bound);
		assert(this.initialized);
		assert(!this.compressed);
	}
	body
	{
		glTexSubImage1D(this.target, mipmapLevel, xOffset, width, format, type, data.ptr);
	}
	
	public void InitializeCompressed(uint width, void[] data, CompressedTextureInternalFormat internalFormat, uint mipmapLevel = 0, bool border = false)
  	in
	{
		assert(this.bound);
	}
	body
  	{
  		glCompressedTexImage1D(this.target, mipmapLevel, internalFormat, width, border, data.length * data[0].sizeof, data.ptr);
  		this.compressed = true;
  	}
	
	public void SetCompressedData(uint width, void[] data, CompressedTextureInternalFormat format, uint mipmapLevel = 0, uint xOffset = 0)
	in
	{
		assert(this.bound);
		assert(!this.initialized);
		assert(this.compressed);
	}
	body
	{
		glCompressedTexSubImage1D(this.target, mipmapLevel, xOffset, width, format, data.length * data[0].sizeof, data.ptr);
	}
	
	public void InitializeFromFramebuffer(uint x, uint y, uint width, TextureInternalFormat internalFormat, uint mipmapLevel = 0, uint border = 0)
  	in
	{
		assert(this.bound);
	}
	body
  	{
		glCopyTexImage1D(this.target, mipmapLevel, internalFormat, x, y, width, border);
		this.initialized = true;
  	}
	
	public void SetFromFramebuffer(uint x, uint y, uint width, uint mipmapLevel = 0, uint xOffset = 0)
	in
	{
		assert(this.bound);
		assert(this.initialized);
		assert(!this.compressed);
	}
	body
  	{
		glCopyTexSubImage1D(this.target, mipmapLevel, xOffset, x, y, width);
  	}

}

public class Texture1D : TexImage1D
{
	public this()
	{
		super(TextureTarget.Texture1D);
	}
}
