
module witchcraft.attributes;

import witchcraft;

import std.conv;
import std.variant;

/++
 + Represents a single attribute attached to some element.
 ++/
abstract class Attribute
{
    /++
     + Reads the runtime value of the attribute if it caqn produce one. The
     + result is returned as a `Variant` object.
     +
     + Returns:
     +   A `Variant` that constains the runtime value of the attribute.
     ++/
    @property
    abstract Variant get() const;

    /++
     + Ditto, but also accepts a template parameter which the result is
     + converted to (if the conversion is possible).
     +
     + Params:
     +   T = The conversion type.
     +
     + Returns:
     +   The converted attribute value.
     ++/
    @property
    T get(T)() const
    {
        return this.get.get!T;
    }

    @property
    abstract const(Type) getAttributeType() const;

    @property
    abstract const(TypeInfo) getAttributeTypeInfo() const;

    /++
     + Checks if this attribute is expression. Any attribute that can produce
     + a value at runtime is considered an expression attribute.
     +
     + Returns:
     +   `true` if the attribute produces a runtime value.
     +
     + See_Also:
     +   isType
     ++/
    @property
    abstract bool isExpression() const;

    /++
     + Checks if this attribute is a type (or some other non-expression).
     +
     + Returns:
     +   `true` if the attribute does not produce a runtime value.
     ++/
    @property
    abstract bool isType() const;

    override string toString() const
    {
        if(isExpression)
        {
            return "@(" ~ get.text ~ ")";
        }
        else
        {
            return "@(" ~ getAttributeType.text ~ ")";
        }
    }
}
