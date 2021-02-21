module xoanon.core.math.Matrix;

import tango.io.Stdout;
import tango.math.Math;
import xoanon.core.math.Vector;

private template tElements(T, int m, int n)
{
	static if(n == 0 && m == 0)
	{
	}
	static if(m >= 1)
	{
		static if(n >= 1)
			public T m11;
		static if(n >= 2)
			public T m12;
		static if(n >= 3)
			public T m13;
		static if(n >= 4)
			public T m14;
	}
	static if(m >= 2)
	{
		static if(n >= 1)
			public T m21;
		static if(n >= 2)
			public T m22;
		static if(n >= 3)
			public T m23;
		static if(n >= 4)
			public T m24;
	}
	static if(m >= 3)
	{
		static if(n >= 1)
			public T m31;
		static if(n >= 2)
			public T m32;
		static if(n >= 3)
			public T m33;
		static if(n >= 4)
			public T m34;
	}
	static if(m >= 4)
	{
		static if(n >= 1)
			public T m41;
		static if(n >= 2)
			public T m42;
		static if(n >= 3)
			public T m43;
		static if(n >= 4)
			public T m44;
	}
}

private template tcolumnVectors(T, int m, int n)
{
	alias Vector!(T, m) vector;
	
	static if(n == 0 && m == 0)
	{	
	}
	static if(n >= 1)
		public vector column1;
	static if(n >= 2)
		public vector column2;
	static if(n >= 3)
		public vector column3;
	static if(n >= 4)
		public vector column4;
}

private template tRowVectors(T, int m, int n)
{
	alias Vector!(T, n) vector;
	
	static if(n == 0 && m == 0)
	{	
	}
	static if(m >= 1)
		public vector row1;
	static if(m >= 2)
		public vector row2;
	static if(m >= 3)
		public vector row3;
	static if(m >= 4)
		public vector row4;
}

private template tMatrix(T, int m, int n, alias type)
{
	alias type matrix;
	alias Vector!(T, n) rowVec;
	alias Vector!(T, m) columnVec;
	union
	{
			private T[n][m] mat;
			private T[n*m] array;
			//private columnVec[n] columns;
			private rowVec[m] rows;
		
		
		struct
		{
			public mixin tElements!(T, m, n);
		}
		
		struct
		{
			//TODO public mixin tColumnVectors!(T, m, n);
		}
		struct
		{
			public mixin tRowVectors!(T, m, n);
		}
		
	}
	
	/**
	 * creates a new matrix.
	 * Params:
	 *     elements = The elements of the matrix.
	 * Returns:
	 * The new matrix.
	 * Remarks:
	 * The length of the elements must be smaller or equal t.
	 */
	public static matrix opCall(T[] elements...)
	in
	{
		assert(elements.length <= this.array.length);
	}
	body
	{
		matrix res;
		res.array[0 .. elements.length] = elements[];
		return res;
	}
	/+
	/**
	 * creates a new matrix.
	 * Params:
	 *     columns = The column vectors of the matrix.
	 * Returns:
	 * The new matrix.
	 * Remarks:
	 * The length of the columns must be smaller or equal t.
	 */
	public static matrix opCall(Vector!(T, i)[] columns...)
	in
	{
		assert(columns.length <= j);
	}
	body
	{
		matrix res;
		res.columns[0 .. columns.length] = columns[];
		return res;
	}
	
	public matrix opAdd(matrix other)
	{
		matrix res;
		res.array[] = this.array[] + other.array[];
		return res;
	}
	+/
	public matrix opAdd(T other)
	{
		matrix res;
		res.array[] = this.array[] + other;
		return res;
	}
	
	public void opAddAssign(matrix other)
	{
		this.array[] += other.array[];
	}
	
	public void opAddAssign(T other)
	{
		this.array[] += other;
	}
	
	public matrix opSub(matrix other)
	{
		matrix res;
		res.array[] = this.array[] - other.array[];
		return res;
	}
	
	public matrix opSub(T other)
	{
		matrix res;
		res.array[] = this.array[] - other;
		return res;
	}
	
	public void opSubAssign(matrix other)
	{
		this.array[] -= other.array[];
	}
	
	public void opSubAssign(T other)
	{
		this.array[] -= other;
	}
	
	public matrix opMul(T other)
	{
		matrix res;
		res.array[] = this.array[] * other;
		return res;
	}
	
	public void opMulAssign(T other)
	{
		this.array[] *= other;
	}
	
	public matrix opDiv(T other)
	{
		matrix res;
		res.array[] = this.array[] * other;
		return res;
	}
	
	public void opDivAssign(T other)
	{
		this.array[] /= other;
	}
	
	/**
	 * Converts the matrix to an array.
	 * Returns:
	 * The matrix as an array.
	 */
	public T[] toArray()
	{
		return this.array.dup;
	}
	
	/**
	 * Converts the matrix to a rectangular array.
	 * Returns:
	 * The matrix as a rectangular array.
	 */
	public T[][] toRectangularArray()
	{
		T[][] temp = void;
		for(size_t x = 0; x < n; x++)
		{
			temp[x] = new T[m];
			/*for(size_t y = 0; y < j; y++)
			{
				temp[x][y] = this.mat[x][y];
			}*/
			temp[x] = this.mat[x].dup;
		}
		return temp;
	}
	
	public void print()
	{
		for(size_t x = 0; x < m; x++)
			Stdout(this.mat[x]).newline;
		Stdout.newline;
	}
}


