module xoanon.util.util;

template PropertyInterface(T, char[] name)
{
	mixin("public " ~ T.stringof ~ " " ~ name ~ "();");
	mixin("public void " ~ name ~ "(" ~ T.stringof ~ " value);");
}

template Property(T, char[] name)
{
	mixin("private " ~ T.stringof ~ "_" ~ name);
	mixin("public " ~ T.stringof ~ " " ~ name ~ "() { return " ~ "_" ~ name ~ "; }");
	mixin("public void " ~ name ~ "(" ~ T.stringof ~ " value) { " ~ "_" ~ name ~ " = value; }");
}