module graphics.hardware.Lines;

import xoanon.system.graphics.hardware.gl.GL3;
import xoanon.system.graphics.hardware.Hint;

struct Lines 
{
	private float width = 1.0;
	public void lineWidth(float value)
	{
		glLineWidth(value);
		width = value;
	}
	public float lineWidth()
	{
		return width;
	}
	
	private Hint quality;
	public void samplingQuality(Hint value)
	{
		glHint(GL_LINE_SMOOTH_HINT, value);
		quality = value;
	}
	public Hint samplingQuality()
	{
		return quality;
	}

	public void enableAntialiasing()
	{
		glEnable(GL_LINE_SMOOTH);
	}
	public void disableAntialiasing()
	{
		glDisable(GL_LINE_SMOOTH);
	}
}