struct Matrix(T, int m, int n)
{
	mixin tMatrix!(T, m, n, Matrix);
	
	public Matrix!(T, m, b) opMul(int a, int b)(Matrix!(T, a, b) other)
	in
	{
		assert(n == a);
	}
	body
	{
		Matrix!(T, m, b) res;
		for(size_t x = 0; x < m; x++)
		{
			for(size_t y = 0; y < b; y++)
			{
				res.mat[x][y] = cast(T) 0;
				for(size_t k = 0; k < a; k++)
				{
					res.mat[x][y] += this.mat[x][k] * other.mat[k][y];
				}
			}
		}
		return res;
	}
	
	static if(n == m)
	{
		const
		{
			public static matrix identity;
		}
		
		static this()
		{
			identity = createIdentity();
		}
		private static matrix createIdentity()
		{
			matrix res;
			res.array[] = cast(T) 0;
			for(size_t x = 0; x < m; x++)
				res.mat[x][x] = cast(T) 1;
			return res;
		}
		
		/// Transposes the matrix.
		public void transpose()
		{
			//TODO
			/+
			auto temp = this.rows[];
			Stdout(temp.length);
			this.columns[] = temp[];
			+/
		}
		
		/**
		 * Calculates the trace.
		 * Returns:
		 * The trace of the matrix.
		 */
		public T Trace()
		{
			T res = cast(T) 0;
			for(size_t x = 0; x < m; x++)
				res += this.mat[x][x];
			return res;
		}
		
		static if(n == 4)
		{
			/**
			 * Creates a perspective projection matrix based on a field of view.
			 * Params:
			 *     fieldOfViewY = The angle in radians in y-direction.
			 *     aspectRatio = The ratio of the witdh to the height.
			 *     nearPlaneDistance = The Distance to the near plane.
			 *     farPlaneDistance = The Distance to the far plane.
			 * Returns:
			 * The created perspective projection matrix.
			 */
			public static matrix createPerspectiveProjectionmatrix(T fieldOfViewY, T aspectRatio, T nearPlaneDistance, T farPlaneDistance)
			in
			{
				assert(nearPlaneDistance > 0f);
				assert(farPlaneDistance > 0f);
			}
			body
			{
				matrix res;
				res.array[] = cast(T) 0;
				T f = 1 / tan(fieldOfViewY * 0.5);
				res.m11 = f / aspectRatio;
				res.m22 = f;
				T x = nearPlaneDistance - farPlaneDistance;
				res.m33 = (farPlaneDistance + nearPlaneDistance) / x;
				res.m34 = (2 * farPlaneDistance * nearPlaneDistance) / x;
				res.m43 = -1;
				return res;
			}
			
			public static matrix createViewmatrix(Vector!(T, 3) cameraPos, Vector!(T, 3) cameraLookAt, Vector!(T, 3) cameraUp)
			/+in
			{
				assert(cameraUp.squaredLength == 1);
			}
			body+/
			{
				Vector!(T, 3) backward = (cameraPos - cameraLookAt).normalized;
				Vector!(T, 3) right = (cameraUp % backward).normalized;
				cameraUp = backward % right;
				
				matrix res = matrix(right.x, cameraUp.x, backward.x, -Vector!(T, 3).dot(right, cameraPos),
									right.y, cameraUp.y, backward.y, -Vector!(T, 3).dot(cameraUp, cameraPos),
									right.z, cameraUp.z, backward.z, -Vector!(T, 3).dot(backward, cameraPos),
									0f,		0f,		 	0f,		 	 1f);
				return res;
			}
			
			/**
			 * Creates a translation matrix.
			 * Params:
			 *     x = The value to translate by on the x-axis.
			 *     y = The value to translate by on the y-axis.
			 *     z = The value to translate by on the z-axis.
			 * Returns:
			 * The created translation matrix.
			 */
			public static matrix createTranslation(Vector!(T, 3) position)
			in
			{
				assert(position.x != T.nan);
				assert(position.y != T.nan);
				assert(position.z != T.nan);
			}
			body
			{
				matrix res = matrix.identity;
				res.m14 = position.x;
				res.m24 = position.y;
				res.m34 = position.z;
				return res;
			}

			/**
			 * Creates a rotation matrix around the x-axis.
			 * Params:
			 *     angle = The angle in radians to rotate.
			 * Returns:
			 * The created rotation matrix.
			 */
			public static matrix createRotationX(T angle)
			in
			{
				assert(angle != T.nan);
			}
			body
			{
				matrix res = matrix.identity;
				T cosAngle = cos(angle);
				T sinAngle = sin(angle);
				
				res.m22 = cosAngle;
				res.m23 = -sinAngle;
				res.m32 = sinAngle;
				res.m33 = cosAngle;
				return res;
			}

			/**
			 * Creates a rotation matrix around the y-axis.
			 * Params:
			 *     angle = The angle in radians to rotate.
			 * Returns:
			 * The created rotation matrix.
			 */
			public static matrix createRotationY(T angle)
			in
			{
				assert(angle != T.nan);
			}
			body
			{
				matrix res = matrix.identity;
				T cosAngle = cos(angle);
				T sinAngle = sin(angle);
				
				res.m11 = cosAngle;
				res.m13 = sinAngle;
				res.m31 = -sinAngle;
				res.m33 = cosAngle;
				return res;
			}

			/**
			 * creates a rotation matrix around the z-axis.
			 * Params:
			 *     angle = The angle in radians to rotate.
			 * Returns:
			 * The created rotation matrix.
			 */
			public static matrix createRotationZ(T angle)
			in
			{
				assert(angle != T.nan);
			}
			body
			{
				matrix res = matrix.identity;
				T cosAngle = cos(angle);
				T sinAngle = sin(angle);
				
				res.m11 = cosAngle;
				res.m12 = -sinAngle;
				res.m21 = sinAngle;
				res.m22 = cosAngle;
				return res;
			}
		}
	}
}

