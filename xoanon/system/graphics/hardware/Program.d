module xoanon.system.graphics.hardware.Program;


import tango.util.container.HashMap;
import tango.util.container.HashSet;

import tango.core.Exception;
import tango.io.FilePath;
import tango.io.device.File;
import tango.stdc.stringz;
import tango.io.Stdout;

import xoanon.system.graphics.hardware.ShaderVariable;
import xoanon.system.graphics.hardware.gl.GL3;
import xoanon.system.graphics.hardware.gl.GL3types;
import xoanon.system.graphics.hardware.ProgramAttribute;
import xoanon.system.graphics.hardware.ProgramUniform;
import xoanon.system.graphics.hardware.Shader;


/// A class which handles shaders.
class Program 
{
	package uint object;
	
	public HashSet!(Shader) shaders;
	
	public HashMap!(char[], ProgramAttribute) attributes;
	public HashMap!(char[], ProgramUniform) uniforms;
	
	public this()
	{
		this.object = glCreateProgram();
		this.shaders = new HashSet!(Shader);
		this.attributes = new HashMap!(char[], ProgramAttribute);
		this.uniforms = new HashMap!(char[], ProgramUniform);
	}
	
	~this()
	{
		glDeleteProgram(this.object);
	}
	
	/**
	 * Attaches a shader to the program.
	 * Params:
	 *     shader = The Shader object to attach.
	 */
	public void attachShader(Shader shader)
	{
		this.shaders.add(shader);
		glAttachShader(this.object, shader.object);	
	}
	
	/**
	 * Detaches a shader from the program.
	 * Params:
	 *     shader = The Shader object to detach.
	 */
	public void detachShader(Shader shader) 
	{
		glDetachShader(this.object, shader.object);
		this.shaders.remove(shader);
	}
	
	/// Links the program.
	public void link() 
	{
		glLinkProgram(this.object);
	}
	
	/// Uses the program
	public void use() 
	{
		glUseProgram(this.object);
	}
		
	/// Validates the program. Use this for debugging.
	public void validate()
	{
		glValidateProgram(this.object);
		bool status = cast(bool) getParam(GL_VALIDATE_STATUS);
		if (!status)
		{
			auto log = getInfoLog();
			throw new ProgramValidationException(log);
		}
	}
	
	public GLuint getAttribLoc(char[] name)
	{
		return glGetAttribLocation(this.object, toStringz(name));
	}
	
	public GLint getUniformLoc(char[] name)
	{
		return glGetUniformLocation(this.object, toStringz(name));
	}
	
	public GLint getParam(GLenum param)
	{
		GLint result;
		glGetProgramiv(this.object, param, &result);
		return result;
	}
	
	package char[] getInfoLog()
	{
		uint logLength = getParam(GL_INFO_LOG_LENGTH);
		char* log;
		glGetProgramInfoLog(this.object, logLength, null, log);
		return fromStringz(log);
	}
}

class ProgramValidationException : Exception
{
	this(char[] infolog)
	{
		super("Program validation failure: \n" ~ infolog);
	}
}



char[] LoadShader(char[] path)
in
{
	assert(path != null);
}
body
{
	return cast(char[]) File.get(path);
}

Program LoadProgram(char[] vs, char[] fs)
{
	Program program = new Program();
	
	char[] vssource = LoadShader(vs);
	auto shader = new VertexShader(vssource);
	shader.compile();
	Stdout(shader.getSource).newline;
	program.attachShader(shader);
	
	char[] fssource = LoadShader(fs);
	auto fsshader = new FragmentShader(fssource);
	fsshader.compile();
	Stdout(fsshader.getSource).newline;
	program.attachShader(fsshader);

	program.link();
	//addUniforms(program);
	//addAttributes(program);
	
	 //Laufzeitfehler
	return program;
}

void addUniforms(Program p)
in
{
	assert(p !is null);
}
body
{
	uint activeUniforms = p.getParam(GL_ACTIVE_UNIFORMS);
	int bufSize = p.getParam(GL_ACTIVE_UNIFORM_MAX_LENGTH);
	
	int length;
	int size;
	uint type;
	char* cname;
	for(uint i = 0; i < activeUniforms; i++)
	{
		glGetActiveUniform(p.object, i, bufSize, &length, &size, &type, cname);
		char[] name = fromStringz(cname);
		p.uniforms.add(name, new ProgramUniform(i, name, cast(ShaderVariable) type));
	}
}

