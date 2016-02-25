
module witchcraft.types;

import witchcraft;

import std.algorithm;
import std.array;
import std.range;

abstract class Type : Member
{
protected:
    Field[string] _fields;
    Method[][string] _methods;

public:
    /++
     + Looks up a field by name.
     +
     + Params:
     +   name = The name of the field.
     +
     + Returns:
     +   The field object, or null if no such field exists.
     ++/
    const(Field) getField(string name) const
    {
        auto ptr = name in _fields;
        return ptr ? *ptr : null;
    }

    final string[] getFieldNames() const
    {
        return getFields
            .map!"a.getName"
            .array;
    }

    /++
     + Returns an array of all fields defined by this type.
     +
     + Returns:
     +   All fields objects on this type.
     ++/
    const(Field)[] getFields() const
    {
        return _fields.values;
    }

    final const(Method) getMethod(string name, Type[] parameterTypes...) const
    {
        // Iterate up the inheritance tree.
        return this.getMethods(name).retro
            .filter!(m => m.getParameterTypes == parameterTypes)
            .takeOne
            .chain(null.only)
            .front;
    }

    final const(Method) getMethod(string name, TypeInfo[] parameterTypeInfos) const
    {
        // Iterate up the inheritance tree.
        return this.getMethods(name).retro
            .filter!(m => m.getParameterTypeInfos == parameterTypeInfos)
            .takeOne
            .chain(null.only)
            .front;
    }

    final const(Method) getMethod(TList...)(string name) const
    {
        auto parameterTypeInfos = new TypeInfo[TList.length];

        foreach(index, Type; TList)
        {
            parameterTypeInfos[index] = typeid(Type);
        }

        return this.getMethod(name, parameterTypeInfos);
    }

    const(Method)[] getMethods() const
    {
        const(Method)[] methods;

        // Flatten the overloads array.
        foreach(overloads; _methods.values)
        {
            methods ~= overloads;
        }

        return methods;
    }

    final string[] getMethodNames() const
    {
        return getMethods
            .map!"a.getName"
            .array;
    }

    const(Method)[] getMethods(string name) const
    {
        auto ptr = name in _methods;
        return ptr ? *ptr : [ ];
    }

    abstract const(TypeInfo) getTypeInfo() const;

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
        return false;
    }

    @property
    bool isModule() const
    {
        return false;
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

    override string toString() const
    {
        return getFullName;
    }
}
