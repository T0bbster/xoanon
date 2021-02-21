module xoanon.system.graphics.hardware.OcclusionQuery;

import xoanon.system.graphics.hardware.gl.GL3;
import xoanon.system.graphics.hardware.QueryObject;

class OcclusionQuery : QueryObject
{
	public void begin()
	in
	{
		assert(!_started);
		this._started = true;
	}
	body
	{
		glBeginQuery(GL_SAMPLES_PASSED, this.object);
	}
	
	public void end()
	in
	{
		assert(_started);
		this._started = false;
	}
	body
	{
		glEndQuery(this.object);
	}

	public uint getPassedSamples() 
	{
		uint samples;
		glGetQueryObjectuiv(this.object, GL_QUERY_RESULT, &samples);
		return samples;
	}

	public bool isResultAvailable() 
	{
		int res;
		glGetQueryObjectiv(this.object, GL_QUERY_RESULT_AVAILABLE, &res);
		return cast(bool) res;
	}
}
