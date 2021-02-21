module xoanon.system.graphics.hardware.BufferObject;

import tango.core.Exception;
import xoanon.system.graphics.hardware.gl.GL3;

enum BufferTarget : GLenum
{
	Vertex				= GL_ARRAY_BUFFER,
	Index				= GL_ELEMENT_ARRAY_BUFFER,
	Texture				= GL_TEXTURE_BUFFER,
	TransformFeedback	= GL_TRANSFORM_FEEDBACK_BUFFER,
	Uniform				= GL_UNIFORM_BUFFER,
	PixelPack			= GL_PIXEL_PACK_BUFFER,
	PixelUnpack   		= GL_PIXEL_UNPACK_BUFFER
}

enum BufferAccessMode
{
	Read		= GL_MAP_READ_BIT,
	Write		= GL_MAP_WRITE_BIT,
	ReadWrite	= GL_MAP_READ_BIT | GL_MAP_WRITE_BIT
}

enum BufferMapOptions
{
	InvalidateRange = GL_MAP_INVALIDATE_RANGE_BIT,
	InvalidateBuffer = GL_MAP_INVALIDATE_BUFFER_BIT,
	FlushExplicit = GL_MAP_FLUSH_EXPLICIT_BIT,
	Unsynchronized = GL_MAP_UNSYNCHRONIZED_BIT
	
}

enum BufferUsageHint : GLenum
{
	StreamDraw	= GL_STREAM_DRAW,
	StreamRead	= GL_STREAM_READ,
	StreamCopy	= GL_STREAM_COPY,
	StaticDraw	= GL_STATIC_DRAW,
	StaticRead	= GL_STATIC_READ,
	StaticCopy	= GL_STATIC_COPY,
	DynamicDraw	= GL_DYNAMIC_DRAW,
	DynamicRead	= GL_DYNAMIC_READ,
	DynamicCopy	= GL_DYNAMIC_COPY
}

abstract class BufferObject 
{
	public GLenum object;
	protected BufferTarget target;
	
	public size_t length;
	public size_t sizeInBytes;
	
	protected bool bound = false;
	protected bool initialized = false;
	
	public this(BufferTarget target)
	{
		glGenBuffers(1, &this.object);
		this.target = target;
	}
	
	~this()
	{
		glDeleteBuffers(1, &this.object);
	}

	public final void bind()
	{
		glBindBuffer(this.target, this.object);
		this.bound = true;
	}

	public final void unbind()
	{
		glBindBuffer(this.target, 0);
		this.bound = false;
	}

	public final void copyDataToBuffer(BufferObject writeBuffer, int readOffset, int writeOffset, int size) 
	{
		//TODO implement
		throw new NoSuchElementException("Not implemented");
	}
	
	protected void initialize(size_t length, size_t vertexSize, BufferUsageHint usage)
	in
	{
		assert(this.bound);
	}
	body
	{
		this.initialized = true;
		this.length = length;
		this.sizeInBytes = vertexSize * length;
		glBufferData(this.target, this.sizeInBytes, null, usage);
		
	}

	protected void initialize(void[] data, BufferUsageHint usage)
	in
	{
		assert(this.bound);
	}
	body
	{
		this.initialized = true;
		this.length = data.length;
		this.sizeInBytes = data[0].sizeof * data.length;
		glBufferData(this.target, this.sizeInBytes, data.ptr, usage);
	}

	public void setData(void[] data, int offset = 0)
	in
	{
		assert(this.bound);
		assert(this.initialized);
	}
	body
	{
		glBufferSubData(this.target, offset, data[0].sizeof * data.length, data.ptr);
	}

	public BufferPointer map(BufferAccessMode accessMode) 
	in
	{
		assert(this.bound);
		assert(this.initialized);
	}
	out(res)
	{
		assert(res.pointer != null); 
	}
	body
	{
		BufferPointer res = new BufferPointer();
		res.pointer = glMapBuffer(this.target, accessMode);
		res.length = this.sizeInBytes;
		return res;
	}
	
	public bool unmap(BufferAccessMode accessMode)
	in
	{
		assert(this.bound);
		assert(this.initialized);
	}
	out(res)
	{
		assert(res);
	}
	body
	{
		return cast(bool) glUnmapBuffer(accessMode);
	}
	

	public BufferPointer mapRange(ptrdiff_t offset, size_t length, BufferAccessMode accessMode, BufferMapOptions options) 
	in
	{
		assert(this.bound);
		assert(this.initialized);
	}
	out(res)
	{
		assert(res.pointer != null); 
	}
	body
	{
		BufferPointer res = new BufferPointer();
		res.pointer = glMapBufferRange(this.target, offset, length, accessMode | options);
		res.offset = offset;
		res.length = length;
		return res;
	}

	public void flushMappedRange(BufferAccessMode accessMode, BufferPointer pointer)
	in
	{
		assert(this.bound);
		assert(this.initialized);
	}
	body
	{
		glFlushMappedBufferRange(accessMode, pointer.offset, pointer.length);
	}
}

class BufferPointer
{
	protected void* pointer;
	protected size_t offset;
	protected size_t length;
	protected BufferAccessMode accessMode;
	
	public void Increase(size_t size)
	in
	{
		assert(this.pointer.offsetof + size < this.length);
	}
	body
	{
		this.pointer += size;
	}
	
	public void Set(void[] data)
	in
	{
		assert(this.accessMode != BufferAccessMode.Read);
	}
	body
	{
		this.pointer[0 .. data.length] = data.dup;
	}
	
	public void[] Get(size_t count)
	in
	{
		assert(this.accessMode != BufferAccessMode.Write);
		assert(this.pointer.offsetof + count < this.length);
	}
	body
	{
		return this.pointer[0 .. count];
	}

}

class VertexBuffer : BufferObject
{
	public this(void[] data, BufferUsageHint usage)
	{
		super(BufferTarget.Vertex);
		bind();
		super.initialize(data, usage);
	}
	
	public this(size_t length, size_t vertexSize, BufferUsageHint usage)
	{
		super(BufferTarget.Vertex);
		bind();
		super.initialize(length, vertexSize, usage);
	}
}

enum IndexType : GLenum
{
	Ubyte = GL_UNSIGNED_BYTE,
	Ushort = GL_UNSIGNED_SHORT,
	Uint = GL_UNSIGNED_INT
}

class IndexBuffer : BufferObject
{
	package IndexType type;
	
	public this(void[] data, IndexType type, BufferUsageHint usage)
	{
		super(BufferTarget.Index);
		bind();
		super.initialize(data, usage);
		this.type = type;
	}
	
	public this(size_t length, size_t indexSize, BufferUsageHint usage, IndexType type)
	{
		super(BufferTarget.Index);
		bind();
		super.initialize(length, indexSize, usage);
		this.type = type;
	}

	public void Initialize(void[] data, BufferUsageHint usage, IndexType type)
	{
		super.initialize(data, usage);
		this.type = type;
	}
}

//TODO implement other buffers
class UniformBuffer : BufferObject
{
	public this()
	{
		super(BufferTarget.Uniform);
	}
}

class PixelPackBuffer : BufferObject
{
	public this()
	{
		super(BufferTarget.PixelPack);
	}
}

class PixelUnpackBuffer : BufferObject
{
	public this()
	{
		super(BufferTarget.PixelUnpack);
	}
}

class TextureBuffer : BufferObject
{
	public this()
	{
		super(BufferTarget.Texture);
	}
}