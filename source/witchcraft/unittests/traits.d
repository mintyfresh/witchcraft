module witchcraft.unittests.traits;
import witchcraft.traits;

version (unittest)
{
	class Foo
	{
		string value;
	}

	class Bar
	{
		this(string v)
		{
			value = v;
		}

		string value;
	}
}

unittest
{
	assert(isDefaultConstructible!Foo);
	assert(!isDefaultConstructible!Bar);
}