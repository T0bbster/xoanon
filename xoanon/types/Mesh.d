module resources.Mesh;

import graphics.hardware.BufferObject;
import resources.Material;

abstract class Mesh
{
	VertexBuffer vertexBuffer;
	IndexBuffer indexBuffer;
	
	Material material;
	
	abstract void render();
}