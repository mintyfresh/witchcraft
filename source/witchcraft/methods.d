
module witchcraft.methods;

import witchcraft;

import std.algorithm;
import std.array;
import std.string;
import std.variant;

/++
 + Represents and grants access to a single method defined in a class.
 ++/
abstract class Method : Member
{
    /++
     + Returns an array of `Class` objects representing this method's
     + parameter types. If a parameter does not have an associated reflective
     + type, its value is `null`.
     +
     + Returns:
     +   This method's parameter classes.
     +
     + See_Also:
     +   getParameterTypes
     ++/
    abstract const(Class)[] getParameterClasses() const;

    /++
     + Returns an array representing the method's parameter types.
     +
     + Returns:
     +   This method's parameter types.
     ++/
    abstract const(TypeInfo)[] getParameterTypes() const;

    /++
     + A `Class` object that represent's this method's return type, if type
     + type has reflective support. Null is returned otherwise.
     +
     + Returns:
     +   This method's return type.
     ++/
    @property
    abstract const(Class) getReturnClass() const;

    /++
     + This method's return type.
     +
     + Returns:
     +   This method's return type.
     ++/
    @property
    abstract const(TypeInfo) getReturnType() const;

    /++
     + Invokes this method on the given instance of class using arguments given
     + as an array of `Variant` values. For static methods, the value of the
     + instance object may be null.
     + The result is returned as a `Variant`. If the method would return void,
     + a null value is returned instead.
     +
     + Params:
     +   instance  = The object instance to invoke the method as.
     +   arguments = The arguments to be passed along to the method.
     +
     + Returns:
     +   The result of the method call.
     ++/
    abstract Variant invoke(Object instance, Variant[] arguments...) const;

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
     +   The result of the method call.
     ++/
    T invoke(T = Variant, TList...)(Object instance, TList arguments) const
    {
        auto values = new Variant[TList.length];

        foreach(index, argument; arguments)
        {
            values[index] = Variant(argument);
        }

        auto result = this.invoke(instance, values);

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
     + Checks if this method is declared to be final.
     +
     + Returns:
     +   `true` if the method is final.
     ++/
    @property
    abstract bool isFinal() const;

    /++
     + Checks if this method is declared to be static.
     +
     + Returns:
     +   `true` if the method is static.
     ++/
    @property
    abstract bool isStatic() const;

    /++
     + Checks if this method accepts variable arguments.
     +
     + Returns:
     +   `true` if the method is accepts varargs.
     ++/
    @property
    abstract bool isVarArgs() const;

    /++
     + Checks if this method has entry in the object's vtable.
     +
     + Returns:
     +   `true` if the method is virtual.
     +
     + See_Also:
     +   isFinal, isStatic
     ++/
    @property
    bool isVirtual() const
    {
        return !isFinal && !isStatic;
    }

    override string toString() const
    {
        return "%s %s(%(%s, %))".format(getReturnType, getName, getParameterTypes);
    }
}
