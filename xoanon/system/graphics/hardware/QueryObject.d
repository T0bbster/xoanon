module graphics.hardware.QueryObject;

import xoanon.system.graphics.hardware.gl.GL3;

package abstract class QueryObject
{
	package uint object;
	
	protected bool _started = false;
	
	public bool started()
	{
		return this._started;
	}
	
	public this()
	{
		glGenQueries(1, &this.object);
	}
	
	~this()
	{
		glDeleteQueries(1, &this.object);
	}
}
