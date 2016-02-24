
module witchcraft.impl.attributes;

import witchcraft;

import std.variant;

class AttributeImpl(alias attribute) : Attribute
{
    override Variant get() const
    {
        static if(is(typeof(attribute)))
        {
            return Variant(attribute);
        }
        else
        {
            return Variant(null);
        }
    }

    override const(Type) getAttributeType() const
    {
        static if(is(typeof(attribute)))
        {
            static if(__traits(hasMember, typeof(attribute), "metaof"))
            {
                return typeof(attribute).metaof;
            }
            else
            {
                return null;
            }
        }
        else
        {
            static if(__traits(hasMember, attribute, "metaof"))
            {
                return attribute.metaof;
            }
            else
            {
                return null;
            }
        }
    }

    override const(TypeInfo) getAttributeTypeInfo() const
    {
        static if(is(typeof(attribute)))
        {
            return typeid(typeof(attribute));
        }
        else
        {
            return typeid(attribute);
        }
    }

    override bool isExpression() const
    {
        return is(typeof(attribute));
    }

    override bool isType() const
    {
        return !isExpression;
    }
}
