module xoanon.content.Sphere;

import xoanon.core.math.Vector;
import tango.io.Stdout;
import tango.math.Math;
import xoanon.content.Geometry;
import xoanon.content.Mesh;

interface Sphere : IPrimitive
{
	public float radius();
}

template SphereMixin()
{
	private float _radius;
	
	public float radius()
	{
		return _radius;
	}
}

class UVSphere : TriangleMesh, Sphere
{
	mixin SphereMixin!();
	
	public this(uint numLongitudes, uint numLatitudes, float radius)
	{
		super();
		createData(numLongitudes, numLatitudes, radius);
		_radius = radius;
		this._changed = true;
	}
	
	private void createData(uint numLongitudes, uint numLatitudes, float radius)
	{
		float alpha = 2*PI / cast(float) numLongitudes;
		float beta = PI / cast(float) (numLatitudes - 1);
		
		float texX = 1.0f / cast(float) numLongitudes;
		float texY = 1.0f / cast(float) (numLatitudes - 1);
		
		vertices = new Vertex[(numLongitudes + 1) * numLatitudes];
		ushort[] indices = new ushort[numLongitudes * (numLatitudes - 1) * 6];
		
		for(uint longi = 0; longi < numLongitudes + 1; longi++)
		{
			uint currentRing = longi * numLatitudes;
			for(uint lati = 0; lati < numLatitudes; lati++)
			{
				auto o = currentRing + lati;
				vertices[o].normal = Vector3f(sin(beta * lati) * sin(alpha * longi), cos(beta * lati), sin(beta * lati) * cos(alpha * longi));
				vertices[o].position = radius * vertices[o].normal;
				vertices[o].texCoord = Vector2f(texX * longi, texY * lati);
			}
		}
		
		uint t = 0;
		for(uint longi = 0; longi < numLongitudes; longi++)
		{
			uint currentRing = longi * numLatitudes;
			for(uint lati = 0; lati < numLatitudes - 1; lati++)
			{
				auto o = currentRing + lati;
				indices[6*t  ] = o;
				indices[6*t+1] = o + 1;
				indices[6*t+2] = o + numLatitudes + 1;
				
				indices[6*t+3] = o;
				indices[6*t+4] = o + numLatitudes + 1;
				indices[6*t+5] = o + numLatitudes;
				t++;
			}
		}
		
		this.rate = UpdateRate.Never;
		
		this.triangles = new Triangle!(ushort)[indices.length / 3];
		
		for(int i = 0; i < triangles.length; i++)
		{
			triangles[i].v1 = indices[i*3];
			triangles[i].v2 = indices[i*3 +1];
			triangles[i].v3 = indices[i*3 +2];
		}
		
		debug
		{
			Stdout("vertices.length: ")(vertices.length).newline();
			for(int i = 0; i < vertices.length; i++)
				Stdout.formatln("vertices[{}].position = {}", i, vertices[i].position.toArray());
			Stdout("indices.length: ")(indices.length).newline();
			/+for(int i = 0; i < indices.length; i++)
				Stdout.formatln("indices[{}] = {}", i, indices[i]);+/
			Stdout.formatln("triangles.length: {}", triangles.length);
			for(int i = 0; i < triangles.length; i++)
				Stdout.formatln("triangles[{}] = {}", i, triangles[i].toArray);
		}
		
	}
	
	
}