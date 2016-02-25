
module witchcraft.interfaces;

import witchcraft;

abstract class InterfaceType : Aggregate
{
    final override const(Constructor)[] getConstructors() const
    {
        return [ ];
    }

    /++
     + Checks if this type is an interface. For children of `Interfalse`, this
     + always returns `true`.
     +
     + Returns:
     +   `true` if the type is an interface.
     ++/
    @property
    final override bool isInterface() const
    {
        return true;
    }
}