void addAttributes(Program p)
in
{
	assert(p !is null);
}
body
{
	uint activeUniforms = p.getParam(GL_ACTIVE_ATTRIBUTES);
	int bufSize = p.getParam(GL_ACTIVE_ATTRIBUTE_MAX_LENGTH);
	
	int length;
	int size;
	uint type;
	char* cname;
	for(uint i = 0; i < activeUniforms; i++)
	{
		glGetActiveAttrib(p.object, i, bufSize, &length, &size, &type, cname);
		char[] name = fromStringz(cname);
		p.attributes.add(name, new ProgramAttribute(i, name, cast(ShaderVariable) type));
	}
}

/+
Program LoadProgram(FilePath[] vertexShaderPaths, FilePath[] fragmentShaderPaths, FilePath[] geometryShaderPaths = null)
out(program)
{
	try
	{
		program.Validate();
	}
	catch(ProgramValidationException e)
	{
		Stdout(e).newline;
	}
}
body
{
	Program program = new Program();
	
	foreach(path; vertexShaderPaths)
	{
		char[] source = LoadShader(path.toString());
		auto shader = new VertexShader(source);
		shader.Compile();
		program.AttachShader(shader);
	}
	
	foreach(path; fragmentShaderPaths)
	{
		char[] source = LoadShader(path.toString());
		auto shader = new FragmentShader(source);
		shader.Compile();
		program.AttachShader(shader);
	}
	
	if(geometryShaderPaths != null)
	{
		foreach(path; geometryShaderPaths)
		{
			char[] source = LoadShader(path.toString());
			auto shader = new GeometryShader(source);
			shader.Compile();
			program.AttachShader(shader);
		}
	}
	
	program.Link();
	
	auto uniforms = getUniforms(program);
	foreach(uniform; uniforms)
	{
		program.Uniforms.add(uniform.name, uniform);
	}
	
	auto attributes = getAttributes(program);
	foreach(attribute; attributes)
	{
		program.Attributes.add(attribute.name, attribute);
	}
	
	return program;
}

ProgramAttribute[] getAttributes(Program p)
in
{
	assert(p !is null);
}
out(res)
{
	assert(res.length != 0);
}
body
{
	uint activeAttributes = p.getParam(GL_ACTIVE_ATTRIBUTES);
	int bufSize = p.getParam(GL_ACTIVE_ATTRIBUTE_MAX_LENGTH);
	auto attributes = new ProgramAttribute[activeAttributes];

	int length;
	int size;
	uint type;
	char* cname;
	for(uint i = 0; i < activeAttributes; i++)
	{
		glGetActiveAttrib(p.object, i, bufSize, &length, &size, &type, cname);
		auto error = glGetError();
		assert(error != GL_INVALID_VALUE);
		Stdout(error);
		char[] name = fromStringz(cname);
		attributes[i] = new ProgramAttribute(i, name, cast(ShaderVariable) type);
		/+
		switch(var)
		{
			case ShaderVariable.Vector3:
				attributes[i] = new AttributeVector3(i, name);
				break;
			default:
				throw new IllegalArgumentException("Wrong argument for attribute type");
		}
		+/
	}
	
	return attributes;
}
/+
UniformSampler[] getUniforms(Program p)
in
{
	assert(p !is null);
}
out(res)
{
	assert(res.length != 0);
}
body
{
	uint activeUniforms = p.getParam(GL_ACTIVE_UNIFORMS);
	auto uniforms = new ProgramUniform[activeUniforms];
	char** names;
	
	uint[] uniformIndices;
	int[] params;
	glGetUniformIndices(p.object, activeUniforms, names, uniformIndices.ptr);
	glGetActiveUniformsiv(p.object, uniformIndices.length, uniformIndices.ptr, GL_UNIFORM_TYPE, params.ptr);
	
	for(uint i = 0; i < uniformIndices.length; i++)
	{
		char[] name = fromStringz(names[i]);
		ShaderVariable var = cast(ShaderVariable) params[i];
		uniforms[i] = new ProgramUniform(i, name, var);
	}
	
	return uniforms;
}+/
+/