alias Matrix!(float, 4, 4) Matrix4f;

unittest
{
	Random r = new Random();
	alias Matrix!(float, 4, 4) Mat4f;
	Mat4f[] matrices = new Mat4f[size];
	
	StopWatch watch;
	watch.start();
	foreach(ref mat; matrices)
	{
		mat = Mat4f(r.uniformR2(-10_000, 10_000), r.uniformR2(-10_000, 10_000), r.uniformR2(-10_000, 10_000), r.uniformR2(-10_000, 10_000),
					r.uniformR2(-10_000, 10_000), r.uniformR2(-10_000, 10_000), r.uniformR2(-10_000, 10_000), r.uniformR2(-10_000, 10_000),
					r.uniformR2(-10_000, 10_000), r.uniformR2(-10_000, 10_000), r.uniformR2(-10_000, 10_000), r.uniformR2(-10_000, 10_000),
					r.uniformR2(-10_000, 10_000), r.uniformR2(-10_000, 10_000), r.uniformR2(-10_000, 10_000), r.uniformR2(-10_000, 10_000));
	}
	Stdout(watch.microsec()).newline();
	
	watch.stop();
	
	watch.start();
	size_t i = 0;
	do
	{
		(matrices[i] * matrices[i+1]);
		i++;
	}
	while(i < size-1);
	watch.stop();
	Stdout(watch.microsec()).newline();
	Stdout(watch.microsec() / cast(double)size).newline();
}
