module xoanon.graphics.hardware.Viewport;

struct Viewport 
{
	///The x coordinate of the lower-left corner. 
	public uint X;
	///The y coordinate of the lower-left corner.
	public uint Y;
	///The width of the viewport.
	public uint Width;
	///The height of the viewport.
	public uint Height;

	public Vector!(T, 3) Project(T)(Vector!(T, 3) position,)
	{
		//TODO
	}
	
	public Vector!(T, 3) Unproject(T)(Vector!(T, 3) position,)
	{
		//TODO
	}

	public double Near;
	public double Far;
}
