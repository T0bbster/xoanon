module xoanon.system.graphics.renderer.Renderer;

import xoanon.system.graphics.hardware.gl.GL3types;
import xoanon.system.graphics.hardware.GraphicsDevice;
import xoanon.system.graphics.hardware.gl.GL3functions;
import tango.io.Stdout;
import tango.time.StopWatch;
import tango.util.container.HashMap;
import tango.util.container.HashSet;
import xoanon.content.ContentManager;
import xoanon.content.Effect;
import xoanon.content.Geometry;
import xoanon.content.Material;
import xoanon.content.Mesh;
import xoanon.system.graphics.hardware.BufferObject;
import xoanon.scene.Light;
import xoanon.scene.Scene;
import xoanon.scene.Camera;
import xoanon.scene.Form;
import derelict.sdl.sdlfuncs;

abstract class Renderer
{
	private SceneNode _root;
	
	public void root(SceneNode root)
	{
		this._root = root;
	}
	
	public abstract void render();
}


class GLRenderer : Renderer
{
	GraphicsDevice device;
	
	private FormNode[] formNodes;
	private LightNode[] lightNodes;
	private CameraNode[] cameraNodes;
	
	private HashSet!(Form) forms;
	private BufferManager bufferManager;
	public HashMap!(IMaterial, CompiledMaterialEffect) effects;
	
	public this()
	{
		this.device = new GraphicsDevice();
		this.device.renderState.culling.enable();
		
		glEnable(GL_DEPTH_TEST);
		glDepthFunc(GL_LEQUAL);
		
		this.bufferManager = new BufferManager();
		this.effects = new HashMap!(IMaterial, CompiledMaterialEffect);
		this.forms = new HashSet!(Form);
	}
	
	override void root(SceneNode root)
	{
		super.root(root);
	}
	
	private void updateTransform()
	{
		void loop(SceneNode node)
		{
			foreach(ref SceneNode child; node.children)
			{
				if(child.transform.changed)
				{
					assert(child.parent !is null);
					child.world = child.parent.world * child.transform.toMatrix;
				}
				loop(child);
			}
		}
		//if(_root.transform.changed)
			_root.world = _root.transform.toMatrix();
		loop(_root);
	}
	
	private void getNodeTypes()
	{
		void loop(SceneNode node)
		{
			if(!node.children.isEmpty)
			{
				foreach(ref child; node.children)
				{
					switch(child.type)
					{
						case "SceneNode":
							break;
						case "FormNode":
							formNodes ~= cast(FormNode) child;
							break;
						case "CameraNode":
							cameraNodes ~= cast(CameraNode) child;
							break;
						case "LightNode":
							lightNodes ~= cast(LightNode) child;
							break;
						default:
							break;
					}
					loop(child);
				}
			}
		}
		loop(_root);
	}
	
	public void render()
	{
		device.clear(ClearTarget.ColorBuffer | ClearTarget.DepthBuffer);
		
		
		debug
		{
			StopWatch watch;
			watch.start();

		}

		updateTransform();
		
		debug
		{
			Stdout.formatln("time transform: {}", watch.microsec);
			watch.start;
		}
		getNodeTypes();
		debug
		{
			Stdout.formatln("time nodeTypes: {}", watch.microsec);
			watch.start();
		}
		
		
		CompiledMaterial lastMaterial = null;
		Mesh lastMesh = null;
		CompiledMaterialEffect lastEffect;
		
		foreach(ref node; formNodes)
		{
			Mesh mesh = cast(Mesh) node.form.geometry;
			//Geometry
			if(mesh)
			{
				if(mesh != lastMesh)
				{
					if(node.form.geometry.changed)
						bufferManager.addMesh(mesh);
					bufferManager.use(mesh);
					lastMesh = mesh;
				}
			}
			//Material
			if(auto material = cast(CompiledMaterial) node.form.material)
			{
					if(material in effects)
					{
						auto effect = effects[material];
						if(effect != lastEffect)
						{
							if(cameraNodes != null)
								effect.camera = cameraNodes[0];
							
							effect.material = material;
							effect.mesh = mesh;
							effect.formNode = node;
							effect.use();
							effect.begin();
							effect.process();
							device.drawIndexedPrimitives(mesh.type, bufferManager.indexBuffer(mesh)); 
							effect.end();
							
							lastEffect = effect;
						}
						else
						{
							if(cameraNodes != null)
								lastEffect.camera = cameraNodes[0];
							
							lastEffect.material = material;
							lastEffect.mesh = mesh;
							lastEffect.formNode = node;
							lastEffect.begin();
							lastEffect.process();
							device.drawIndexedPrimitives(mesh.type, bufferManager.indexBuffer(mesh)); 
							lastEffect.end();
						}
						
						/+
						if(cameraNodes != null)
							effects[material].camera = cameraNodes[0];
						effects[material].material = material;
						auto mesh = cast(Mesh) node.form.geometry;
						effects[material].mesh = mesh;
						effects[material].formNode = node;
						effects[material].begin();
						effects[material].process();
						device.drawIndexedPrimitives(mesh.type, bufferManager.indexBuffer(mesh)); 
						effects[material].end();+/
					}
				
				
			}
		}
		
		debug
		{
			Stdout.formatln("time render: {}", watch.microsec);
			watch.stop();
		}
		
		this.formNodes = null;
		this.cameraNodes = null;
		this.lightNodes = null;
		
		SDL_GL_SwapBuffers();
	}
}
