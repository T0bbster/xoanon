module xoanon.system.graphics.hardware.RenderState;

import xoanon.system.graphics.hardware.MultiSampling;
import xoanon.system.graphics.hardware.gl.GL3;
import xoanon.system.graphics.hardware.Points;
import xoanon.system.graphics.hardware.Polygons;
import xoanon.system.graphics.hardware.PrimitiveRestarting;
import xoanon.system.graphics.hardware.Viewport;
import xoanon.system.graphics.hardware.Culling;
import xoanon.system.graphics.hardware.Hint;
import xoanon.system.graphics.hardware.Lines;


struct RenderState
{
	public PrimitiveRestarting primitiveRestart;
	
	enum ProvokeMode : GLenum
	{
		FirstVertex = GL_FIRST_VERTEX_CONVENTION,
		LastVertex	= GL_LAST_VERTEX_CONVENTION
	}
	
	private ProvokeMode provokeMode = ProvokeMode.LastVertex;
	public void flatshadingProvokingVertex(ProvokeMode mode)
	{
		glProvokingVertex(mode);
		provokeMode = mode;
	}
	public ProvokeMode flatshadingProvokingVertex()
	{
		return provokeMode;
	}
	
	private Viewport viewport;
	public void viewPort(Viewport value)
	{
		glViewport(value.X, value.Y, value.Width, value.Height);
		glDepthRange(value.Near, value.Far);
		viewport = value;
	}
	public Viewport viewPort()
	{
		return viewport;
	}
	
	MultiSampling multiSampling;
	Points points;
	Lines lines;
	Polygons polygons;
	Culling culling;
	
	//TODO
/+
  private PrimitiveDiscarding ;

  private MultiSampling ;

  private Points ;

  private Lines lines;

  private Polygons ;

  private PixelStorageMode ;

  private ScissorTest ;

  private StencilBuffer ;

  private DepthBuffer ;

  private Dithering ;

  private Blending ;

  private ColorBuffer ;

  	private LogicalOperation ;
  	+/
  	private Hint compressionQuality;
  	public void textureCompressionQuality(Hint value)
  	{
  		glHint(GL_TEXTURE_COMPRESSION_HINT, value);
  		compressionQuality = value;
  	}
  	public Hint textureCompressionQuality()
  	{
  		return compressionQuality;
  	}

  	
  	private Hint fsShaderAccuracy;
  	public void fragmentShaderFunctionAccuracy(Hint value)
  	{
  		glHint(GL_FRAGMENT_SHADER_DERIVATIVE_HINT, value);
  		fsShaderAccuracy = value;
  	}
  	public Hint fragmentShaderFunctionAccuracy()
  	{
  		return fsShaderAccuracy;
  	}
}
