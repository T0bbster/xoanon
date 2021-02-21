module xoanon.core.Color;

import xoanon.core.math.Vector;

struct Color(T)
{
	alias Color!(T) color;
	alias Vector!(T, 4) vector;
	
	union
	{
		struct
		{
			T R, G, B, Alpha;
		}
		vector vec;
	}
	
	public static color opCall(T R, T G, T B, T Alpha = 1)
	{
		color res;
		res.R = R;
		res.G = G;
		res.B = B;
		res.Alpha = Alpha;
		return res;
	}
	
	public T[] toArray()
	{
		return this.vec.toArray();
	}
}

alias Color!(float) Colorf;