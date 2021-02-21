module xoanon.system.graphics.hardware.gl.GL3;

public import xoanon.system.graphics.hardware.gl.GL3functions;
public import xoanon.system.graphics.hardware.gl.GL3types;
private import xoanon.system.graphics.hardware.gl.WGL;
private import derelict.util.exception;
private import derelict.util.loader;


GenericLoader OpenGL3;

static this()
{
	OpenGL3.setup("opengl32.dll",
        "libGL.so.2,libGL.so.1,libGL.so",
        "../Frameworks/OpenGL.framework/OpenGL, /Library/Frameworks/OpenGL.framework/OpenGL, /System/Library/Frameworks/OpenGL.framework/OpenGL",
        &loadAll);
}

private void loadAll(SharedLib lib)
{
	loadPlatformGL(lib);
	loadGL3(lib);
}

private
{
    typedef bool function(char[]) ExtensionLoader;
    ExtensionLoader[] loaders;
    bool versionsOnce           = false;
    bool extensionsOnce         = false;
    int numExtensionsLoaded     = 0;

    version(Windows)
    {
        version(DigitalMars)
        {
           pragma(lib, "gdi32.lib");
        }

        extern(Windows) export int GetPixelFormat(void* hdc);
        int currentPixelFormat      = 0;
    }

    bool isLoadRequired()
    {
        version(Windows)
        {
            void* hdc = wglGetCurrentDC();
            if(hdc is null)
                throw new DerelictException("Could not obtain a device context for the current OpenGL context");

            if(0  == currentPixelFormat)
            {
                currentPixelFormat = GetPixelFormat(hdc);
                return true;
            }

            int newFormat = GetPixelFormat(hdc);
            if(0 == newFormat)
                throw new DerelictException("Could not determine current pixel format");

            bool ret = true;
            if(newFormat == currentPixelFormat)
                ret = false;
            currentPixelFormat = newFormat;
            return ret;
        }
        else
            return false;
    }
}

private bool hasValidContext()
{
    version(Windows)
    {
        if(wglGetCurrentContext() is null)
            return false;
    }
    else version(UsingGLX)
    {
        if(glXGetCurrentContext() is null)
            return false;
    }
    else version(darwin)
    {
        if(CGLGetCurrentContext() is null)
            return false;
    }
    else throw new DerelictException("DerelictGL.hasValidContext is unimplemented for this platform");

    return true;
}

public void LoadExtensions()
{
    version(Windows)
    {
        if(!hasValidContext)
            throw new DerelictException("You must create an OpenGL context before attempting to load OpenGL versions later than 1.1");
    }

    if(versionsOnce)
    {
        if(!isLoadRequired())
            return;
    }
    else
    	versionsOnce = true;
    
    loadExtensions();
}

