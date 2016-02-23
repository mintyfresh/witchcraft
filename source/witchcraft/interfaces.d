
module witchcraft.interfaces;

import witchcraft;

abstract class Interface : Aggregate
{
    final override const(Constructor)[] getConstructors() const
    {
        return [ ];
    }

    @property
    final bool isClass() const
    {
        return false;
    }

    @property
    final bool isInterface() const
    {
        return true;
    }

    @property
    final bool isStruct() const
    {
        return false;
    }
}
