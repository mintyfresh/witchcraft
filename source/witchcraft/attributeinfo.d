
module witchcraft.attributeinfo;

import witchcraft;

import std.conv;
import std.variant;

abstract class AttributeInfo
{
    @property
    abstract Variant get() const;

    @property
    T get(T)() const
    {
        return this.get.get!T;
    }

    @property
    abstract const(ClassInfoExt) getClass() const;

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
