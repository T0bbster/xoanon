module graphics.hardware.Texture;

import math.Color;
import base.GL3types;
import graphics.hardware.CompareFunction;
import graphics.hardware.CompareMode;
import graphics.hardware.TextureFilter;
import graphics.hardware.TextureTarget;
import base.GL3functions;


enum ImageDataType
{
	Ubyte	= GL_UNSIGNED_BYTE,
	Byte 	= GL_BYTE,
	Ushort	= GL_UNSIGNED_SHORT,
	Short	= GL_SHORT,
	Uint	= GL_UNSIGNED_INT,
	Int		= GL_INT,
	Half	= GL_HALF_FLOAT,
	Float	= GL_FLOAT
	
	//TODO complete!
}

enum CompressedTextureInternalFormat : GLenum
{
	R 				= GL_COMPRESSED_RED,
	RG 				= GL_COMPRESSED_RG,
	RGB 			= GL_COMPRESSED_RGB,
	RGBA 			= GL_COMPRESSED_RGBA,
	SRGB			= GL_COMPRESSED_SRGB,
	SRGBA			= GL_COMPRESSED_SRGB_ALPHA,
	R_RGTC1			= GL_COMPRESSED_RED_RGTC1,
	RG_RGTC2		= GL_COMPRESSED_RG_RGTC2,
	SignedR_RGTC1	= GL_COMPRESSED_SIGNED_RED_RGTC1,
	SignedRG_RGTC2	= GL_COMPRESSED_SIGNED_RG_RGTC2
}

enum TextureInternalFormat : GLenum
{
	R 					= GL_RED,
	RG 					= GL_RG,
	RGB 				= GL_RGB,
	RGBA 				= GL_RGBA,
	
	R8					= GL_R8,
	R8i					= GL_R8I,
	R8ui				= GL_R8UI,
	R8snorm				= GL_R8_SNORM,
	R16					= GL_R16,
	R16f				= GL_R16F,
	R16i				= GL_R16I,
	R16ui				= GL_R16UI,
	R16snorm			= GL_R16_SNORM,
	R32f				= GL_R32F,
	R32i				= GL_R32I,
	R32ui				= GL_R32UI,
	RG8					= GL_RG8,
	RG8i				= GL_RG8I,
	RG8ui				= GL_RG8UI,
	RG8snorm			= GL_RG8_SNORM,
	RG16				= GL_RG16,
	RG16f				= GL_RG16F,
	RG16i				= GL_RG16I,
	RG16ui				= GL_RG16UI,
	RG16snorm			= GL_RG16_SNORM,
	RG32f				= GL_RG32F,
	RG32i				= GL_RG32I,
	RG32ui				= GL_RG32UI,
	RGB4				= GL_RGB4,
	RGB5				= GL_RGB5,
	RGB8				= GL_RGB8,
	RGB8snorm			= GL_RGB8_SNORM,
	RGB10				= GL_RGB10,
	RGB12				= GL_RGB12,
	RGB16				= GL_RGB16,
	RGB16snorm			= GL_RGB16_SNORM,
	SRGB8				= GL_SRGB8,
	RGB16f				= GL_RGB16F,
	RGB32f				= GL_RGB32F,
	R11fG11fB10f		= GL_R11F_G11F_B10F,
	RGB9_E5				= GL_RGB9_E5,
	RGB8i				= GL_RGB8I,
	RGB8ui				= GL_RGB8UI,
	RGB16i				= GL_RGB16I,
	RGB16ui				= GL_RGB16UI,
	RGB32i				= GL_RGB32I,
	RGB32ui				= GL_RGB32UI,
	RGBA2				= GL_RGBA2,
	RGBA4				= GL_RGBA4,
	RGB5Alpha1			= GL_RGB5_A1,
	RGBA8				= GL_RGBA8,
	RGBA8snorm			= GL_RGBA8_SNORM,
	RGB10Alpha2			= GL_RGB10_A2,
	RGBA12				= GL_RGBA12,
	RGBA16				= GL_RGBA16,
	RGBA16snorm			= GL_RGBA16_SNORM,
	SRGB8Alpha8			= GL_SRGB8_ALPHA8,
	RGBA16f				= GL_RGBA16F,
	RGBA32f				= GL_RGBA32F,
	RGBA8i				= GL_RGBA8I,
	RGBA8ui				= GL_RGBA8UI,
	RGBA16i				= GL_RGBA16I,
	RGBA16ui			= GL_RGBA16UI,
	RGBA32i				= GL_RGBA32I,
	RGBA32ui			= GL_RGBA32UI,
}

enum ImageFormat
{
	Red			= GL_RED,
	Green		= GL_GREEN,
	Blue		= GL_BLUE,
	RG			= GL_RG,
	RGB			= GL_RGB,
	RGBA		= GL_RGBA,
	BGR			= GL_BGR,
	BGRA		= GL_BGRA,
	
