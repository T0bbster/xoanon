module xoanon.graphics.ViewFrustum;

import xoanon.math.Plane;
import xoanon.math.Matrix;

class ViewFrustum(T)
{
	enum
	{
		Left, Right, Bottom, Top, Near, Far
	}
	
	Plane!(T)[6] planes;
	
	public void calculate(T)(Matrix!(T, 4, 4) projection, Matrix!(T, 4, 4) view)
	{
		Matrix!(T, 4, 4) composite = projection * view;
		
		with(composite)
		{
			planes[Left]	= (row4 - row1).normalize;
			planes[Right]  	= (row4 + row1).normalize;
			planes[Bottom] 	= (row4 - row2).normalize;
			planes[Top] 	= (row4 + row2).normalize;
			planes[Near] 	= (row4 - row3).normalize;
			planes[Far]		= (row4 + row3).normalize;
		}
	}
}