
module witchcraft.impl.inspect;

import witchcraft;

import std.meta;

/++
 + Inspects a type given by template argument using the `metaof` property if
 + the type defines one. Otherwise, a `null` is returned.
 +
 + If aggressive version of `Witchcraft` is used, this method behaves
 + differently and returns a generic aggressive meta type.
 +
 + Returns:
 +   The meta type of the type given by a parameter.
 ++/
@property
Type inspect(TList...)()
if(TList.length == 1)
{
    alias T = TList[0];

    static if(__traits(hasMember, T, "metaof"))
    {
        return T.metaof;
    }
    else
    {
        version(aggressive)
        {
            static if(is(T == class))
            {
                return new ClassImpl!T;
            }
            else static if(is(T == struct))
            {
                return new StructImpl!T;
            }
            else static if(is(T == interface))
            {
                return new InterfaceTypeImpl!T;
            }
            else
            {
                return null;
            }
        }
        else
        {
            return null;
        }
    }
}

/++
 + Inspects a value, using the `getMetaType` method if present. Otherwise,
 + the value's type is inspected by the generic `inspect` function type.
 +
 + Params:
 +   value = The parameter value to be inspected.
 +
 + Returns:
 +   The meta type of the value given by a parameter.
 +
 + See_Also:
 +   inspect()
 ++/
@property
Type inspect(T)(T value)
{
    static if(__traits(hasMember, T, "getMetaType"))
    {
        return value ? value.getMetaType : null;
    }
    else
    {
        return inspect!T;
    }
}
