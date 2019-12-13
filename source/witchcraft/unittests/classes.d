module witchcraft.unittests.classes;

version(unittest)
{
    import witchcraft;

	class User
	{
		mixin Witchcraft;

		string username;
		string password;

		// disabled member variables aren't handled
		// @disable int disabledValue;

		@disable this();
		@disable bool opEquals(string)(Foo);
		
		this(string username, string password)
		{
			this.username = username;
			this.password = password;
		}
	}
    
	class Person
	{
		mixin Witchcraft;

		string name;
		int age;

		this() 
		{ 
			name = "rambo";
			age = 73;
		}

		this(string name, int age)
		{
			this.name = name;
			this.age = age;
		}
	}

    void testSuite(C)(C metaObject)
    {
        assert(metaObject.isAggregate == true);
        assert(metaObject.isClass     == true);
        assert(metaObject.isStruct    == false);

        assert(metaObject.getName     == "User");
        assert(metaObject.getFullName == "witchcraft.unittests.classes.User");
    }
}

unittest
{
    auto metaObjectByProperty = User.metaof;
    auto metaObjectByFunction = getMeta!User();

    assert(metaObjectByProperty !is null);
    assert(metaObjectByFunction !is null);
    
    testSuite(metaObjectByProperty);
    testSuite(metaObjectByFunction);

	Class c = User.metaof;

	// User doesn't have a default ctor
	assert(!__traits(compiles, c.create!T));
	auto u = c.create;
	assert(u is null);

	Class p = Person.metaof;
	Person rambo = cast(Person) p.create;
	assert(rambo.age == 73);
	assert(rambo.name == "rambo");
}
