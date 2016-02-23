
module witchcraft.invocable;

import witchcraft;

import std.variant;

interface Invocable : Member
{
    /++
     + Returns an array of `Type` objects representing this element's
     + parameter types. If a parameter does not have an associated reflective
     + type, its value is `null`.
     +
     + Returns:
     +   This element's parameter types.
     +
     + See_Also:
     +   getParameterTypes
     ++/
    const(Type)[] getParameterTypes() const;

    /++
     + Returns an array representing the element's parameter types.
     +
     + Returns:
     +   This method's parameter types.
     ++/
    const(TypeInfo)[] getParameterTypeInfos() const;

    /++
     + A `Type` object that represent's this element's return type, if type
     + type has reflective support. Null is returned otherwise.
     +
     + Returns:
     +   This element's return type.
     ++/
    @property
    const(Type) getReturnType() const;

    /++
     + This element's return `TypeInfo` object.
     +
     + Returns:
     +   This element's return type.
     ++/
    @property
    const(TypeInfo) getReturnTypeInfo() const;

    /++
     + Invokes this element on the given instance of class using arguments given
     + as an array of `Variant` values. For static elements, the value of the
     + instance object may be null.
     + The result is returned as a `Variant`. If the call would return void,
     + a null value is returned instead.
     +
     + Params:
     +   instance  = The object instance to invoke the method as.
     +   arguments = The arguments to be passed along to the method.
     +
     + Returns:
     +   The result of the invocation.
     ++/
    Variant invoke(Variant instance, Variant[] arguments...) const;

    /++
     + Ditto, but arguments are taken as variadic arguments.
     + A template argument may be specified to covert the result of the call.
     +
     + Params:
     +   T         = The type to convert the result into.
     +   instance  = The object instance to invoke the method as.
     +   arguments = The arguments to be passed along to the method.
     +
     + Returns:
     +   The result of the invocation.
     ++/
    final T invoke(T = Variant, O, TList...)(O instance, TList arguments) const
    {
        auto values = new Variant[TList.length];

        foreach(index, argument; arguments)
        {
            values[index] = Variant(argument);
        }

        auto result = this.invoke(Variant(instance), values);

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
     + Checks if this element accepts variable arguments.
     +
     + Returns:
     +   `true` if the element accepts varargs.
     ++/
    @property
    bool isVarArgs() const;
}
