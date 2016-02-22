
module witchcraft.structs;

import witchcraft;

abstract class Struct : Aggregate
{
    @property
    final override bool isClass() const
    {
        return false;
    }

    @property
    final override bool isStruct() const
    {
        return true;
    }
}
