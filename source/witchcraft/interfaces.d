
module witchcraft.interfaces;

import witchcraft;

abstract class Interface : Type
{
    @property
    bool isAggregate() const
    {
        return false;
    }

    @property
    bool isArray() const
    {
        return false;
    }

    @property
    bool isAssocArray() const
    {
        return false;
    }

    @property
    bool isBuiltIn() const
    {
        return false;
    }

    @property
    bool isClass() const
    {
        return false;
    }

    @property
    bool isInterface() const
    {
        return true;
    }

    @property
    bool isPointer() const
    {
        return false;
    }

    @property
    bool isPrimitive() const
    {
        return false;
    }

    @property
    bool isStaticArray() const
    {
        return false;
    }

    @property
    bool isString() const
    {
        return false;
    }

    @property
    bool isStruct() const
    {
        return false;
    }
}
