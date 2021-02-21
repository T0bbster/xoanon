module graphics.hardware.Points;

import xoanon.system.graphics.hardware.gl.GL3;

struct Points
{
	private float size = 1.0;
	public void pointSize(float value)
	{
		glPointSize(value);
		size = value;
	}
	public float pointSize()
	{
		return size;
	}
	
	public void enableInShader()
	{
		glEnable(GL_PROGRAM_POINT_SIZE);
	}
	public void disableInShader()
	{
		glDisable(GL_PROGRAM_POINT_SIZE);
	}
	
	private float treshold;
	public void pointFadeTreshold(float value)
	{
		glPointParameterf(GL_POINT_FADE_THRESHOLD_SIZE, value);
		treshold = value;
	}
	public float pointFadeTreshold()
	{
		return treshold;
	}
	
	enum CoordOrigin
	{
		LowerLeft = GL_LOWER_LEFT,
		UpperLeft = GL_UPPER_LEFT
	}
	private CoordOrigin coordOrigin = CoordOrigin.UpperLeft;
	
	public void pointSpriteCoordOrigin(CoordOrigin value)
	{
		glPointParameteri(GL_POINT_SPRITE_COORD_ORIGIN, value);
		coordOrigin = value;
	}
	public CoordOrigin pointSpriteCoordOrigin()
	{
		return coordOrigin;
	}
}