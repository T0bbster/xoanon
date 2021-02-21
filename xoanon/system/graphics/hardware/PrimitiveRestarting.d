module graphics.hardware.PrimitiveRestarting;

import xoanon.system.graphics.hardware.gl.GL3;

struct PrimitiveRestarting 
{
	public void enable() 
	{
		glEnable(GL_PRIMITIVE_RESTART);
	}
	
	public void disable() 
	{
		glDisable(GL_PRIMITIVE_RESTART);
	}
	
	private uint index;
	public void restartIndex(uint value)
	{
		glPrimitiveRestartIndex(value);
		this.index = value;
	}
	public uint restartIndex()
	{
		return this.index;
	}
}
