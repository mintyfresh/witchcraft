
module witchcraft.constructors;

import witchcraft;

import std.string;
import std.variant;

class Constructor : Member
{
    abstract Object create(Variant[] arguments...) const;

    T create(T : Object = Object, TList...)(TList arguments) const
    {
        auto values = new Variant[TList.length];

        foreach(index, argument; arguments)
        {
            values[index] = Variant(argument);
        }

        return cast(T) this.create(values);
    }

    override string getName() const
    {
        return "__ctor";
    }

    abstract const(TypeInfo)[] getParameterTypes() const;

    @property
    abstract bool isVarArgs() const;

    override string toString() const
    {
        return "%s(%(%s, %))".format(getName, getParameterTypes);
    }
}
