module graphics.hardware.TextureMultisample;

import base.GL3functions;
import base.GL3types;
import graphics.hardware.RenderBuffer;
import graphics.hardware.TextureTarget;
import graphics.hardware.WrappingMode;
import graphics.hardware.Texture;

class Texture2DMultisample : TextureInit
{
	public this()
	{
		super(TextureTarget.Texture2DMultisample);
	}
	
	private void initialize(uint width, uint height, int internalFormat, uint samples, bool fixedSampleLocations)
	in
	{
		assert(this.bound);
		//TODO check sizes
	}
	body
	{
		glTexImage3DMultisample(this.target, samples, internalFormat, width, height, fixedSampleLocations);
		this.initialized = true;
	}
	
	public void Initialize(uint width, uint height, ColorRenderable internalFormat, uint samples, bool fixedSampleLocations = true)
	{
		this.initialize(width, height, internalFormat, samples, fixedSampleLocations);
	}
	
	public void Initialize(uint width, uint height, DepthRenderable internalFormat, uint samples, bool fixedSampleLocations = true)
	{
		this.initialize(width, height, internalFormat, samples, fixedSampleLocations);
	}
	
	public void Initialize(uint width, uint height, StencilRenderable internalFormat, uint samples, bool fixedSampleLocations = true)
	{
		this.initialize(width, height, internalFormat, samples, fixedSampleLocations);
	}
}

class Texture2DMultisampleArray : TextureInit
{	
	public this()
	{
		super(TextureTarget.Texture2DMultisampleArray);
	}
	
	private void initialize(uint width, uint height, uint depth, int internalFormat, uint samples, bool fixedSampleLocations = true)
	in
	{
		assert(this.bound);
		//TODO check sizes
	}
	body
	{
		glTexImage3DMultisample(this.target, samples, internalFormat, width, height, depth, fixedSampleLocations);
		this.initialized = true;
	}
	
	public void Initialize(uint width, uint height, uint depth, ColorRenderable internalFormat, uint samples, bool fixedSampleLocations = true)
	{
		this.initialize(width, height, depth, internalFormat, samples, fixedSampleLocations);
	}
	
	public void Initialize(uint width, uint height, uint depth, DepthRenderable internalFormat, uint samples, bool fixedSampleLocations = true)
	{
		this.initialize(width, height, depth, internalFormat, samples, fixedSampleLocations);
	}
	
	public void Initialize(uint width, uint height, uint depth, StencilRenderable internalFormat, uint samples, bool fixedSampleLocations = true)
	{
		this.initialize(width, height, depth, internalFormat, samples, fixedSampleLocations);
	}
}