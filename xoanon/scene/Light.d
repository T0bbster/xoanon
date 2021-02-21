module xoanon.scene.Light;

import xoanon.core.math.Vector;
import xoanon.scene.Scene;
import xoanon.core.Color;
import xoanon.content.Effect;

class LightNode : SceneNode
{
	public Light light;
	
	public this()
	{
		type = "LightNode";
	}
}

abstract class Light
{
	public Colorf color;
	public float intenstity;
}

class LightEffect : Effect
{
	Light light;
	
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

class PointLight : Light
{
}

class SpotLight
{
	public Vector3f direction;
	
}