module xoanon.content.Mesh;

import xoanon.system.graphics.hardware.PrimitiveType;
import xoanon.core.math.Vector;
import tango.core.Tuple;
import xoanon.content.Geometry;


enum UpdateRate
{
	Always,
	Sometimes,
	Never
}

class Mesh : IGeometry
{
	protected bool _changed = false;
	
	Vertex[] vertices;
	
	PrimitiveType type;
	UpdateRate rate;
	
	override bool changed()
	{
		return _changed;
	}
	
	override void changed(bool change)
	{
		this._changed = change;
	}
}

struct Vertex
{
	Vector3f position;
	Vector3f normal;
	Vector2f texCoord;
}

//typedef Param VertexParam;


struct Triangle(T)
{
	union
	{
		struct
		{
			T v1, v2, v3;
		}
		private T[3] array;
	}
	
	public T[] toArray()
	{
		return this.array;
	}
}

class TriangleMesh : Mesh
{
	Triangle!(ushort)[] triangles;
	
	public this()
	{
		this.type = PrimitiveType.Triangles;
	}
	
	ushort[] getIndices()
	{
		ushort[] values = new ushort[triangles.length * 3]; 
		for(int i = 0; i < triangles.length; i++)
		{
			values[i*3 .. i*3+3] = triangles[i].toArray();
		}
		return values;
	}
}

