module resources.Polyhedron;

import graphics.hardware.BufferObject;
import graphics.hardware.GraphicsDevice;
import graphics.hardware.PrimitiveType;
import graphics.hardware.Program;
import graphics.hardware.ProgramAttribute;
import graphics.hardware.ProgramUniform;
import graphics.hardware.Shader;
import graphics.hardware.ShaderVariable;
import graphics.hardware.TexImage2D;
import resources.Material;
import resources.Mesh;
import tango.io.Stdout;
import tango.math.Math;
import math.Vector;

class Polyhedron
{
	private uint numVertices, numEdges, numFaces;
	private uint numEdgesPerFace, numEdgesPerVertex;
	
	public this(uint numVertices, uint numEdges, uint numFaces, uint numEdgesPerFace, uint numEdgesPerVertex)
	{
		this.numVertices = numVertices;
		this.numEdges = numEdges;
		this.numFaces = numFaces;
		this.numEdgesPerFace = numEdgesPerFace;
		this.numEdgesPerVertex = numEdgesPerVertex;
	}
}


class SimpleMaterial : Material
{
	public this(char[] texturePath)
	{
		char[] loc = r"J:\Programme\Programmieren\Projekte\GameFW\lessons\";
		this.program = LoadProgram(loc ~ "Lesson03.vs.glsl", loc ~ "Lesson03.fs.glsl");
		program.attributes.add("Vertex", new ProgramAttribute(program.GetAttribLoc("Vertex"), "Vertex", ShaderVariable.FloatVector4));
		program.attributes.add("TexCoordin", new ProgramAttribute(program.GetAttribLoc("TexCoordin"), "TexCoordin", ShaderVariable.FloatVector2));
		
		program.uniforms.add("World", new ProgramUniform(program.GetUniformLoc("World"), "World", ShaderVariable.Matrix4));
		program.uniforms.add("View", new ProgramUniform(program.GetUniformLoc("View"), "View", ShaderVariable.Matrix4));
		program.uniforms.add("Projection", new ProgramUniform(program.GetUniformLoc("Projection"), "Projection", ShaderVariable.Matrix4));
		
		program.uniforms.add("Texture0", new ProgramUniform(program.GetUniformLoc("Texture0"), "Texture0", ShaderVariable.Sampler2D));
		
		this.textures ~= Texture2D.Load(texturePath);
		foreach(k, attribute; program.attributes)
			Stdout(attribute).newline;
	}
	
	public override void begin()
	{
		program.use();
		this.program.uniforms["World"].SetValue(this.world);
		this.program.uniforms["View"].SetValue(this.view);
		this.program.uniforms["Projection"].SetValue(this.projection);
		
		this.program.uniforms["Texture0"].SetTextureUnit(0);
		
		this.textures[0].Bind();
	}
	
	public override void end()
	{
		
	}
}

class Sphere : Mesh
{
	public struct Vertex
	{
		Vector3f Position;
		Vector3f Normal;
		Vector2f TexCoordin;
	}
	
	GraphicsDevice device;
	
	private void createData(uint numLongitudes, uint numLatitudes, float radius)
	{
		float alpha = 2*PI / cast(float) numLongitudes;
		float beta = PI / cast(float) (numLatitudes - 1);
		
		float texX = 1.0f / cast(float) numLongitudes;
		float texY = 1.0f / cast(float) (numLatitudes - 1);
		
		Vertex[] vertices = new Vertex[(numLongitudes + 1) * numLatitudes];
		ushort[] indices = new ushort[numLongitudes * (numLatitudes - 1) * 6];
		
		for(uint longi = 0; longi < numLongitudes + 1; longi++)
		{
			uint currentRing = longi * numLatitudes;
			for(uint lati = 0; lati < numLatitudes; lati++)
			{
				auto o = currentRing + lati;
				vertices[o].Normal = Vector3f(sin(beta * lati) * sin(alpha * longi), cos(beta * lati), sin(beta * lati) * cos(alpha * longi));
				vertices[o].Position = radius * vertices[o].Normal;
				vertices[o].TexCoordin = Vector2f(texX * longi, texY * lati);
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
		/+
		Stdout("vertices.length: ")(vertices.length).newline();
		for(int i = 0; i < vertices.length; i++)
			Stdout.formatln("vertices[{}].Position = {}", i, vertices[i].Position.ToArray());
		Stdout("indices.length: ")(indices.length).newline();+/
		/+for(int i = 0; i < indices.length; i++)
			Stdout.formatln("indices[{}] = {}", i, indices[i]);+/
		this.vertexBuffer = new VertexBuffer(vertices, BufferUsageHint.StaticDraw);
		this.indexBuffer = new IndexBuffer(indices, IndexType.Ushort, BufferUsageHint.StaticDraw);
	}
	
	public this(uint numLongitudes, uint numLatitudes, float radius)
	{
		createData(numLongitudes, numLatitudes, radius);
		device = new GraphicsDevice();
	}
	
	public override void render()
	{
		vertexBuffer.Bind();
		indexBuffer.Bind();
		material.begin();
		material.program.attributes["TexCoordin"].SpecifyArray(DataType.Float, VertexSize.Two, Vector3f.sizeof * 2, Vertex.sizeof);
		material.program.attributes["Vertex"].SpecifyArray(DataType.Float, VertexSize.Three, 0, Vertex.sizeof);
		
		material.program.attributes["TexCoordin"].EnableArray();
		material.program.attributes["Vertex"].EnableArray();
		
		device.drawIndexedPrimitives(PrimitiveType.Triangles, this.indexBuffer);
		
		material.program.attributes["Vertex"].DisableArray();
		material.program.attributes["TexCoordin"].DisableArray();
	}
}
