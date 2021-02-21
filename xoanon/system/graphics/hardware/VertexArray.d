module xoanon.graphics.hardware.VertexArray;

import base.GL3functions;

class VertexArray 
{
	private uint object;
	
	public this(void delegate() del)
	{
		glGenVertexArrays(1, &this.object);
		this.Bind();
		del();
		this.Unbind();
	}
	
	public void Bind()
	{
		glBindVertexArray(this.object);
	}
	
	public void Unbind()
	{
		glBindVertexArray(0);
	}
}
