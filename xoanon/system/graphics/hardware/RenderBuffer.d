module graphics.hardware.Renderbuffer;

import base.GL3types;
import base.GL3functions;

enum ColorRenderable : GLenum
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
	RGBA10				= GL_RGBA10,
	RGB10Alpha1			= GL_RGB10_A2,
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

enum DepthRenderable : GLenum
{
	Depth 				= GL_DEPTH_COMPONENT,
	Depth16 			= GL_DEPTH_COMPONENT16,
	Depth24				= GL_DEPTH_COMPONENT24,
	Depth32 			= GL_DEPTH_COMPONENT32,
	Depth32f			= GL_DEPTH_COMPONENT32F,
	/+
	Depth24Stencil8 	= GL_DEPTH24_STENCIL8,
	Depth32fStencil8	= GL_DEPTH32F_STENCIL8
	+/
}

enum StencilRenderable : GLenum
{
	Stencil 			= GL_STENCIL_INDEX,
	Stencil1			= GL_STENCIL_INDEX1,
	Stencil4			= GL_STENCIL_INDEX4,
	Stencil8			= GL_STENCIL_INDEX8,
	Stencil16			= GL_STENCIL_INDEX16,
	/+
	DepthStencil 		= GL_DEPTH_STENCIL,
	Depth24Stencil8 	= GL_DEPTH24_STENCIL8,
	Depth32fStencil8	= GL_DEPTH32F_STENCIL8
	+/
}

enum DepthStencilRenderable : GLenum
{
	DepthStencil 		= GL_DEPTH_STENCIL,
	Depth24Stencil8 	= GL_DEPTH24_STENCIL8,
	Depth32fStencil8	= GL_DEPTH32F_STENCIL8
}

enum AttachmentType : GLenum
{
	Color			= GL_COLOR_ATTACHMENT0,
	Depth			= GL_DEPTH_ATTACHMENT,
	Stencil			= GL_STENCIL_ATTACHMENT,
	DepthStencil	= GL_DEPTH_STENCIL_ATTACHMENT
}

public class Renderbuffer 
{
	package uint object;
	private int width, height;
	package AttachmentType type;
	
	private this(GLenum internalFormat, uint width, uint height, uint samples = 0)
	{
		glGenRenderbuffers(1, &this.object);
		Bind();
		if(samples != 0)
			glRenderbufferStorageMultisample(GL_RENDERBUFFER, samples, internalFormat, width, height);
		else
			glRenderbufferStorage(GL_RENDERBUFFER, internalFormat, width, height);
	}
	
	public this(ColorRenderable renderable, uint width, uint height, uint samples = 0)
	{
		this(renderable, width, height, samples);
		this.type = AttachmentType.Color;
	}
	
	public this(DepthRenderable renderable, uint width, uint height, uint samples = 0)
	{
		this(renderable, width, height, samples);
		this.type = AttachmentType.Depth;
	}
	
	public this(StencilRenderable renderable, uint width, uint height, uint samples = 0)
	{
		this(renderable, width, height, samples);
		this.type = AttachmentType.Stencil;
	}
	
	public this(DepthStencilRenderable renderable, uint width, uint height, uint samples = 0)
	{
		this(renderable, width, height, samples);
		this.type = AttachmentType.DepthStencil;
	}
	
	~this()
	{
		glDeleteRenderbuffers(1, &this.object);
	}
	
	public void Bind()
	{
		glBindRenderbuffer(GL_RENDERBUFFER, &this.object);
	}
	
	public void Unbind()
	{
		glBindRenderbuffer(GL_RENDERBUFFER, 0);
	}
}
