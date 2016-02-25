
module witchcraft.methods;

import witchcraft;

import std.string;

/++
 + Represents and grants access to a single method defined on a type.
 ++/
abstract class Method : Invocable
{
    /++
     + Checks if this method is declared to be final.
     +
     + Returns:
     +   `true` if the method is final.
     ++/
    @property
    abstract bool isFinal() const;

    /++
     + Checks if this method is declared as an override.
     +
     + Returns:
     +   `true` if the method is an override.
     ++/
    @property
    abstract bool isOverride() const;

    /++
     + Checks if this method is declared to be static.
     +
     + Returns:
     +   `true` if the method is static.
     ++/
    @property
    abstract bool isStatic() const;

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
        return "%s %s(%(%s, %))".format(
            getReturnTypeInfo, getName, getParameterTypeInfos
        );
    }
}
