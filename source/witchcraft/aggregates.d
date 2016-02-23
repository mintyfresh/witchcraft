
module witchcraft.aggregates;

import witchcraft;

import std.algorithm;
import std.array;

abstract class Aggregate : Type
{
protected:
    Field[string] _fields;
    Method[][string] _methods;

public:
    /++
     + Looks up and returns a constructor with a parameter list that exactly
     + matches the given array of types.
     +
     + Params:
     +   parameterTypes = A parameter list the constructor must exactly match.
     +
     + Returns:
     +   The constructor object, or null if no such constructor exists.
     ++/
    final const(Constructor) getConstructor(Type[] parameterTypes...) const
    {
        foreach(constructor; getConstructors)
        {
            if(constructor.getParameterTypes == parameterTypes)
            {
                return constructor;
            }
        }

        return null;
    }

    /++
     + Looks up and returns a constructor with a parameter list that exactly
     + matches the given array of types.
     +
     + Params:
     +   parameterTypeInfos = A parameter list the constructor must exactly match.
     +
     + Returns:
     +   The constructor object, or null if no such constructor exists.
     ++/
    final const(Constructor) getConstructor(TypeInfo[] parameterTypeInfos) const
    {
        foreach(constructor; getConstructors)
        {
            if(constructor.getParameterTypeInfos == parameterTypeInfos)
            {
                return constructor;
            }
        }

        return null;
    }

    /++
     + Ditto, but accepts types given by variadic template arguments.
     +
     + Params:
     +   TList = A list of types the constructor must exactly match.
     +
     + Returns:
     +   The constructor object, or null if no such constructor exists.
     ++/
    final const(Constructor) getConstructor(TList...)() const
    {
        auto types = new TypeInfo[TList.length];

        foreach(index, type; TList)
        {
            types[index] = typeid(type);
        }

        return this.getConstructor(types);
    }

    /++
     + Returns an array of all constructors defined by this type.
     + This does not include the default constructor.
     +
     + If a type declares no constructors, this method will return an empty
     + array.
     +
     + Returns:
     +   And array of all constructors on the aggregate type.
     ++/
    abstract const(Constructor)[] getConstructors() const;

    const(Field) getField(string name) const
    {
        auto ptr = name in _fields;
        return ptr ? *ptr : null;
    }

    const(Field)[] getFields() const
    {
        return _fields.values;
    }

    const(Method)[] getMethods(string name) const
    {
        auto ptr = name in _methods;
        return ptr ? *ptr : null;
    }

    const(Method)[] getMethods() const
    {
        const(Method)[] methods;

        foreach(overloads; _methods.values)
        {
            methods ~= overloads;
        }

        return methods;
    }

    @property
    final bool isAggregate() const
    {
        return true;
    }

    @property
    final bool isArray() const
    {
        return false;
    }

    @property
    final bool isAssocArray() const
    {
        return false;
    }

    @property
    final bool isBuiltIn() const
    {
        return false;
    }

    @property
    final bool isModule() const
    {
        return false;
    }

    @property
    final bool isPointer() const
    {
        return false;
    }

    @property
    final bool isPrimitive() const
    {
        return false;
    }

    @property
    final bool isStaticArray() const
    {
        return false;
    }

    @property
    final bool isString() const
    {
        return false;
    }

    override string toString() const
    {
        return getFullName;
    }
}
