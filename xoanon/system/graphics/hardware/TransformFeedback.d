module xoanon.system.graphics.hardware.TransformFeedback;

import xoanon.system.graphics.hardware.gl.GL3;

enum PrimitiveMode
{
	Points		= GL_POINTS,
	Lines		= GL_LINES,
	Triangles	= GL_TRIANGLES
}

struct TransformFeedback 
{
	private bool started = false;
	public bool Started()
	{
		return this.started;
	}
	
	public void Begin(PrimitiveMode mode)
	in
	{
		assert(!started);
		this.started = true;
	}
	body
	{
		glBeginTransformFeedback(mode);
	}
	
	public void End()
	in
	{
		assert(started);
		this.started = false;
	}
	body
	{
		glEndTransformFeedback();
	}
}
