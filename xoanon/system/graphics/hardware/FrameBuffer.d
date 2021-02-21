module graphics.hardware.Framebuffer;

import tango.util.container.HashMap;
import graphics.hardware.BlendEquationMode;
import graphics.hardware.BlendFunctionMode;
import graphics.hardware.CubeMap;
import graphics.hardware.RenderBuffer;
import graphics.hardware.Renderbuffer;
import graphics.hardware.TexImage1D;
import graphics.hardware.TexImage2D;
import graphics.hardware.TexImage3D;
import graphics.hardware.Texture;
import graphics.hardware.TextureMultisample;
import base.GL3types;
import base.GL3functions;

enum FramebufferTarget
{
	Draw = GL_DRAW_FRAMEBUFFER,
	Read = GL_READ_FRAMEBUFFER,
	DrawAndRead = GL_FRAMEBUFFER
}

public class ColorAttachment
{
	private uint index = GL_COLOR_ATTACHMENT0;
	
	public this(uint index)
	{
		this.index += index;
	}
	
	private class Blending
	{
		private BlendEquationMode blendEquationRGB;
		public BlendEquationMode BlendEquationRGB()
		{
			return this.blendEquationRGB;
		}
		
		private BlendEquationMode blendEquationAlpha;
		public BlendEquationMode BlendEquationAlpha()
		{
			return this.blendEquationAlpha;
		}
		
		private BlendFunctionMode blendFuncSourceRGB;
		public BlendFunctionMode BlendFuncSourceRGB()
		{
			return this.blendFuncSourceRGB;
		}
		
		private BlendFunctionMode blendFuncSourceAlpha;
		public BlendFunctionMode BlendFuncSourceAlpha()
		{
			return this.blendFuncSourceAlpha;
		}
		
		private BlendFunctionMode blendFuncDestRGB;
		public BlendFunctionMode BlendFuncDestRGB()
		{
			return this.blendFuncDestRGB;
		}

		private BlendFunctionMode blendFuncDestAlpha;
		public BlendFunctionMode BlendFuncDestAlpha()
		{
			return this.blendFuncDestAlpha;
		}

		public void Enable()
		{
			glEnablei(GL_BLEND, index);
		}
		
		public void Disable()
		{
			glDisablei(GL_BLEND, index);
		}

		public void SetEquation(BlendEquationMode mode)
		{
			glBlendEquationi(index, mode);
			this.blendEquationAlpha = mode;
			this.blendEquationRGB = mode;
		}

		public void SetEquation(BlendEquationMode modeRGB, BlendEquationMode modeAlpha)
		{
			glBlendEquationSeparatei(index, modeRGB, modeAlpha);
			this.blendEquationAlpha = modeAlpha;
			this.blendEquationRGB = modeRGB;
		}
		
		public void SetFunction(BlendFunctionMode source, BlendFunctionMode destination)
		{
			glBlendFunci(index, source, destination);
			this.blendFuncSourceAlpha = source;
			this.blendFuncSourceRGB = source;
			this.blendFuncDestAlpha = destination;
			this.blendFuncDestRGB = destination;
		}

		public void SetFunction(BlendFunctionMode sourceRGB, BlendFunctionMode sourceAlpha, BlendFunctionMode destinationRGB, BlendFunctionMode destinationAlpha)
		{
			glBlendFuncSeparatei(index, sourceRGB, destinationRGB, sourceAlpha, destinationAlpha);
			this.blendFuncSourceAlpha = sourceAlpha;
			this.blendFuncSourceRGB = sourceRGB;
			this.blendFuncDestAlpha = destinationAlpha;
			this.blendFuncDestRGB = destinationRGB;
		}
	}
	
	public Blending Blend;
	
	
}

public abstract class FramebufferObject
{
	protected uint object;
	protected FramebufferTarget target;
	private bool bound;
	
	private int colorAttachmentIndex = 0;
	private static int maxColorAttachments;
	//public HashMap!(int, ColorAttachment) ColorAttachments;
	
	static this()
	{
		glGetIntegerv(GL_MAX_DRAW_BUFFERS, &maxColorAttachments);
	}
	
	public this(FramebufferTarget target)
	{
		glGenFramebuffers(1, &this.object);
		this.ColorAttachments = new HashMap!(int, ColorAttachment);
		this.target = target;
	}
	
	~this()
	{
		glDeleteFramebuffers(1, &this.object);
	}
	
	public final void Bind()
	{
		glBindFramebuffer(this.target, this.object);
		this.bound = true;
	}
	
	public final void Unbind()
	{
		glBindFramebuffer(this.target, 0);
		this.bound = false;
	}
	
