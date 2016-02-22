
module witchcraft.classes;

import witchcraft;

import std.algorithm;
import std.array;
import std.traits;

/++
 + Represents and grants access to a class's attributes, fields, methods,
 + and constructors.
 ++/
abstract class Class : Member, Aggregate
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
     + Looks up a field by name, searching this class, and each of its super
     + classes in turn.
     +
     + Params:
     +   name = The name of the field.
     +
     + Returns:
     +   The field object, or null if no such field exists.
     ++/
    override const(Field) getField(string name) const
    {
        auto field = getLocalField(name);

        if(field !is null)
        {
            return field;
        }
        else if(getSuperClass !is null)
        {
            return getSuperClass.getField(name);
        }
        else
        {
            return null;
        }
    }

    /++
     + Returns an array of all fields defined by this class and classes that
     + it inherits from. This only extends to super classes that also use
     + `Witchcraft`.
     +
     + Returns:
     +   An array of all known field objects belonging to this class.
     ++/
    override const(Field)[] getFields() const
    {
        if(getSuperClass !is null)
        {
            return getSuperClass.getFields ~ getLocalFields;
        }
        else
        {
            return getLocalFields;
        }
    }

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

    const(Method)[] getMethods() const
    {
        if(getSuperClass !is null)
        {
            return getSuperClass.getMethods ~ getLocalMethods;
        }
        else
        {
            return getLocalMethods;
        }
    }

    const(Method)[] getMethods(string name) const
    {
        if(getSuperClass !is null)
        {
            return getSuperClass.getMethods(name) ~ getLocalMethods(name);
        }
        else
        {
            return getLocalMethods(name);
        }
    }

    abstract const(Class) getSuperClass() const;

    abstract const(TypeInfo) getSuperType() const;

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
