module graphics.hardware.Polygons;

import xoanon.system.graphics.hardware.gl.GL3;

struct Polygons
{
	enum Orientation : GLenum
	{
		Clockwise = GL_CW,
		CounterClockwise = GL_CCW
	}
	
	private Orientation orientation;
	public void FrontFace(Orientation value)
	{
		glFrontFace(value);
		orientation = value;
	}
	public Orientation FrontFace()
	{
		return orientation;
	}
}	
