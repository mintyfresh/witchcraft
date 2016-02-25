
module witchcraft.impl.modules;

import witchcraft;

import std.traits;

class ModuleImpl(alias M) : Module
{
    mixin WitchcraftField;
    mixin WitchcraftMethod;

    this()
    {
        foreach(name; __traits(derivedMembers, M))
        {
            // HACK: There's no good way to determine if something is a field.
            static if(is(typeof(__traits(getMember, M, name))) &&
                      !is(typeof(__traits(getMember, M, name)) == class) &&
                      !is(typeof(__traits(getMember, M, name)) == enum) &&
                      !is(typeof(__traits(getMember, M, name)) == function) &&
                      !is(typeof(__traits(getMember, M, name)) == struct) &&
                      !is(typeof(__traits(getMember, M, name)) == void) &&
                      !is(typeof(__traits(getMember, M, name)) == union))
            {
                _fields[name] = new FieldMixin!(M, name);
            }
        }

        foreach(name; __traits(derivedMembers, M))
        {
            static if(is(typeof(__traits(getMember, M, name)) == function))
            {
                // HACK: For some reason, object.isnan causes a linking error on Windows.
                static if(fullyQualifiedName!(__traits(getMember, M, name)) != "object.isnan")
                {
                    foreach(index, overload; __traits(getOverloads, M, name))
                    {
                        _methods[name] ~= new MethodMixin!(M, name, index);
                    }
                }
            }
        }
    }

    string getFullName() const
    {
        return fullyQualifiedName!M;
    }

    string getName() const
    {
        return M.stringof;
    }

    string getProtection() const
    {
        return __traits(getProtection, M);
    }

    @property
    final bool isAccessible() const
    {
        return true;
    }
}
