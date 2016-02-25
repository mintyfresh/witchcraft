
module witchcraft.structs;

import witchcraft;

abstract class Struct : Aggregate
{
    /++
     + Checks if this type is a struct. For children of `Struct`, this always
     + returns `true`.
     +
     + Returns:
     +   `true` if the type is a struct.
     ++/
    @property
    final override bool isStruct() const
    {
        return true;
    }
}
