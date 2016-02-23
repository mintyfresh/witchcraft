
module witchcraft.types;

import witchcraft;

import std.algorithm;
import std.array;

interface Type : Member
{
    /++
     + Looks up a field by name.
     +
     + Params:
     +   name = The name of the field.
     +
     + Returns:
     +   The field object, or null if no such field exists.
     ++/
    const(Field) getField(string name) const;

    final string[] getFieldNames() const
    {
        return getFields.map!"a.getName".array;
    }

    /++
     + Returns an array of all fields defined by this type.
     +
     + Returns:
     +   All fields objects on this type.
     ++/
    const(Field)[] getFields() const;

    final const(Method) getMethod(string name, Type[] parameterTypes...) const
    {
        foreach(method; this.getMethods(name))
        {
            if(parameterTypes == method.getParameterTypes)
            {
                return method;
            }
        }

        return null;
    }

    final const(Method) getMethod(string name, TypeInfo[] parameterTypeInfos) const
    {
        foreach(method; this.getMethods(name))
        {
            if(parameterTypeInfos == method.getParameterTypeInfos)
            {
                return method;
            }
        }

        return null;
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

    const(Method)[] getMethods() const;

    final string[] getMethodNames() const
    {
        return getMethods.map!"a.getName".array;
    }

    const(Method)[] getMethods(string name) const;

    const(TypeInfo) getTypeInfo() const;

    @property
    bool isAggregate() const;

    @property
    bool isArray() const;

    @property
    bool isAssocArray() const;

    @property
    bool isBuiltIn() const;

    @property
    bool isClass() const;

    @property
    bool isInterface() const;

    @property
    bool isPointer() const;

    @property
    bool isPrimitive() const;

    @property
    bool isStaticArray() const;

    @property
    bool isString() const;

    @property
    bool isStruct() const;
}
