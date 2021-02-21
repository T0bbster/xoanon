module graphics.hardware.TexImage2D;

import content.Image;
import tango.io.Stdout;
import tango.stdc.stringz;
import derelict.devil.ilutfuncs;
import graphics.hardware.TextureFilter;
import graphics.hardware.TextureTarget;
import base.GL3functions;
import base.GL3types;
import graphics.hardware.WrappingMode;
import graphics.hardware.Texture;

package class TexImage2D : TextureData
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
	
	public void Initialize(uint width, uint height, void[] data, ImageDataType type, ImageFormat imageFormat, TextureInternalFormat internalFormat, uint mipmapLevel = 0, bool border = false)
  	in
	{
		assert(this.bound);
	}
	body
  	{
  		glTexImage2D(this.target, mipmapLevel, internalFormat, width, height, border, imageFormat, type, data.ptr);
  		this.initialized = true;
  	}
	
	public void SetData(uint width, uint height, void[] data, ImageDataType type, ImageFormat format, uint mipmapLevel = 0, uint xOffset = 0, uint yOffset = 0)
	in
	{
		assert(this.bound);
		assert(this.initialized);
		assert(!this.compressed);
	}
	body
	{
		glTexSubImage2D(this.target, mipmapLevel, xOffset, yOffset, width, height, format, type, data.ptr);
	}
	
	public void InitializeCompressed(uint width, uint height, void[] data, CompressedTextureInternalFormat internalFormat, uint mipmapLevel = 0, bool border = false)
  	in
	{
		assert(this.bound);
	}
	body
  	{
  		glCompressedTexImage2D(this.target, mipmapLevel, internalFormat, width, height, border, data.length * data[0].sizeof, data.ptr);
  		this.compressed = true;
  	}
	
	public void SetCompressedData(uint width, uint height, void[] data, CompressedTextureInternalFormat format, uint mipmapLevel = 0, uint xOffset = 0, uint yOffset = 0)
	in
	{
		assert(this.bound);
		assert(!this.initialized);
		assert(this.compressed);
	}
	body
	{
		glCompressedTexSubImage2D(this.target, mipmapLevel, xOffset, yOffset, width, height, format, data.length * data[0].sizeof, data.ptr);
	}
	
	public void InitializeFromFramebuffer(uint x, uint y, uint width, uint height, TextureInternalFormat internalFormat, uint mipmapLevel = 0, uint border = 0)
  	in
	{
		assert(this.bound);
	}
	body
  	{
		glCopyTexImage2D(this.target, mipmapLevel, internalFormat, x, y, width, height, border);
		this.initialized = true;
  	}
	
	public void SetFromFramebuffer(uint x, uint y, uint width, uint height, uint mipmapLevel = 0, uint xOffset = 0, uint yOffset = 0)
	in
	{
		assert(this.bound);
		assert(this.initialized);
		assert(!this.compressed);
	}
	body
  	{
		glCopyTexSubImage2D(this.target, mipmapLevel, xOffset, yOffset, x, y, width, height);
  	}
}

class Texture2D : TexImage2D
{
	this()
	{
		super(TextureTarget.Texture2D);
	}
	
	static Texture2D Load(char[] fileLocation)
	{
		auto image = new Image(fileLocation);
		
		Texture2D res = new Texture2D();
		res.Bind();
		res.Filter(TextureFilter(MagFilterMode.Linear, MinFilterMode.Linear));
		Stdout(image.Width()).newline;
		Stdout(image.Height()).newline;
		Stdout(image.Data.length).newline;
		Stdout("format: ")(image.Format).newline;
		
		//res.Initialize(image.Width, image.Height, image.Data, cast(ImageDataType) image.BytesPerPixel, cast(ImageFormat) image.Format, TextureInternalFormat.RGBA8);
		res.Initialize(image.Width, image.Height, image.Data, ImageDataType.Ubyte, cast(ImageFormat) image.Format, TextureInternalFormat.RGBA8);
		Stdout("Initialized").newline;
		
		//TODO
		Stdout("tex.Object: ")(res.object).newline;
		glActiveTexture(GL_TEXTURE0);
		
		delete image;
		
		return res;
	}
}

class Texture1DArray : TexImage2D
{
	this()
	{
		super(TextureTarget.Texture1DArray);
	}
}

class TextureRectangle : TexImage2D
{
	this()
	{
		super(TextureTarget.TextureRectangle);
	}
	
	public override void InitializeCompressed(uint width, uint height, void[] data,
			CompressedTextureInternalFormat internalFormat, uint mipmapLevel,
			bool border)
	{
		throw new Exception("Not supported!");
	}
	
	public override void SetCompressedData(uint width, uint height, void[] data,
			CompressedTextureInternalFormat format, uint mipmapLevel,
			uint xOffset, uint yOffset)
	{
		throw new Exception("Not supported!");
	}
}