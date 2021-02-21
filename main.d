module main;

import xoanon.system.graphics.hardware.ProgramUniform;
import xoanon.system.graphics.hardware.Program;
import xoanon.system.graphics.hardware.ProgramAttribute;
import xoanon.system.graphics.hardware.ShaderVariable;
import xoanon.system.graphics.renderer.Renderer;
import tango.io.FileSystem;
import tango.io.Stdout;
import tango.math.Math;
import tango.math.random.Random;
import tango.util.container.HashSet;
import xoanon.content.Material;
import xoanon.content.Mesh;
import xoanon.content.Sphere;
import xoanon.core.Application;
import xoanon.core.Color;
import xoanon.core.Time;
import xoanon.core.Window;
import xoanon.core.math.Matrix;
import xoanon.core.math.Quaternion;
import xoanon.core.math.Vector;
import xoanon.system.graphics.hardware.GraphicsDevice;
import xoanon.input.Keyboard;
import xoanon.input.Mouse;
import xoanon.scene.Camera;
import xoanon.scene.Controller;
import xoanon.scene.Form;
import xoanon.scene.Scene;

void main()
{
	auto app = new MySphereApp();
	app.run();
}

class CameraController : IController
{
	alias Quaternion!(float) quaternion;
	public HashSet!(CameraNode) nodes;
	
	public this()
	{
		this.nodes = new HashSet!(CameraNode);
	}
	
	override void addNode(SceneNode node)
	{
		nodes.add(cast(CameraNode) node);
	}
	
	override void removeNode(SceneNode node)
	{
		nodes.remove(cast(CameraNode) node);
	}
	
	private float speed = 1f;
	private float speedMax = 50f;
	
	private float rotinDirection = 0.3f;
	private float rotUp = 0.01f;
	
	private void rotate(Vector3f axis, float angle, inout Vector3f other)
	{
		quaternion temp = quaternion.createFromAxisAngle(axis, angle);
		quaternion qview = quaternion(other, 0);
		auto result = (temp * qview) * temp.conjugate;
		other = result.vector;
	}
	
	public override void process()
	{ 
		KeyboardState keyboardState = Keyboard.getState();
		MouseState mouseState = Mouse.getState();
		MouseState lastMouseState;
		
		auto factor = GameTime.factor();
		
		if(keyboardState.isKeyDown(Key.Up) || keyboardState.isKeyDown(Key.w))
		{
			foreach(ref node; this.nodes)
			{
				auto direction = (node.target - node.transform.position).normalized();
				node.transform.position = node.transform.position + direction * speed * factor;
				node.target = node.transform.position + direction;
			}
			if(speed < speedMax)
				speed *= 1.05;
			else
				speed = speedMax;
		}
		if(keyboardState.isKeyDown(Key.Down) || keyboardState.isKeyDown(Key.s))
		{
			foreach(ref node; this.nodes)
			{
				auto direction = (node.target - node.transform.position).normalized();
				node.transform.position = node.transform.position + direction * -speed * factor;
				node.target = node.transform.position + direction;
			}
			if(speed > 0)
			{
				speed *= 0.995;
			}
		}
		if(keyboardState.isKeyDown(Key.Left) || keyboardState.isKeyDown(Key.a))
		{
			foreach(ref node; this.nodes)
			{
				auto direction = (node.target - node.transform.position).normalized();
				rotate(direction, -rotinDirection * factor, node.up);
			}
		}
		if(keyboardState.isKeyDown(Key.Right) || keyboardState.isKeyDown(Key.d))
		{	
			foreach(ref node; this.nodes)
			{
				auto direction = (node.target - node.transform.position).normalized();
				rotate(direction, rotinDirection * factor, node.up);
			}
		}
		
		/+
		if(mouseState != lastMouseState)
		{
			Vector2i motion = mouseState.position - lastMouseState.position;
			
			if(motion.x != 0)
			{
				foreach(ref node; this.nodes)
				{
					auto rotation = (node.target - node.transform.position).normalized();
					rotate(node.up, motion.x * rotUp * factor, rotation);
					node.target = rotation + node.transform.position;
				}
			}
			if(motion.y != 0)
			{
				foreach(ref node; this.nodes)
				{
					auto rotation = (node.target - node.transform.position).normalized();
					rotate(node.up, motion.y * rotUp * factor, rotation);
					node.target = rotation + node.transform.position;
				}
			}
			
			
			lastMouseState = mouseState;
			
			Mouse.move()
		}+/
	}
}

class SphereMaterial : CompiledMaterial
{
	Colorf color;
}

class SphereEffect : CompiledMaterialEffect
{
	SphereMaterial _material;
	
	public void addUniform(Program program, char[] name, ShaderVariable variable)
	{
		program.uniforms[name] = new ProgramUniform(program.getUniformLoc(name), name, variable);
	}
	
	public void addAttribute(Program program, char[] name, ShaderVariable variable)
	{
		program.attributes[name] = new ProgramAttribute(program.getAttribLoc(name), name, variable);
	}
	
