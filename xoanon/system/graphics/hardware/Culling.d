module graphics.hardware.Culling;

import xoanon.system.graphics.hardware.gl.GL3;

public struct Culling
{
	public void enable()
	{
		glEnable(GL_CULL_FACE);
	}
	
	public void disable()
	{
		glDisable(GL_CULL_FACE);
	}
	
	enum CullMode
	{
		Front			= GL_FRONT,
		Back		 	= GL_BACK,
		FrontAndBack 	= GL_FRONT_AND_BACK
	}
	
	public CullMode cullMode;
	public void cullFace(CullMode mode)
	{
		glCullFace(mode);
		cullMode = mode;
	}
	public CullMode cullFace()
	{
		return cullMode;
	}
}	
