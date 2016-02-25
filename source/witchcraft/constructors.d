
module witchcraft.constructors;

import witchcraft;

import std.string;
import std.variant;

/++
 + Represents and grants access to a single constructor defined in some
 + aggregate type.
 ++/
abstract class Constructor : Invocable
{
    /++
     + Invokes the constructor, passing in arguments as variant types.
     + The result is returned as a `Variant` type.
     +
     + Returns:
     +   The result of the construct call, as a `Variant`.
     ++/
    final Variant create(Variant[] arguments...) const
    {
        return this.invoke(null, arguments);
    }

    /++
     + Ditto, but accepts arguments of any type, and permits the result to also
     + be cast to a type specified by template argument.
     +
     + Returns:
     +   The result of the construct call, as the templated type.
     ++/
    final T create(T, TList...)(TList arguments) const
    {
        auto result = this.invoke(null, arguments);

        static if(is(T == Variant))
        {
            return result;
        }
        else
        {
            return result.get!T;
        }
    }

    /++
     + Returns `__ctor`, which is the name of all constructors.
     +
     + Returns:
     +   The name of this constructor.
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