	public void AttachRenderBufffer(AttachmentType attachmentType, Renderbuffer renderBuffer)
	in
	{
		assert(this.bound);
		assert(attachmentType == renderBuffer.type);
		if(attachmentType == AttachmentType.Color)
			assert(this.colorAttachmentIndex < this.maxColorAttachments-1);
	}
	body
	{
		if(attachmentType == AttachmentType.Color)
		{
			this.ColorAttachments.add(colorAttachmentIndex, new ColorAttachment(colorAttachmentIndex));
			glFramebufferRenderbuffer(this.target, attachmentType + this.colorAttachmentIndex, GL_RENDERBUFFER, renderBuffer.object);
			this.colorAttachmentIndex++;
		}
		else
		{
			glFramebufferRenderbuffer(this.target, attachmentType, GL_RENDERBUFFER, renderBuffer.object);
		}
	}
	
	public void AttachTextureInit(AttachmentType attachmentType, TextureInit texture, uint mipmapLevel = 0)
	in
	{
		assert(this.bound);
		if(attachmentType == AttachmentType.Color)
			assert(this.colorAttachmentIndex < this.maxColorAttachments-1);
	}
	body
	{
		if(attachmentType == AttachmentType.Color)
		{
			this.ColorAttachments.add(colorAttachmentIndex, new ColorAttachment(colorAttachmentIndex));
			glFramebufferTexture(this.target, attachmentType + this.colorAttachmentIndex, GL_RENDERBUFFER, renderBuffer.object);
			this.colorAttachmentIndex++;
		}
		else
			glFramebufferTexture(this.target, attachmentType, texture.object, mipmapLevel);
	}
	
	public void AttachTexture(AttachmentType attachmentType, Texture1D texture, uint mipmapLevel = 0)
	in
	{
		assert(this.bound);
		if(attachmentType == AttachmentType.Color)
			assert(this.colorAttachmentIndex < this.maxColorAttachments-1);
	}
	body
	{
		if(attachmentType == AttachmentType.Color)
		{
			this.ColorAttachments.add(colorAttachmentIndex, new ColorAttachment(colorAttachmentIndex));
			glFramebufferTexture1D(this.target, attachmentType + this.colorAttachmentIndex, GL_RENDERBUFFER, renderBuffer.object);
			this.colorAttachmentIndex++;
		}
		else
			glFramebufferTexture1D(this.target, attachmentType, texture.target, texture.object, mipmapLevel);
	}
	
	public void AttachTexture(AttachmentType attachmentType, Texture2D texture, uint mipmapLevel = 0)
	in
	{
		assert(this.bound);
		if(attachmentType == AttachmentType.Color)
			assert(this.colorAttachmentIndex < this.maxColorAttachments-1);
	}
	body
	{
		if(attachmentType == AttachmentType.Color)
		{
			this.ColorAttachments.add(colorAttachmentIndex, new ColorAttachment(colorAttachmentIndex));
			glFramebufferTexture2D(this.target, attachmentType + this.colorAttachmentIndex, GL_RENDERBUFFER, renderBuffer.object);
			this.colorAttachmentIndex++;
		}
		else
			glFramebufferTexture2D(this.target, attachmentType, texture.target, texture.object, mipmapLevel);
	}
	
	public void AttachTexture(AttachmentType attachmentType, CubeMap texture, CubemapTarget target, uint mipmapLevel = 0)
	in
	{
		assert(this.bound);
		if(attachmentType == AttachmentType.Color)
			assert(this.colorAttachmentIndex < this.maxColorAttachments-1);
	}
	body
	{
		if(attachmentType == AttachmentType.Color)
		{
			this.ColorAttachments.add(colorAttachmentIndex, new ColorAttachment(colorAttachmentIndex));
			glFramebufferTexture2D(this.target, attachmentType + this.colorAttachmentIndex, GL_RENDERBUFFER, renderBuffer.object);
			this.colorAttachmentIndex++;
		}
		else
			glFramebufferTexture2D(this.target, attachmentType, target, texture.object, mipmapLevel);
	}
	
	public void AttachTexture(AttachmentType attachmentType, TextureRectangle texture)
	in
	{
		assert(this.bound);
		if(attachmentType == AttachmentType.Color)
			assert(this.colorAttachmentIndex < this.maxColorAttachments-1);
	}
	body
	{
		if(attachmentType == AttachmentType.Color)
		{
			this.ColorAttachments.add(colorAttachmentIndex, new ColorAttachment(colorAttachmentIndex));
			glFramebufferTexture2D(this.target, attachmentType + this.colorAttachmentIndex, GL_RENDERBUFFER, renderBuffer.object);
			this.colorAttachmentIndex++;
		}
		else
			glFramebufferTexture2D(this.target, attachmentType, texture.target, texture.object, 0);
	}
	
