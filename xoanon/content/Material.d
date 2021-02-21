module xoanon.content.Material;

import xoanon.content.Mesh;
import xoanon.scene.Camera;
import xoanon.scene.Form;
import xoanon.system.graphics.hardware.Program;
import tango.core.Variant;
import tango.util.container.HashMap;
import tango.util.container.HashSet;
import xoanon.content.Effect;

class MaterialDescription
{
	char[] name;
	
	HashSet!(char[]) parameters;
	
	override int opEquals(Object o)
	{
		if(o !is null)
			if(Material other = cast(Material) o)
				if(other.name == this.name)
					return true;
		return false;
	}
}

class DescriptionParam
{
	char[] name;
}

interface IMaterial
{
	
}

class Material : IMaterial
{
	char[] name;
	HashMap!(char[], MaterialParam) parameters;
	
	override int opEquals(Object o)
	{
		if(o !is null)
			if(Material other = cast(Material) o)
				if(other.name == this.name)
					return true;
		return false;
	}
}

class Param
{
	char[] name;
	char[] type;
	Variant value;
}

alias Param MaterialParam;

class CompiledMaterial : IMaterial
{
	
}

class CompiledMaterialEffect : Effect
{
	Program program;
	CameraNode camera;
	FormNode formNode;
	
	abstract void material(CompiledMaterial material);
	
	Mesh mesh;
	
	void use()
	{
	}
	
	void begin()
	{
	}
	
	void process()
	{
	}
	
	void end()
	{
	}
	
	
}
/+
class MaterialEffect : Effect
{
	MaterialDescription description;
	Program program;
	
	private Material material;
	private Mesh mesh;
	
	//match the materiale and the description?
	bool matches(Material material)
	{
		return this.description == material ? true : false;
	}
	
	public void set(Material material)
	{
		this.material = material;
	}
	
	override void begin()
	{
		foreach(param; description.parameters)
		{
			auto t = typeid(float);
			program.uniforms[param].setValue(this.material.parameters[param].get!());
		}
	}
	
	override void process()
	{
		// TODO Auto-generated method stub
		super.process();
	}
	
	override void end()
	{
		super.end();
	}
}+/