	RedInteger		= GL_RED_INTEGER,
	GreenInteger	= GL_GREEN_INTEGER,
	BlueInteger		= GL_BLUE_INTEGER,
	RGInteger		= GL_RG_INTEGER,
	RGBInteger		= GL_RGB_INTEGER,
	RGBAInteger		= GL_RGBA_INTEGER,
	BGRInteger		= GL_BGR_INTEGER,
	BGRAInteger		= GL_BGRA_INTEGER
}

abstract class Texture
{
	protected uint object;
	protected TextureTarget target;
	protected bool bound = false;
	
	public this(TextureTarget target)
	{
		glGenTextures(1, &this.object);
		this.target = target;
	}
	
	~this()
	{
		glDeleteTextures(1, &this.object);
	}
	
	public final void Bind()
	{
		glBindTexture(this.target, this.object);
		this.bound = true;
	}
	
	public final void Unbind()
	{
		glBindTexture(this.target, 0);
		this.bound = false;
	}
}

abstract class TextureInit : Texture
{
	protected bool initialized = false;
	
	public this(TextureTarget target)
	{
		super(target);
	}
}

abstract class TextureData : TextureInit 
{
	protected bool compressed = false;
	
	public this(TextureTarget target)
	{
		super(target);
		borderColor = Colorf(0,0,0,0);
	}
	
	private float minLevelOfDetail = -1000;
	public void MinLevelOfDetail(float value)
	in
	{
		assert(this.bound);
	}
	body
	{
		glTexParameterf(this.target, GL_TEXTURE_MIN_LOD, value);
		this.minLevelOfDetail = value;
	}
	public float MinLevelOfDetail()
	{
		return this.minLevelOfDetail;
	}
	
	private float maxLevelOfDetail = 1000;
	public void MaxLevelOfDetail(float value)
	in
	{
		assert(this.bound);
	}
	body
	{
		glTexParameterf(this.target, GL_TEXTURE_MAX_LOD, value);
		this.maxLevelOfDetail = value;
	}
	public float MaxLevelOfDetail()
	{
		return this.maxLevelOfDetail;
	}
	
	private bool border = false;
	public bool Border()
	{
		return this.border;
	}
	
	private Colorf borderColor;
	public void BorderColor(Colorf value)
	in
	{
		assert(this.bound);
	}
	body
	{
		glTexParameterfv(this.target, GL_TEXTURE_BORDER_COLOR, value.ToArray().ptr);
		this.borderColor = value;
	}
	public Colorf BorderColor()
	in
	{
		assert(this.bound);
	}
	body
	{
		return this.borderColor;
	}
	
	private uint minMipmapLevel = 0;
	public void MinMipmapLevel(uint value)
	in
	{
		assert(this.bound);
	}
	body
	{
		glTexParameteri(this.target, GL_TEXTURE_BASE_LEVEL, value);
		this.minMipmapLevel = value;
	}
	public uint MinMipmapLevel()
	{
		return this.minMipmapLevel;
	}
	
	private uint maxMipmapLevel = 1000;
	public void MaxMipmapLevel(uint value)
	in
	{
		assert(this.bound);
	}
	body
	{
		glTexParameteri(this.target, GL_TEXTURE_MAX_LEVEL, value);
		this.maxMipmapLevel = value;
	}
	public uint MaxMipmapLevel()
	{
		return this.maxMipmapLevel;
	}
	
	private float levelOfDetailBias = 1000;
	public void LevelOfDetailBias(float value)
	in
	{
		assert(this.bound);
	}
	body
	{
		glTexParameterf(this.target, GL_TEXTURE_LOD_BIAS, value);
		this.levelOfDetailBias = value;
	}
	public float LevelOfDetailBias()
	{
		return this.levelOfDetailBias;
	}
	
	private TextureFilter textureFilter;
	public void Filter(TextureFilter textureFilter)
	{
		glTexParameteri(this.target, GL_TEXTURE_MIN_FILTER, textureFilter.Minification);
		glTexParameteri(this.target, GL_TEXTURE_MAG_FILTER, textureFilter.Magnification);
		this.textureFilter = textureFilter;
	}
	public TextureFilter Filter()
	{
		return this.textureFilter;
	}

	private CompareFunction compareFunc;
	public void CompareFunc(CompareFunction func)
	in
	{
		assert(this.bound);
	}
	body
	{
		glTexParameteri(this.target, GL_TEXTURE_COMPARE_FUNC, func);
		this.compareFunc = func;
	}
	public CompareFunction CompareFunc()
	{
		return this.compareFunc;
	}
	
	
	private TextureCompareMode mode;
	public void CompareMode(TextureCompareMode mode)
	in
	{
		assert(this.bound);
	}
	body
	{
		glTexParameteri(this.target, GL_TEXTURE_COMPARE_MODE, mode);
		this.mode = mode;
	}
  	public TextureCompareMode CompareMode()
  	{
  		return this.mode;
  	}
  	
	public void GenerateMipmap()
	in
	{
		assert(this.bound);
	}
	body
	{
		glGenerateMipmap(this.target);
	}
}