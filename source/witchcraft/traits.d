module witchcraft.traits;
import std.traits;

template isDefaultConstructible(T) 
{
	enum isDefaultConstructible = __traits(compiles, new T());
}
