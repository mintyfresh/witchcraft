
module witchcraft.constructors;

import witchcraft;

import std.string;
import std.variant;

/++
 + Represents and grants access to a single constructor defined in a class.
 ++/
class Constructor : Invocable
{
    /++
     + Invokes the constructor, passing in arguments as variant types.
     + The result is returned as an Object type.
     ++/
    final Variant create(Variant[] arguments...) const
    {
        return this.invoke(null, arguments);
    }

    /++
     + Ditto, but accepts arguments of any type, and permits the result to also
     + be cast to a type specified by template argument.
     ++/
    final T create(T, TList...)(TList arguments) const
    {
        return this.invoke(null, arguments).get!T;
    }

    /++
     + Returns `__ctor`, which is the name of all constructors.
     ++/
    final override string getName() const
    {
        return "__ctor";
    }

    override string toString() const
    {
        return "%s(%(%s, %))".format(getName, getParameterTypeInfos);
    }
}
