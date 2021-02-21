module xoanon.system.graphics.hardware.ProgramUniform;

import xoanon.core.Color;
import xoanon.core.math.Matrix;
import xoanon.core.math.Vector;
import xoanon.system.graphics.hardware.ShaderVariable;
import xoanon.system.graphics.hardware.gl.GL3;

class ProgramUniform
{
	package
	{
		protected uint location;
		char[] name;
		ShaderVariable shaderVariable;
	}

	public this(uint location, char[] name, ShaderVariable shaderVariable)
	{
		this.location = location;
		this.name = name;
		this.shaderVariable = shaderVariable;
	}
	
	public uint loc()
	{
		return location;
	}
	
	public void setTextureUnit(uint index)
	{
		glUniform1i(this.location, index);
	}
	
	public void value(bool value)
	in
	{
		assert(this.shaderVariable == ShaderVariable.Bool);
	}
	body
	{
		glUniform1i(this.location, value);
	}
	
	/+
	public void value(Vector!(bool, 2) value)
	in
	{
		assert(this.shaderVariable == ShaderVariable.BoolVector2);
	}
	body
	{
		glUniform2iv(this.location, 1, cast(int*) value.toArray().ptr);
	}
	
	public void value(float value)
	in  
	{
	}
	body
	{
		glUniform1f(this.location, value);
	}
	+/
	public void value(Matrix4f value)
	in
	{
		assert(this.shaderVariable == ShaderVariable.Matrix4);
	}
	body
	{	
		glUniformMatrix4fv(this.location, 1, true, value.toArray().ptr);
	}
	
	public void value(Vector3f vector)
	in  
	{
		assert(this.shaderVariable == ShaderVariable.FloatVector3);
	}
	body
	{
		glUniform3fv(this.location, 1, vector.toArray().ptr);
	}
	
	public void value(Vector4f vector)
	in  
	{
		assert(this.shaderVariable == ShaderVariable.FloatVector4);
	}
	body
	{
		glUniform4fv(this.location, 1, vector.toArray().ptr);
	}
	
	public void value(Colorf color)
	in  
	{
		assert(this.shaderVariable == ShaderVariable.FloatVector4);
	}
	body
	{
		glUniform4fv(this.location, 1, color.toArray().ptr);
	}
}
/+
class UniformMatrix : ProgramUniform
{
	public this(uint location, char[] name)
	{
		super(location, name);
	}
	
	public override void value(Variant value)
	in
	{
		//assert(is(T == Matrix) || is(T == SquareMatrix));
	}
	body
	{
		glUniformMatrix4fv(this.location, 1, true, value.get.toArray.ptr);
	}
}

class UniformValue : ProgramUniform
{
	public this(uint location, char[] name)
	{
		super(location, name);
	}
	
	public override void value(T)(T value)
	in
	{
		assert(is(T == float) || 
			   is(T == uint) ||
			   is(T == int));
	}
	body
	{
		if(is(T == float))
			glUniform1f(this.location, value);
		else if(is(T == uint))
			glUniform1ui(this.location, value);
		else if(is(T == int))
			glUniform1i(this.location, value);
	}
}

class UniformVector2 : ProgramUniform
{
	public this(uint location, char[] name)
	{
		super(location, name);
	}
	
	public override void value(T)(T value)
	in
	{
		assert(is(T == Vector2));
	}
	body
	{
		glUniform2fv(this.location, 1, value.toArray.ptr);	
	}
}

class UniformVector3 : ProgramUniform
{
	public this(uint location, char[] name)
	{
		super(location, name);
	}
	
	public override void value(T)(T value)
	in
	{
		assert(is(T == Vector3));
	}
	body
	{
		glUniform3fv(this.location, 1, value.toArray.ptr);	
	}
}

class UniformVector4 : ProgramUniform
{
	public this(uint location, char[] name)
	{
		super(location, name);
	}
	
	public override void value(T)(T value)
	in
	{
		assert(is(T == Vector4));
	}
	body
	{
		glUniform4fv(this.location, 1, value.toArray.ptr);	
	}
}+/