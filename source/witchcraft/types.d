
module witchcraft.types;

import witchcraft;

abstract class Type : Member
{
    abstract const(TypeInfo) getTypeInfo() const;

    @property
    abstract bool isAggregate() const;

    @property
    abstract bool isArray() const;

    @property
    abstract bool isAssocArray() const;

    @property
    abstract bool isBuiltIn() const;

    @property
    abstract bool isClass() const;

    @property
    abstract bool isInterface() const;

    @property
    abstract bool isPointer() const;

    @property
    abstract bool isPrimitive() const;

    @property
    abstract bool isStaticArray() const;

    @property
    abstract bool isString() const;

    @property
    abstract bool isStruct() const;
}
