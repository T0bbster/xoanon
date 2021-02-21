module xoanon.math.Plane;

import xoanon.math.Vector;

struct Plane(T)
{
	union
	{
		private Vector!(T, 4) vector;
		struct
		{
			union
			{
				Vector!(T, 3) normal;
				T a, b, c;
			}
			T d;
		}
	}
	
	public this(Vector!(T, 3) normal, T d)
	{
		this.normal = normal;
		this.d = d;
	}
	
	public override void opAssign(Vector!(T, 4) vector)
	{
		this.vector = vector;
	}
	
	public void normalize()
	{
		this.vector.normalize();
	}
}