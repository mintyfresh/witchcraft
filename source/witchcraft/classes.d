
module witchcraft.classes;

import witchcraft;

import std.algorithm;
import std.array;
import std.traits;

/++
 + Represents and grants access to a class's attributes, fields, methods,
 + and constructors.
 ++/
abstract class Class : Member
{
    /++
     + Creates a new instance of the class, provided it has a default or
     + zero-argument constructor.
     +
     + Returns:
     +   A new instance of the class.
     ++/
    @property
    abstract Object create() const;

    /++
     + Ditto, but also casts the result to a type given by template parameter.
     +
     + Params:
     +   T = An Object type to which the result is cast.
     +
     + Returns:
     +   A new instance of the class.
     ++/
    @property
    T create(T : Object)() const
    {
        return cast(T) this.create;
    }

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
    const(Constructor) getConstructor(TypeInfo[] parameterTypes...) const
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
     + Ditto, but accepts types given by variadic template arguments.
     +
     + Params:
     +   TList = A list of types the constructor must exactly match.
     +
     + Returns:
     +   The constructor object, or null if no such constructor exists.
     ++/
    const(Constructor) getConstructor(TList...)() const
    {
        auto types = new TypeInfo[TList.length];

        foreach(index, type; TList)
        {
            types[index] = typeid(type);
        }

        return this.getConstructor(types);
    }

    /++
     + Returns an array of all constructors defined by this class.
     + This does not include any constructors inherited from a base class,
     + nor the default constructor.
     +
     + If a class declares no constructors, this method will return an empty
     + array. To construct an Object of such a type, the `create()` method
     + defined by `Class` should be used.
     +
     + Returns:
     +   And array of all constructors on the class.
     +
     + See_Also:
     +   create
     ++/
    abstract const(Constructor)[] getConstructors() const;

    /++
     + Looks up a field by name, searching this class, and each of its parent
     + classes in turn.
     +
     + Params:
     +   name = The name of the field.
     +
     + Returns:
     +   The field object, or null if no such field exists.
     ++/
    const(Field) getField(string name) const
    {
        auto field = getLocalField(name);

        if(field !is null)
        {
            return field;
        }
        else if(getParentClass !is null)
        {
            return getParentClass.getField(name);
        }
        else
        {
            return null;
        }
    }

    /++
     + Returns an array of all fields defined by this class and classes that
     + it inherits from. This only extends to parent classes that also use
     + `Witchcraft`.
     +
     + Returns:
     +   An array of all known field objects belonging to this class.
     ++/
    const(Field)[] getFields() const
    {
        if(getParentClass !is null)
        {
            return getParentClass.getFields ~ getLocalFields;
        }
        else
        {
            return getLocalFields;
        }
    }

    /++
     + Returns an array of names of all fields defined by this class and
     + classes that it inherits from. This only extends to parent classes that
     + also use `Witchcraft`.
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
    string[] getFieldNames() const
    {
        return getFields.map!"a.getName".array;
    }

    /++
     + Returns the fully-qualified name of the class, including the package and
     + module name, and any types that might enclose it.
     +
     + Returns:
     +   The fully-qualified name of this class.
     ++/
    abstract string getFullName() const;

    abstract const(Field) getLocalField(string name) const;

    string[] getLocalFieldNames() const
    {
        return getLocalFields.map!"a.getName".array;
    }

    abstract const(Field)[] getLocalFields() const;

    const(Method) getLocalMethod(string name, TypeInfo[] parameterTypes...) const
    {
        auto methods = getLocalMethods(name);

        if(methods !is null)
        {
            foreach(method; methods)
            {
                if(method.getParameterTypes == parameterTypes)
                {
                    return method;
                }
            }

            return null;
        }
        else
        {
            return null;
        }
    }

    const(Method) getLocalMethod(TList...)(string name) const
    {
        auto types = new TypeInfo[TList.length];

        foreach(index, type; TList)
        {
            types[index] = typeid(type);
        }

        return this.getLocalMethod(name, types);
    }

    string[] getLocalMethodNames() const
    {
        return getLocalMethods.map!"a.getName".array;
    }

    abstract const(Method)[] getLocalMethods() const;

    abstract const(Method)[] getLocalMethods(string name) const;

    const(Method) getMethod(string name, TypeInfo[] parameterTypes...) const
    {
        auto method = getLocalMethod(name, parameterTypes);

        if(method !is null)
        {
            return method;
        }
        else if(getParentClass !is null)
        {
            return getParentClass.getMethod(name, parameterTypes);
        }
        else
        {
            return null;
        }
    }

    const(Method) getMethod(TList...)(string name) const
    {
        auto types = new TypeInfo[TList.length];

        foreach(index, type; TList)
        {
            types[index] = typeid(type);
        }

        return this.getMethod(name, types);
    }

    string[] getMethodNames() const
    {
        if(getParentClass !is null)
        {
            return getParentClass.getMethodNames ~ getLocalMethodNames;
        }
        else
        {
            return getLocalMethodNames;
        }
    }

    const(Method)[] getMethods() const
    {
        if(getParentClass !is null)
        {
            return getParentClass.getMethods ~ getLocalMethods;
        }
        else
        {
            return getLocalMethods;
        }
    }

    const(Method)[] getMethods(string name) const
    {
        if(getParentClass !is null)
        {
            return getParentClass.getMethods(name) ~ getLocalMethods(name);
        }
        else
        {
            return getLocalMethods(name);
        }
    }

    /++
     + Checks if this class is abstract.
     ++/
    @property
    abstract bool isAbstract() const;

    /++
     + Checks if this class is final.
     ++/
    @property
    abstract bool isFinal() const;
}
