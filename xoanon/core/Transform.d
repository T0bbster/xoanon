module xoanon.core.Transform;

import xoanon.core.math.Matrix;
import xoanon.core.math.Quaternion;
import xoanon.core.math.Vector;

class Transformation
{
	public this()
	{
		this._position = Vector3f.zero;
		this._rotation = quaternion.identity;
	}
	
	bool changed = false;
	
	alias Quaternion!(float) quaternion;
	private quaternion _rotation;
	
	public void rotation(quaternion value)
	{
		this._rotation = value;
		changed = true;
	}
	public quaternion rotation()
	{
		return this._rotation;
	}
	
	private Vector3f _position;
	
	public Vector3f position(Vector3f value)
	{
		changed = true;
		return this._position = value;
	}
	public Vector3f position()
	{
		return this._position;
	}
	
	public void setMatrix(Matrix4f matrix)
	{/+
		this._rotation.setMatrix(matrix);
		this._position = matrix.column4;+/
		//TODO
	}
	
	public Matrix4f toMatrix()
	{
		Matrix4f res = _rotation.toMatrix();
		res.m14 = _position.x;
		res.m24 = _position.y;
		res.m34 = _position.z;
		changed = false;
		return res;
	}
}