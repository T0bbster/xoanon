module xoanon.graphics.hardware.Blending;

import xoanon.graphics.hardware.BlendFunctionMode;
import xoanon.base.GL3functions;
import xoanon.base.GL3types;
import xoanon.graphics.hardware.BlendEquationMode;

class Blending 
{
	private Colorf blendColor;
	public void BlendColor(Colorf value)
	{
		glBlendColor(colorf.R, Colorf.G, Colorf.B, Colorf.A);
		this.blendColor = value;
	}
	public Colorf BlendColor()
	{
		return this.blendColor;
	}
	
	private BlendEquationMode blendEquationRGB;
	public BlendEquationMode BlendEquationRGB()
	{
		return this.blendEquationRGB;
	}
	
	private BlendEquationMode blendEquationAlpha;
	public BlendEquationMode BlendEquationAlpha()
	{
		return this.blendEquationAlpha;
	}
	
	private BlendFunctionMode blendFuncSourceRGB;
	public BlendFunctionMode BlendFuncSourceRGB()
	{
		return this.blendFuncSourceRGB;
	}
	
	private BlendFunctionMode blendFuncSourceAlpha;
	public BlendFunctionMode BlendFuncSourceAlpha()
	{
		return this.blendFuncSourceAlpha;
	}
	
	private BlendFunctionMode blendFuncDestRGB;
	public BlendFunctionMode BlendFuncDestRGB()
	{
		return this.blendFuncDestRGB;
	}

	private BlendFunctionMode blendFuncDestAlpha;
	public BlendFunctionMode BlendFuncDestAlpha()
	{
		return this.blendFuncDestAlpha;
	}

	public void Enable()
	{
		glEnable(GL_BLEND);
	}

	public void Disable()
	{
		glDisable(GL_BLEND);
	}

	public void SetEquation(BlendEquationMode mode)
	{
		glBlendEquation(mode);
		this.blendEquationAlpha = mode;
		this.blendEquationRGB = mode;
	}

	public void SetEquation(BlendEquationMode modeRGB, BlendEquationMode modeAlpha)
	{
		glBlendEquationSeparate(modeRGB, modeAlpha);
		this.blendEquationAlpha = modeAlpha;
		this.blendEquationRGB = modeRGB;
	}
	
	public void SetFunction(BlendFunctionMode source, BlendFunctionMode destination)
	{
		glBlendFunc(source, destination);
		this.blendFuncSourceAlpha = source;
		this.blendFuncSourceRGB = source;
		this.blendFuncDestAlpha = destination;
		this.blendFuncDestRGB = destination;
	}

	public void SetFunction(BlendFunctionMode sourceRGB, BlendFunctionMode sourceAlpha, BlendFunctionMode destinationRGB, BlendFunctionMode destinationAlpha)
	{
		glBlendFuncSeparate(sourceRGB, destinationRGB, sourceAlpha, destinationAlpha);
		this.blendFuncSourceAlpha = sourceAlpha;
		this.blendFuncSourceRGB = sourceRGB;
		this.blendFuncDestAlpha = destinationAlpha;
		this.blendFuncDestRGB = destinationRGB;
	}

}
