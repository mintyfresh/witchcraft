
module witchcraft.structs;

import witchcraft;

abstract class Struct : Aggregate
{
    @property
    final bool isClass() const
    {
        return false;
    }

    @property
    final bool isInterface() const
    {
        return false;
    }

    @property
    final bool isStruct() const
    {
        return true;
    }
}
