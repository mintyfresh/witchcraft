module witchcraft.mixins.base;

import std.meta;

template TypeOfMeta(T)
{
    import witchcraft;
    
    static if(is(T == class))
    {
        alias TypeOfMeta = Class;
    } 
    else static if(is(T == struct)) 
    {
        alias TypeOfMeta = Struct;
    }
    else static if(is(T == interface))
    {
        alias TypeOfMeta = InterfaceType;
    }
    else static if(!is(T)) 
    {
        alias TypeOfMeta = Module;
    }
    else
    {
        static assert(false); //todo: proper error
    }
}

mixin template Witchcraft()
{
    import witchcraft;

    alias T = typeof(this);

    mixin WitchcraftClass;
    mixin WitchcraftConstructor;
    mixin WitchcraftField;
    mixin WitchcraftInterface;
    mixin WitchcraftMethod;
    mixin WitchcraftStruct;

    static if(is(T == class))
    {
        alias ImplTypeOfMeta = ClassMixin!(T);
    }
    else static if(is(T == struct))
    {
        alias ImplTypeOfMeta = StructMixin!(T);
    } 
    else static if(is(T == interface))
    {
        alias ImplTypeOfMeta = InterfaceTypeMixin!(T);
    }
    else static if(!is(T))
    {
        alias ImplTypeOfMeta = ModuleImpl!(__traits(parent, T));
    }
    else
    {
        static assert(false); //todo: proper error
    }

    private static TypeOfMeta!(T) __typeinfoext;

    @property
    static typeof(__typeinfoext) metaof()
    {
        if(__typeinfoext is null)
        {
            __typeinfoext = new ImplTypeOfMeta();
        }

        return __typeinfoext;
    }

    static if(__traits(compiles, typeof(super).metaof))
    {
        override typeof(__typeinfoext) getMetaType()
        {
            return T.metaof;
        }
    }
    else static if(is(T))
    {
        typeof(__typeinfoext) getMetaType()
        {
            return T.metaof;
        }
    }
    else
    {
        typeof(__typeinfoext) getMetaType()
        {
            return metaof;
        }
    }
}
