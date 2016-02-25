
module witchcraft.impl.constructors;

version(aggressive):

import witchcraft;

import std.variant;

template ConstructorImpl(alias T, size_t overload)
{
    // TODO : Determine this more reliably.
    static if(__traits(getProtection, __traits(getOverloads, T, "__ctor")[overload]) == "public")
    {
        mixin WitchcraftConstructor;

        alias ConstructorImpl = ConstructorMixin!(T, overload);
    }
    else
    {
        class ConstructorImpl : Constructor
        {
            const(Attribute)[] getAttributes() const
            {
                assert(0, "Constructor is not accessible.");
            }

            const(Type) getDeclaringType() const
            {
                assert(0, "Constructor is not accessible.");
            }

            const(TypeInfo) getDeclaringTypeInfo() const
            {
                assert(0, "Constructor is not accessible.");
            }

            string getFullName() const
            {
                assert(0, "Constructor is not accessible.");
            }

            const(Type)[] getParameterTypes() const
            {
                assert(0, "Constructor is not accessible.");
            }

            const(TypeInfo)[] getParameterTypeInfos() const
            {
                assert(0, "Constructor is not accessible.");
            }

            string getProtection() const
            {
                return __traits(getProtection, __traits(getOverloads, T, "__ctor")[overload]);
            }

            const(Type) getReturnType() const
            {
                assert(0, "Constructor is not accessible.");
            }

            @property
            const(TypeInfo) getReturnTypeInfo() const
            {
                assert(0, "Constructor is not accessible.");
            }

            Variant invoke(Variant instance, Variant[] arguments...) const
            {
                assert(0, "Constructor is not accessible.");
            }

            @property
            final bool isAccessible() const
            {
                return false;
            }

            @property
            bool isVarArgs() const
            {
                assert(0, "Constructor is not accessible.");
            }
        }
    }
}
