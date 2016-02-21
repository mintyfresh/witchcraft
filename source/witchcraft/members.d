
module witchcraft.members;

import witchcraft;

import std.algorithm;
import std.array;

interface Member
{
    @property
    const(Attribute)[] getAttributes() const;

    @property
    final const(Attribute)[] getAttributes(TypeInfo type) const
    {
        return getAttributes.filter!(a => a.getType == type).array;
    }

    @property
    final const(Attribute)[] getAttributes(T)() const
    {
        return getAttributes(typeid(T));
    }

    @property
    string getName() const;

    @property
    const(Class) getParentClass() const;

    @property
    const(TypeInfo) getParentType() const;

    @property
    string getProtection() const;
}
