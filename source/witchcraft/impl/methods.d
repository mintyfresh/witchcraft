
module witchcraft.impl.methods;

version(aggressive):

import witchcraft;

import std.variant;

template MethodImpl(T, string name, size_t overload)
{
    // TODO : Determine this more reliably.
    static if(__traits(getProtection, __traits(getOverloads, T, name)[overload]) == "public")
    {
        mixin WitchcraftMethod;

        alias MethodImpl = MethodMixin!(T, name, overload);
    }
    else
    {
        class MethodImpl : Method
        {
            const(Attribute)[] getAttributes() const
            {
                assert(0, "Method " ~ name ~ " is inaccessible.");
            }

            const(Type) getDeclaringType() const
            {
                assert(0, "Method " ~ name ~ " is inaccessible.");
            }

            const(TypeInfo) getDeclaringTypeInfo() const
            {
                assert(0, "Method " ~ name ~ " is inaccessible.");
            }

            string getFullName() const
            {
                assert(0, "Method " ~ name ~ " is inaccessible.");
            }

            string getName() const
            {
                return name;
            }

            const(Type)[] getParameterTypes() const
            {
                assert(0, "Method " ~ name ~ " is inaccessible.");
            }

            const(TypeInfo)[] getParameterTypeInfos() const
            {
                assert(0, "Method " ~ name ~ " is inaccessible.");
            }

            string getProtection() const
            {
                return __traits(getProtection, __traits(getOverloads, T, name)[overload]);
            }

            const(Type) getReturnType() const
            {
                assert(0, "Method " ~ name ~ " is inaccessible.");
            }

            @property
            const(TypeInfo) getReturnTypeInfo() const
            {
                assert(0, "Method " ~ name ~ " is inaccessible.");
            }

            Variant invoke(Variant instance, Variant[] arguments...) const
            {
                assert(0, "Method " ~ name ~ " is inaccessible.");
            }

            @property
            final bool isAccessible() const
            {
                return false;
            }

            @property
            override bool isFinal() const
            {
                assert(0, "Method " ~ name ~ " is inaccessible.");
            }

            @property
            override bool isStatic() const
            {
                assert(0, "Method " ~ name ~ " is inaccessible.");
            }

            @property
            bool isVarArgs() const
            {
                assert(0, "Method " ~ name ~ " is inaccessible.");
            }
        }
    }
}
