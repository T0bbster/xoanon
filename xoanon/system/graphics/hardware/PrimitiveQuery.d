module graphics.hardware.PrimitiveQuery;

import base.GL3functions;
import base.GL3types;
import graphics.hardware.QueryObject;

enum PrimitiveTracking : GLenum
{
	GeneratedPrimitives					 = GL_PRIMITIVES_GENERATED,
	PrimitivesWrittenToTransformFeedback = GL_TRANSFORM_FEEDBACK_PRIMITIVES_WRITTEN,
}

class PrimitiveQuery : QueryObject 
{	
	public void Begin(PrimitiveTracking tracking)
	in
	{
		assert(!started);
		this.started = true;
	}
	body
	{
		glBeginQuery(tracking, this.object);
	}
	
	public void End()
	in
	{
		assert(started);
		this.started = false;
	}
	body
	{
		glEndQuery(this.object);
	}
}
