
module witchcraft.memberinfo;

import witchcraft;

import std.algorithm;
import std.array;

interface MemberInfo
{
    @property
    const(AttributeInfo)[] getAttributes() const;

    @property
    final const(AttributeInfo)[] getAttributes(TypeInfo type) const
    {
        return getAttributes.filter!(a => a.getType == type).array;
    }

    @property
    final const(AttributeInfo)[] getAttributes(T)() const
    {
        return getAttributes(typeid(T));
    }

    @property
    string getName() const;

    @property
    const(ClassInfoExt) getParentClass() const;

    @property
    const(TypeInfo) getParentType() const;

    @property
    string getProtection() const;
}
