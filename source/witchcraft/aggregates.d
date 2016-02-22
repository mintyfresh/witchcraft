
module witchcraft.aggregates;

import witchcraft;

import std.algorithm;
import std.array;

abstract class Aggregate : Type
{
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

    /++
     + Looks up a field by name.
     +
     + Params:
     +   name = The name of the field.
     +
     + Returns:
     +   The field object, or null if no such field exists.
     ++/
    abstract const(Field) getField(string name) const;

    /++
     + Returns an array of the names of all fields defined by this type.
     +
     + This method is equivalent to mapping the result of `getFields()` to the
     + names of the fields in the resulting array.
     +
     + Return:
     +   An array of names of all known fields.
     +
     + See_Also:
     +   getFields
     ++/
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
    abstract const(Field)[] getFields() const;

    final const(Method) getMethod(string name, Type[] parameterTypes...) const
    {
        foreach(method; getMethods(name))
        {
            if(method.getParameterTypes == parameterTypes)
            {
                return method;
            }
        }

        return null;
    }

    final const(Method) getMethod(string name, TypeInfo[] parameterTypeInfos) const
    {
        foreach(method; getMethods(name))
        {
            if(method.getParameterTypeInfos == parameterTypeInfos)
            {
                return method;
            }
        }

        return null;
    }

    final const(Method) getMethod(TList...)(string name) const
    {
        auto types = new TypeInfo[TList.length];

        foreach(index, type; TList)
        {
            types[index] = typeid(type);
        }

        return this.getMethod(name, types);
    }

    final string[] getMethodNames() const
    {
        return getMethods.map!"a.getName".array;
    }

    abstract const(Method)[] getMethods() const;

    abstract const(Method)[] getMethods(string name) const;

    @property
    final override bool isAggregate() const
    {
        return true;
    }

    @property
    final override bool isArray() const
    {
        return false;
    }

    @property
    final override bool isAssocArray() const
    {
        return false;
    }

    @property
    final override bool isBuiltIn() const
    {
        return false;
    }

    @property
    final override bool isInterface() const
    {
        return false;
    }

    @property
    final override bool isPointer() const
    {
        return false;
    }

    @property
    final override bool isPrimitive() const
    {
        return false;
    }

    @property
    final override bool isStaticArray() const
    {
        return false;
    }

    @property
    final override bool isString() const
    {
        return false;
    }
}
