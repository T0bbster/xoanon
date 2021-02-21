module xoanon.system.graphics.hardware.GraphicsDevice;

import xoanon.system.graphics.hardware.RenderState;
import xoanon.system.graphics.hardware.TransformFeedback;
import xoanon.system.graphics.hardware.Viewport;
import xoanon.system.graphics.hardware.gl.GL3;
import xoanon.system.graphics.hardware.BufferObject;
import xoanon.system.graphics.hardware.ConditionalRender;
import xoanon.system.graphics.hardware.OcclusionQuery;
import xoanon.system.graphics.hardware.PrimitiveType;


enum ClearTarget : GLenum
{
	ColorBuffer = GL_COLOR_BUFFER_BIT,
	DepthBuffer = GL_DEPTH_BUFFER_BIT,
	StencilBuffer = GL_STENCIL_BUFFER_BIT
}

class GraphicsDevice 
{
	public RenderState renderState;
	public ConditionalRender conditionalRender;
	public TransformFeedback transformFeedback;
	
	public void flush() 
	{
		glFlush();
	}

	public void finish() 
	{
		glFinish();
	}
  
	public void drawPrimitives(PrimitiveType primitiveType, int first, int count) 
	{
		glDrawArrays(primitiveType, first, count);
	}

	public void drawPrimitives(PrimitiveType primitiveType, uint[] first, uint[] count, uint numPrimitives) 
	{
		glMultiDrawArrays(primitiveType, cast(int*)first.ptr, cast(int*)count.ptr, numPrimitives);
	}

	public void drawIndexedPrimitives(PrimitiveType primitiveType, IndexType indexType, void[] indices) 
	{
		glDrawElements(primitiveType, indices.length, indexType, indices.ptr);
	}
  
	public void drawIndexedPrimitives(PrimitiveType primitiveType, IndexBuffer buffer) 
	{
		glDrawElements(primitiveType, buffer.length, buffer.type, null);
	}

	public void drawIndexedPrimitives(PrimitiveType primitiveType, IndexType indexType, void[][] indices, uint[] count, uint numPrimitives) 
	{
		glMultiDrawElements(primitiveType, cast(int*)count.ptr, indexType, cast(void**)indices, numPrimitives);
	}

	public void drawPrimitivesInstanced(PrimitiveType primitiveType, uint first, uint count, uint numPrimitives) 
	{
		glDrawArraysInstanced(primitiveType, first, count, numPrimitives);
	}

	public void drawIndexedPrimitivesInstanced(PrimitiveType primitiveType, IndexType indexType, void[] indices, uint count, uint numPrimitives) 
	{
		glDrawElementsInstanced(primitiveType, count, indexType, indices.ptr, numPrimitives);
	}

	public void drawIndexedPrimitivesInstanced(PrimitiveType primitiveType, IndexBuffer buffer, uint numPrimitives)
	{
		glDrawElementsInstanced(primitiveType, buffer.length, buffer.type, null, numPrimitives);
	}
	
	public void clear(ClearTarget targetFlags) 
	{
		glClear(targetFlags);
	}
}
  /+
  public void drawIndexedPrimitives(PrimitiveType primitiveType, void[] indices, uint count, uint start, uint end) 
  {
	  glDrawElementsBaseVertex(primitiveType, buffer.Length, buffer.type, null, numPrimitives)
  }

  public void drawIndexedPrimitives(PrimitiveType primitiveType, IndexBuffer buffer, uint count, uint start, uint end) 
  {
	  glDrawElementsBaseVertex(primitiveType, buffer.Length, buffer.type, null, numPrimitives)
  }

  public Error GetError() {
  }

  
  
  
  public  Draw() {
  }

  public  Clear() {
  }

  

  public void* ReadPixels(uint x, uint y, uint width, uint height, DataFormat format, DataType primitiveType,  ) {
  }

  public void CopyReadBufferToDrawBuffers(Rectangle source, Rectangle destination,  mask,  filter) {
  }

}
+/
