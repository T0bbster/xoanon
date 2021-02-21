module resources.Material;

import math.Matrix;
import graphics.hardware.Texture;
import graphics.hardware.Program;

class Material
{
	public Program program;
	Texture[] textures;
	Matrix4f world, view, projection;
	
	abstract void begin();
	abstract void end();
}