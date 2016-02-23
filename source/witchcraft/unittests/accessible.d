
module witchcraft.unittests.accessible;

version(unittest)
{
    import witchcraft;

    private class Secret
    {
        bool b;

        this()
        {
        }

        this(bool b)
        {
        }

        int foo()
        {
            return 5;
        }
    }

    class Foo : Secret
    {
        int x;
        int y;

        private int z;

        this()
        {
        }

        private this(int x, int y)
        {
        }

        int bar()
        {
            return x + y + z;
        }
    }

    class Bar : Foo
    {
        mixin Witchcraft;

        string name;

        int foobar()
        {
            return foo * bar;
        }
    }
}

unittest
{
    auto bClass = Bar.classof;
    assert(bClass !is null);

    assert(bClass.getName == "Bar");
    assert(bClass.isAccessible == true);
    assert(bClass.getField("name").isAccessible == true);

    version(aggressive)
    {
        assert(bClass.getSuperClass.getName == "Foo");
        assert(bClass.getSuperClass.isAccessible == true);
        assert(bClass.getSuperClass.getField("x").isAccessible == true);
        assert(bClass.getSuperClass.getField("y").isAccessible == true);
        assert(bClass.getSuperClass.getField("z").isAccessible == false);

        assert(bClass.getSuperClass.getSuperClass.getName == "Secret");
        assert(bClass.getSuperClass.getSuperClass.isAccessible == false);
    }
    else
    {
        assert(bClass.getSuperClass is null);
    }
}
