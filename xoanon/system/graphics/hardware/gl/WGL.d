module xoanon.system.graphics.hardware.gl.WGL;

import tango.io.Stdout;
import tango.stdc.stringz;
import derelict.util.exception;
import derelict.util.loader;
import derelict.util.wintypes;

package void wglBindFunc(void** ptr, char[] funcName, SharedLib lib)
{
    void *func = wglGetProcAddress(toStringz(funcName));
    if(!func)
    {
    	Stdout("dudu").newline();
    	Derelict_HandleMissingProc(lib.name, funcName);
    }
    else
        *ptr = func;
}
/+
package struct wglBinder(T) 
{
    void opCall(char[] n, SharedLib lib) 
    {
        *fptr = wglGetProcAddress(lib, n);
    }
    
    private 
    {
        void** fptr;
    }
}


template wglBindFunc(T) 
{
    wglBinder!(T) wglBindFunc(inout T a) 
    {
        wglBinder!(T) res;
        res.fptr = cast(void**)&a;
        return res;
    }
}
+/
extern(Windows)
{
    // WGL functions
     BOOL function(void*,void*) wglCopyContext;
     void* function(void*) wglCreateContext;
     void* function(void*,int) wglCreateLayerContext;
     BOOL function(void*) wglDeleteContext;
     BOOL function(void*,int,int,UINT,LAYERPLANEDESCRIPTOR*) wglDescribeLayerPlane;
     void* function() wglGetCurrentContext;
     void* function() wglGetCurrentDC;
     int function(void*,int,int,int,COLORREF*) wglGetLayerPaletteEntries;
     FARPROC function(LPCSTR) wglGetProcAddress;
     BOOL function(void*,void*) wglMakeCurrent;
     BOOL function(void*,int,BOOL) wglRealizeLayerPalette;
     int function(void*,int,int,int,COLORREF*) wglSetLayerPaletteEntries;
     BOOL function(void*,void*) wglShareLists;
     BOOL function(void*,UINT) wglSwapLayerBuffers;
     BOOL function(void*,DWORD,DWORD,DWORD) wglUseFontBitmapsA;
     BOOL function(void*,DWORD,DWORD,DWORD,FLOAT,FLOAT,int,GLYPHMETRICSFLOAT*) wglUseFontOutlinesA;
     BOOL function(void*,DWORD,DWORD,DWORD) wglUseFontBitmapsW;
     BOOL function(void*,DWORD,DWORD,DWORD,FLOAT,FLOAT,int,GLYPHMETRICSFLOAT*) wglUseFontOutlinesW;

    alias wglUseFontBitmapsA    wglUseFontBitmaps;
    alias wglUseFontOutlinesA   wglUseFontOutlines;
} // extern(Windows)

public void loadPlatformGL(SharedLib lib)
{
	bindFunc(wglCopyContext)("wglCopyContext", lib);
    bindFunc(wglCreateContext)("wglCreateContext", lib);
    bindFunc(wglCreateLayerContext)("wglCreateLayerContext", lib);
    bindFunc(wglDeleteContext)("wglDeleteContext", lib);
    bindFunc(wglDescribeLayerPlane)("wglDescribeLayerPlane", lib);
    bindFunc(wglGetCurrentContext)("wglGetCurrentContext", lib);
    bindFunc(wglGetCurrentDC)("wglGetCurrentDC", lib);
    bindFunc(wglGetLayerPaletteEntries)("wglGetLayerPaletteEntries", lib);
    bindFunc(wglGetProcAddress)("wglGetProcAddress", lib);
    bindFunc(wglMakeCurrent)("wglMakeCurrent", lib);
    bindFunc(wglRealizeLayerPalette)("wglRealizeLayerPalette", lib);
    bindFunc(wglSetLayerPaletteEntries)("wglSetLayerPaletteEntries", lib);
    bindFunc(wglShareLists)("wglShareLists", lib);
    bindFunc(wglSwapLayerBuffers)("wglSwapLayerBuffers", lib);
    bindFunc(wglUseFontBitmapsA)("wglUseFontBitmapsA", lib);
    bindFunc(wglUseFontOutlinesA)("wglUseFontOutlinesA", lib);
    bindFunc(wglUseFontBitmapsW)("wglUseFontBitmapsW", lib);
    bindFunc(wglUseFontOutlinesW)("wglUseFontOutlinesW", lib);
}
