
module witchcraft.impl.inspect;

import witchcraft;

import std.meta;

@property
Type inspect(TList...)()
if(TList.length == 1)
{
    alias T = TList[0];

    static if(__traits(hasMember, T, "classof"))
    {
        return T.classof;
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

@property
Type inspect(T)(T object)
{
    static if(__traits(hasMember, T, "classof"))
    {
        return object ? object.getClass : null;
    }
    else
    {
        return inspect!T;
    }
}
