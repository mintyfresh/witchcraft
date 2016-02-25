
module witchcraft.modules;

import witchcraft;

abstract class Module : Type
{
    final const(Attribute)[] getAttributes() const
    {
        return [ ];
    }

    final const(Type) getDeclaringType() const
    {
        return null;
    }

    final const(TypeInfo) getDeclaringTypeInfo() const
    {
        return null;
    }

    final override const(TypeInfo) getTypeInfo() const
    {
        return null;
    }

    @property
    final override bool isModule() const
    {
        return true;
    }
}
