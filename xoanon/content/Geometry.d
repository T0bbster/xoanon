module xoanon.content.Geometry;

import xoanon.content.Effect;

interface IGeometry
{
	bool changed();
	void changed(bool changed);
}

interface IPrimitive
{
	
}

class GeometryEffect : Effect
{
	IGeometry geometry;
	
	override void begin()
	{
	}
	
	override void process()
	{
	}
	
	override void end()
	{
	}
}