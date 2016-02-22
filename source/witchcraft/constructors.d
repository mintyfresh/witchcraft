
module witchcraft.constructors;

import witchcraft;

import std.string;
import std.variant;

/++
 + Represents and grants access to a single constructor defined in a class.
 ++/
class Constructor : Member
{
    /++
     + Invokes the constructor, passing in arguments as variant types.
     + The result is returned as an Object type.
     ++/
    abstract Object create(Variant[] arguments...) const;

    /++
     + Ditto, but accepts arguments of any type, and permits the result to also
     + be cast to a type specified by template argument.
     ++/
    T create(T : Object = Object, TList...)(TList arguments) const
    {
        auto values = new Variant[TList.length];

        foreach(index, argument; arguments)
        {
            values[index] = Variant(argument);
        }

        return cast(T) this.create(values);
    }

    /++
     + Returns `__ctor`, which is the name of all constructors.
     ++/
    final override string getName() const
    {
        return "__ctor";
    }

    abstract const(Class)[] getParameterClasses() const;

    /++
     + Returns an array representing the constructor's parameter types.
     ++/
    abstract const(TypeInfo)[] getParameterTypes() const;

    /++
     + Checks if the constructor accepts variable arguments.
     ++/
    @property
    abstract bool isVarArgs() const;

    override string toString() const
    {
        return "%s(%(%s, %))".format(getName, getParameterTypes);
    }
}
