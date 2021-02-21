module xoanon.system.graphics.hardware.ConditionalRender;

import xoanon.system.graphics.hardware.gl.GL3;
import xoanon.system.graphics.hardware.OcclusionQuery;

enum RenderCondition : GLenum
{
	QueryWait 			= GL_QUERY_WAIT,
	QueryNoWait			= GL_QUERY_NO_WAIT,
	QueryWaitByRegion	= GL_QUERY_BY_REGION_WAIT,
	QueryNoWaitByRegion = GL_QUERY_BY_REGION_NO_WAIT,
}

struct ConditionalRender 
{
	private bool started = false;
	public bool Started()
	{
		return this.started;
	}
	
	public void Begin(OcclusionQuery query, RenderCondition condition)
	in
	{
		assert(!started);
		this.started = true;
	}
	body
	{
		glBeginConditionalRender(query.object, condition);
	}
	
	public void End()
	in
	{
		assert(started);
		this.started = false;
	}
	body
	{
		glEndConditionalRender();
	}
}