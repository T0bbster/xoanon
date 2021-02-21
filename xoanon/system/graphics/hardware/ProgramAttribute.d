module xoanon.system.graphics.hardware.ProgramAttribute;

import xoanon.system.graphics.hardware.ShaderVariable;
import xoanon.core.math.Vector;
import xoanon.system.graphics.hardware.gl.GL3;

enum DataType : GLenum
{
	Float = GL_FLOAT
}

class ProgramAttribute
{
	package
	{
		uint location;
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
		return this.location;
	}
	
	public void value(float value)
	{
		glVertexAttrib1f(this.location, value);
	}
	
	public void value(Vector4f vector)
	in
	{
		assert(this.shaderVariable == ShaderVariable.FloatVector4);
	}
	body
	{
		glVertexAttrib4fv(this.location, vector.toArray().ptr);
	}
	
	public final void enableArray()
	{
		glEnableVertexAttribArray(this.location);
	}

	public final void disableArray() 
	{
		glDisableVertexAttribArray(this.location);
	}
	
	public void specifyArray(DataType type, VertexSize size, int offset, int stride = 0, bool normalize = false)
	{
		glVertexAttribPointer(this.location, size, type, normalize, stride, cast(byte*) (offset));
	}
	
	override hash_t toHash()
	{
		return this.location;
	}
}

enum VertexSize : GLint
{
	One	= 1,
	Two,
	Three,
	Four
}

/+
class AttributeValue : ProgramAttribute
{
	public this(uint location, char[] name)
	{
		super(location, name);
	}
	
	public override void SetValue(T)(T value)
	in
	{
		assert(is(T == float) || 
			   is(T == uint) ||
			   is(T == int));
	}
	body
	{
		if(is(T == float))
			glAttribute1f(this.location, value);
		else if(is(T == uint))
			glAttribute1ui(this.location, value);
		else if(is(T == int))
			glAttribute1i(this.location, value);
	}
}

class AttributeVector2 : ProgramAttribute
{
	public this(uint location, char[] name)
	{
		super(location, name);
	}
	
	public override void SetValue(T)(T value)
	in
	{
		assert(is(T == Vector2));
	}
	body
	{
		glAttribute2fv(this.location, 1, value.toArray.ptr);	
	}
}

class AttributeVector3 : ProgramAttribute
{
	public this(uint location, char[] name)
	{
		super(location, name);
	}
	
	public override void SetValue(T)(T value)
	in
	{
		assert(is(T == Vector3));
	}
	body
	{
		glAttribute3fv(this.location, 1, value.toArray.ptr);	
	}
}

class AttributeVector4 : ProgramAttribute
{
	public this(uint location, char[] name)
	{
		super(location, name);
	}
	
	public override void SetValue(T)(T value)
	in
	{
		assert(is(T == Vector4));
	}
	body
	{
		glUniform4fv(this.location, 1, value.toArray.ptr);	
	}
}
+/