module xoanon.content.ContentManager;

import tango.io.Stdout;
import tango.util.container.HashMap;
import xoanon.content.Geometry;
import xoanon.content.Material;
import xoanon.content.Mesh;
import xoanon.system.graphics.hardware.BufferObject;

class BufferManager
{
	private HashMap!(Mesh, VertexBuffer) vertexBuffers;
	private HashMap!(Mesh, IndexBuffer) indexBuffers;
	
	public this()
	{
		this.vertexBuffers = new HashMap!(Mesh, VertexBuffer);
		this.indexBuffers = new HashMap!(Mesh, IndexBuffer);
	}
	
	void use(Mesh mesh)
	{
		if(mesh in vertexBuffers)
		{
			vertexBuffers[mesh].bind();
			if(mesh in indexBuffers)
				indexBuffers[mesh].bind();
		}
	}
	
	public IndexBuffer indexBuffer(Mesh mesh)
	{
		return indexBuffers[mesh];
	}
	
	public void addMesh(Mesh mesh)
	{
		BufferUsageHint hint;
		switch(mesh.rate)
		{
			case UpdateRate.Never:
				hint = BufferUsageHint.StaticDraw;
				break;
			case UpdateRate.Sometimes:
				hint = BufferUsageHint.StreamDraw;
				break;
			case UpdateRate.Always:
				hint = BufferUsageHint.DynamicDraw;
				break;
		}
		if(mesh in vertexBuffers)
			return;
		
		vertexBuffers[mesh] = new VertexBuffer(mesh.vertices, hint);
		debug
		{
			Stdout.formatln("mesh.vertices.length = {}", mesh.vertices.length);
		}
		
		if(auto triangleMesh = cast(TriangleMesh) mesh)
		{
			indexBuffers[mesh] = new IndexBuffer(triangleMesh.getIndices(), IndexType.Ushort, hint);
			debug
			{
				Stdout.formatln("triangleMesh.triangles.length = {}", triangleMesh.triangles.length);
				//Stdout.formatln("triangleMesh.getIndices = {}", triangleMesh.getIndices);
			}
		}
	}
}
/+
class MaterialEffectManager
{
	HashMap!(Material, MaterialEffect) effects;
	
	
}+/