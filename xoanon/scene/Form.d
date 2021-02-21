module xoanon.scene.Form;

import tango.util.container.HashSet;
import xoanon.content.Geometry;
import xoanon.content.Material;
import xoanon.scene.Scene;

class Form
{
	HashSet!(FormNode) owners;
	IMaterial material;
	IGeometry geometry;
	
	public this()
	{
		this.owners = new HashSet!(FormNode);
	}
	
	private bool _changed = false;
	
	public bool changed()
	{
		return this._changed;
	}
	
	public void changed(bool change)
	{
		return this._changed;
	}
	
	override int opEquals(Object o)
	{
		if(o !is null)
		{
			if(Form other = cast(Form) o)
			{
				if(this.material == other.material && this.geometry == other.geometry)
					return true;
			}
		}
		return false;
	}
}

class FormNode : SceneNode
{
	public this()
	{
		super();
		type = "FormNode";
	}
	
	private Form _form;
	
	public void form(Form form)
	{
		this._form = form;
		this._form.changed = true;
		form.owners.add(this);
	}
	
	public Form form()
	{
		return _form;
	}
}