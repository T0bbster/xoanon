module xoanon.scene.Scene;

import xoanon.core.Transform;
import xoanon.core.math.Matrix;
import xoanon.scene.Controller;
import xoanon.core.Transform;
import xoanon.util.util;
import tango.core.Variant;
import tango.util.container.HashSet;


class Tree(T)
{
	protected T _parent;
	protected HashSet!(T) _children;
	
	public T parent()
	{
		return this._parent;
	}
	
	public HashSet!(T) children()
	{
		return this._children;
	}
	
	public void attachChild(T child)
	{
		this._children.add(child);
	}
	
	public void detachChild(T child)
	{
		this._children.remove(child);
	}
}

interface INode(T)
{
	public T parent();
	public HashSet!(T) children();
	public void attachChild(T child);
	public void detachChild(T child);
}

template TNode(T)
{
	protected T _parent;
	protected HashSet!(T) _children;
	
	public T parent()
	{
		return this._parent;
	}
	
	public HashSet!(T) children()
	{
		return this._children;
	}
	
	public void attachChild(T child)
	{
		child._parent = this;
		this._children.add(child);
		
	}
	
	public void detachChild(T child)
	{
		child._parent = null;
		this._children.remove(child);
	}
}



class SceneNode : INode!(SceneNode)
{
	mixin TNode!(SceneNode);
	
	char[] type = "SceneNode";
	
	public this()
	{
		this.transform = new Transformation();
		this._children = new HashSet!(SceneNode);
	}
	
	private IController _controller;
	
	public void controller(IController controller)
	{
		this._controller = controller;
		controller.addNode(this);
	}
	public IController controller()
	{
		return this._controller;
	}
	
	public Transformation transform;
	public Matrix4f world;
}