
module witchcraft.mixins.base;

mixin template Witchcraft()
{
    import witchcraft;

    static if(is(typeof(this) == class))
    {
        private static Class __typeinfoext;
    }
    else static if(is(typeof(this) == struct))
    {
        private static Struct __typeinfoext;
    }
    else static if(is(typeof(this) == interface))
    {
        private static InterfaceType __typeinfoext;
    }
    else static if(!is(typeof(this)))
    {
        private static Module __typeinfoext;
    }

    @property
    static typeof(__typeinfoext) metaof()
    {
        mixin WitchcraftClass;
        mixin WitchcraftConstructor;
        mixin WitchcraftField;
        mixin WitchcraftInterface;
        mixin WitchcraftMethod;
        mixin WitchcraftStruct;

        if(__typeinfoext is null)
        {
            static if(is(typeof(this) == class))
            {
                __typeinfoext = new ClassMixin!(typeof(this));
            }
            else static if(is(typeof(this) == struct))
            {
                __typeinfoext = new StructMixin!(typeof(this));
            }
            else static if(is(typeof(this) == interface))
            {
                __typeinfoext = new InterfaceTypeMixin!(typeof(this));
            }
            else static if(!is(typeof(this)))
            {
                __typeinfoext = new ModuleImpl!(__traits(parent, __typeinfoext));
            }
        }

        return __typeinfoext;
    }

    static if(__traits(compiles, typeof(super).metaof))
    {
        override typeof(__typeinfoext) getMetaType()
        {
            return typeof(this).metaof;
        }
    }
    else static if(is(typeof(this)))
    {
        typeof(__typeinfoext) getMetaType()
        {
            return typeof(this).metaof;
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
