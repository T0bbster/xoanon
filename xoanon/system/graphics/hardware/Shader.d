module xoanon.system.graphics.hardware.Shader;

import xoanon.system.graphics.hardware.gl.GL3;
import tango.io.FilePath;
import tango.stdc.stringz;

/// The type of the shader.
enum ShaderType 
{
	VertexShader = GL_VERTEX_SHADER,
	FragmentShader = GL_FRAGMENT_SHADER,
	GeometryShader = GL_GEOMETRY_SHADER
}

/// A class which handles GLSL source code.
class Shader 
{
	/// The object of the shader.
	package uint object;
	/// The source code of the shader.
	package char[] source;
	
	/**
	 * Creates a new Shader.
	 * Params:
	 *     type = The type of the shader.
	 *     source = The source code of the shader.
	 */
	public this(ShaderType type, char[] source)
	in
	{
		assert(source !is null);
	}
	body
	{
		this.source = source;
		this.object = glCreateShader(type);
		char* string = toStringz(this.source);
		glShaderSource(this.object, 1, &string, null);
	}
	
	~this()
	{
		glDeleteShader(this.object);
	}
	
	/// Compiles the shader.
	public void compile() 
	{
		glCompileShader(object);
	}
	
	/**
	 * Checks the compile status of the shader.
	 * Returns: $(D_KEYWORD true) if the shader has been succesfully compiled
	 * 			otherwise $(D_KEYWORD false).
	 */
	public bool compiled()
	{
		return cast(bool) getParam(GL_COMPILE_STATUS);
	}
	
	public char[] getSource()
	{
		return this.source;
	}
	
	package GLint getParam(GLenum param)
	{
		GLint result;
		glGetShaderiv(this.object, param, &result);
		return result;
	}
	
	package char[] getInfoLog()
	{
		uint logLength = getParam(GL_INFO_LOG_LENGTH);
		char* log;
		glGetProgramInfoLog(this.object, logLength, null, log);
		return fromStringz(log);
	}
	
	public override hash_t toHash()
	{
		return this.object;
	}
}

///A class which handles GLSL vertex shader code.
class VertexShader : Shader
{
	/**
	 * Creates a new VertexShader.
	 * Params:
	 *     source = The source code of the shader.
	 */
	this(char[] source)
	{
		super(ShaderType.VertexShader, source);
	}
}

///A class which handles GLSL fragment shader code.
class FragmentShader : Shader
{
	/**
	 * Creates a new FragmentShader.
	 * Params:
	 *     source = The source code of the shader.
	 */
	this(char[] source)
	{
		super(ShaderType.FragmentShader, source);
	}
}

///A class which handles GLSL geometry shader code.
class GeometryShader : Shader
{
	/**
	 * Creates a new GeometryShader.
	 * Params:
	 *     source = The source code of the shader.
	 */
	this(char[] source)
	{
		super(ShaderType.GeometryShader, source);
	}
}
