module xoanon.scene.Camera;

import xoanon.scene.Scene;
import xoanon.core.math.Vector;
import xoanon.core.math.Matrix;

class CameraNode : SceneNode
{
	public this()
	{
		super();
		type = "CameraNode";
	}
	
	alias Vector!(float, 3) vector;
	alias Matrix!(float, 4, 4) matrix;
	
	vector target;
	vector up;
	
	public float horizontalAngle;
	public float width, height;
	public float nearPlane, farPlane;
	
	public matrix view()
	{
		return matrix.createViewmatrix(this.transform.position, this.target, this.up);
	}
	
	public matrix projection()
	{
		return matrix.createPerspectiveProjectionmatrix(horizontalAngle, width / height, nearPlane, farPlane);
	}
}