	public this()
	{
		auto directory = FileSystem.getDirectory;
		program = LoadProgram(directory ~ "SphereMaterial.vs.glsl", directory ~ "SphereMaterial.fs.glsl");
		addUniform(program, "World", ShaderVariable.Matrix4);
		addUniform(program, "View", ShaderVariable.Matrix4);
		addUniform(program, "Projection", ShaderVariable.Matrix4);
		addUniform(program, "Color", ShaderVariable.FloatVector4);
		
		addAttribute(program, "Position", ShaderVariable.FloatVector4);
		addAttribute(program, "Normal", ShaderVariable.FloatVector4);
		
		debug
		{
			Stdout.formatln("World-Loc: {}", program.uniforms["World"].loc);
			Stdout.formatln("View-Loc: {}", program.uniforms["View"].loc);
			Stdout.formatln("Projection-Loc: {}", program.uniforms["Projection"].loc);
			Stdout.formatln("Color-Loc: {}", program.uniforms["Color"].loc);
			
			Stdout.formatln("Position-Loc: {}", program.attributes["Position"].loc);
		}
		//ok
	}
	
	override void material(CompiledMaterial material)
	{
		this._material = cast(SphereMaterial) material;
	}
	
	override void use()
	{
		this.program.use();
	}
	
	override void begin()
	{
		/+this.program.uniforms["World"].value = this.formNode.world;
		this.program.uniforms["View"].value = camera.view;
		this.program.uniforms["Projection"].value = camera.projection;+/
		
		this.program.uniforms["World"].value = this.formNode.world;
		this.program.uniforms["View"].value = camera.view;
		this.program.uniforms["Projection"].value = camera.projection;
		
		this.program.uniforms["Color"].value = _material.color;
	}
	
	override void process()
	{
		program.attributes["Position"].specifyArray(DataType.Float, VertexSize.Three, 0, Vertex.sizeof);
		program.attributes["Position"].enableArray;
		program.attributes["Normal"].specifyArray(DataType.Float, VertexSize.Three, Vector3f.sizeof * 3, Vertex.sizeof);
		program.attributes["Normal"].enableArray;
	}
	
	override void end()
	{
		program.attributes["Position"].disableArray;
		program.attributes["Normal"].disableArray;
		super.end();
	}
}

class MySphereApp : Application
{
	SceneNode root;
	CameraNode camera;
	
	GLRenderer renderer;
	IController[] controllers;
	
	
	public this()
	{
		super(1000, 800, "Sphere", false, false);
		this.renderer = new GLRenderer();
	}
	
	private FormNode[] generateNodes(Form form, uint num, Vector3f range)
	{
		auto r = new Random();
		FormNode[] formNodes = new FormNode[num];
		
		foreach(ref formNode; formNodes)
		{
			formNode = new FormNode();
			formNode.form = form;
			
			Vector3f pos;
			pos.x = r.uniformRSymm(range.x);
			pos.y = r.uniformRSymm(range.y);
			pos.z = r.uniformRSymm(range.z);
			
			
			formNode.transform.position = pos;
			
			debug
			{
				Stdout.formatln("node: position = {}", formNode.transform.position.toArray);
			}
		}
		debug
		{
			Stdout(formNodes.length).newline;
		}
		return formNodes;
	}
	
	override void initialize()
	{
		root = new SceneNode();
		root.transform.position = Vector3f(0, 0, -5);
		
		debug
		{
			root.transform.toMatrix.print;
		}
		
		auto form = new Form();
		auto mesh = new UVSphere(10, 10, 1);
		form.geometry = mesh;
		
		
		auto effect = new SphereEffect();
		//renderer.effects[material] = effect;
		
		FormNode[] nodes = generateNodes(form, 10000, Vector3f(100, 100, 100));
		
		auto r = new Random();
		
		foreach(ref node; nodes)
		{
			auto mat = new SphereMaterial;
			mat.color = Colorf(r.uniformR2(0.3f, 1f), r.uniformR2(0.3f, 1f), r.uniformR2(0.3f, 1f));
			node.form.material = mat;
			renderer.effects[node.form.material] = effect;
			
			root.attachChild(node);
		}
		
		camera = new CameraNode();
		camera.transform.position = Vector3f(0, 0, -10);
		camera.target = Vector3f.zero;
		camera.up = Vector3f.up;
		camera.horizontalAngle = PI_4;
		camera.nearPlane = 0.01f;
		camera.farPlane = 1000f;
		camera.height = window().height();
		camera.width = window().width();
		
		CameraController cameraController = new CameraController();
		camera.controller = cameraController;
		
		root.attachChild(camera);
		
		
		renderer.root = root;
		
		
		
		void loop(SceneNode node)
		{
			foreach(ref child; node.children)
			{
				if(child.controller !is null)
					controllers ~= child.controller;
				loop(child);
			}
		}
		loop(root);
		debug
		{
			Stdout.formatln("controllers.length: {}", controllers.length);
		}
	}
	
	
	override void close()
	{
	}
	
	override void update()
	{	
		debug
		{
			assert(controllers !is null);
			assert(controllers[0] !is null);
		}
		
		foreach(controller; controllers)
		{
			controller.process();
		}
	}
	
	override void render()
	{
		renderer.render();
	}
}

