module graphics.hardware.ScissorTest;

import base.GL3types;
import base.GL3functions;

class ScissorTest 
{
	private bool enabled;
	public void Enable() 
	{
		glEnable(GL_SCISSOR_TEST);
		this.enabled = true;
	}

	public void Disable() 
	{
		glDisable(GL_SCISSOR_TEST);
		this.enabled = false;
	}

	public bool IsEnabled()
	{
		return this.enabled;
	}

	private Rectangle rectangle;
	public void Box(Rectangle value)
	{
		glScissor(value.Left, value.Bottom, value.Width, value.Height);
	}

}

struct Rectangle
{
	public int Left, Bottom, Width, Height;
	
	public static Rectangle opCall(int left, int bottom, int width, int heigth)
	{
		Rectangle res;
		res.Left = left;
		res.Bottom = bottom;
		res.Width = width;
		res.Height = heigth;
		return res;
	}
}