	public void AttachTexture(AttachmentType attachmentType, Texture2DMultisample texture)
	in
	{
		assert(this.bound);
		if(attachmentType == AttachmentType.Color)
			assert(this.colorAttachmentIndex < this.maxColorAttachments-1);
	}
	body
	{
		if(attachmentType == AttachmentType.Color)
		{
			this.ColorAttachments.add(colorAttachmentIndex, new ColorAttachment(colorAttachmentIndex));
			glFramebufferTexture2D(this.target, attachmentType + this.colorAttachmentIndex, GL_RENDERBUFFER, renderBuffer.object);
			this.colorAttachmentIndex++;
		}
		else
			glFramebufferTexture2D(this.target, attachmentType, texture.target, texture.object, 0);
	}
	
	/**
	   * level <= log2 Max3dTextureSize
	   */
	public void AttachTexture(AttachmentType attachmentType, Texture3D texture, uint mipmapLevel = 0)
	in
	{
		assert(this.bound);
		if(attachmentType == AttachmentType.Color)
			assert(this.colorAttachmentIndex < this.maxColorAttachments-1);
		//TODO level
	}
	body
	{
		if(attachmentType == AttachmentType.Color)
		{
			this.ColorAttachments.add(colorAttachmentIndex, new ColorAttachment(colorAttachmentIndex));
			glFramebufferTexture2D(this.target, attachmentType + this.colorAttachmentIndex, GL_RENDERBUFFER, renderBuffer.object);
			this.colorAttachmentIndex++;
		}
		else
			glFramebufferTexture3D(this.target, attachmentType, texture.target, texture.object, mipmapLevel);
	}
	
	public void AttachTextureLayer(AttachmentType attachmentType, Texture1DArray texture, uint layer, uint mipmapLevel = 0)
	in
	{
		assert(this.bound);
		if(attachmentType == AttachmentType.Color)
			assert(this.colorAttachmentIndex < this.maxColorAttachments-1);
	}
	body
	{
		if(attachmentType == AttachmentType.Color)
		{
			this.ColorAttachments.add(colorAttachmentIndex, new ColorAttachment(colorAttachmentIndex));
			glFramebufferTexture(this.target, attachmentType + this.colorAttachmentIndex, GL_RENDERBUFFER, renderBuffer.object);
			this.colorAttachmentIndex++;
		}
		else
			glFramebufferTextureLayer(this.target, attachmentType, texture.object, mipmapLevel, layer);
	}
	
	public void AttachTextureLayer(AttachmentType attachmentType, Texture2DArray texture, uint layer, uint mipmapLevel = 0)
	in
	{
		assert(this.bound);
		if(attachmentType == AttachmentType.Color)
			assert(this.colorAttachmentIndex < this.maxColorAttachments-1);
	}
	body
	{
		if(attachmentType == AttachmentType.Color)
		{
			this.ColorAttachments.add(colorAttachmentIndex, new ColorAttachment(colorAttachmentIndex));
			glFramebufferTexture(this.target, attachmentType + this.colorAttachmentIndex, GL_RENDERBUFFER, renderBuffer.object);
			this.colorAttachmentIndex++;
		}
		else
			glFramebufferTextureLayer(this.target, attachmentType, texture.object, mipmapLevel, layer);
	}
	
	public void AttachTextureLayer(AttachmentType attachmentType, Texture2DMultisampleArray texture, uint layer, uint mipmapLevel = 0)
	in
	{
		assert(this.bound);
		if(attachmentType == AttachmentType.Color)
			assert(this.colorAttachmentIndex < this.maxColorAttachments-1);
	}
	body
	{
		if(attachmentType == AttachmentType.Color)
		{
			this.ColorAttachments.add(colorAttachmentIndex, new ColorAttachment(colorAttachmentIndex));
			glFramebufferTexture(this.target, attachmentType + this.colorAttachmentIndex, GL_RENDERBUFFER, renderBuffer.object);
			this.colorAttachmentIndex++;
		}
		else
			glFramebufferTextureLayer(this.target, attachmentType, texture.object, mipmapLevel, layer);
	}
	
	
	public void AttachTextureLayer(AttachmentType attachmentType, Texture3D texture, uint layer, uint mipmapLevel = 0)
	in
	{
		assert(this.bound);
		if(attachmentType == AttachmentType.Color)
			assert(this.colorAttachmentIndex < this.maxColorAttachments-1);
	}
	body
	{
		if(attachmentType == AttachmentType.Color)
		{
			this.ColorAttachments.add(colorAttachmentIndex, new ColorAttachment(colorAttachmentIndex));
			glFramebufferTexture(this.target, attachmentType + this.colorAttachmentIndex, GL_RENDERBUFFER, renderBuffer.object);
			this.colorAttachmentIndex++;
		}
		else
			glFramebufferTextureLayer(this.target, attachmentType, texture.object, mipmapLevel, layer);
	}
}

class DrawFramebuffer : FramebufferObject
{
	public this()
	{
		super(FramebufferTarget.Draw);
	}
}

class ReadFramebuffer : FramebufferObject
{
	public this()
	{
		super(FramebufferTarget.Read);
	}
}

class Framebuffer : FramebufferObject
{
	public this()
	{
		super(FramebufferTarget.DrawAndRead);
	}
}