module xoanon.system.graphics.hardware.PrimitiveType;

import xoanon.system.graphics.hardware.gl.GL3types;

enum PrimitiveType : GLenum
{
	Points			= GL_POINTS,
	LineStrip		= GL_LINE_STRIP,
	LineLoop		= GL_LINE_LOOP,
	Lines			= GL_LINES,
	TriangleStrip	= GL_TRIANGLE_STRIP,
	TriangleFan		= GL_TRIANGLE_FAN,
	Triangles		= GL_TRIANGLES,
	LinesAdjacency			= GL_LINES_ADJACENCY,
	LineStripAdjacency		= GL_LINE_STRIP_ADJACENCY,
	TrianglesAdjacency		= GL_TRIANGLES_ADJACENCY,
	TriangleStripAdjacency	= GL_TRIANGLE_STRIP_ADJACENCY
}
