module resources.Camera;

import math.Vector;
import math.Matrix;
import math.Quaternion;

class Camera(T)
{
	alias Matrix!(T, 4, 4) matrix;
	alias Vector!(T, 3) vector;
	alias Quaternion!(T) quaternion;
	
	private matrix view;
	
	public void position(vector value)
	{
		this.view.m14 = value.x;
		this.view.m24 = value.y;
		this.view.m34 = value.z;
	}
	public vector position()
	{
		return vector(0,0,0);
	}
	
	public this(vector position, vector target, vector up)
	{
		this.view = matrix.createViewMatrix(position, target, up);
	}
	
	public void rotate(T angle, vector axis)
	{
		quaternion temp = quaternion.createFromAxisAngle(axis, angle);
		quaternion quatView = quaternion(view.m41, view.m42, view.m43, 0);
		quaternion transform = temp * quatView * temp.conjugate;
		this.view.m41 = transform.x;
		this.view.m42 = transform.y;
		this.view.m43 = transform.z;
	}
	
	public void move(vector direction)
	{
		this.position += direction;
	}
}