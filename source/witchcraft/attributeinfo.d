
module witchcraft.attributeinfo;

import std.conv;
import std.variant;

abstract class AttributeInfo
{
    abstract Variant get() const;

    T get(T)() const
    {
        return this.get.get!T;
    }

    @property
    abstract const(TypeInfo) getType() const;

    @property
    abstract bool isExpression() const;

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
            return "@(" ~ getType.text ~ ")";
        }
    }
}
