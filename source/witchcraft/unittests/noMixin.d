
module witchcraft.unittests.noMixin;

import witchcraft;

version(unittest)
{
    import std.algorithm;
    import std.array;

    struct Entity
    {
    }

    struct Column
    {
        string name;
    }

    @Entity
    class User
    {
        @Column
        string username;

        @Column("pass_word")
        string password;

        string email;

        ulong createdAt;
        ulong updatedAt;

        this()
        {
        }

        this(string email)
        {
            this.email = email;
        }

        void updateEmail(string email)
        {
            this.email = email;
            updatedAt += 1;
        }
    }
    
    void testSuite(C)(C metaObject){
        assert(metaObject.isAggregate == true);
        assert(metaObject.isClass     == true);
        assert(metaObject.isStruct    == false);

        /+ - Classes - +/

        assert(metaObject.getName     == "User");
        assert(metaObject.getFullName == "witchcraft.unittests.noMixin.User");
        assert(metaObject.isAbstract  == false);
        assert(metaObject.isFinal     == false);

        /+ - Class Attributes - +/

        assert(metaObject.getAttributes.empty        == false);
        assert(metaObject.getAttributes!Entity.empty == false);
        assert(metaObject.getAttributes!Column.empty == true);

        assert(metaObject.getAttributes!Entity[0].isType       == true);
        assert(metaObject.getAttributes!Entity[0].isExpression == false);

        /+ - Constructors - +/

        assert(metaObject.getConstructors.length == 2);

        assert(metaObject.getConstructor !is null);
        assert(metaObject.getConstructor!string !is null);

        User user = metaObject.getConstructor!string.create!User("test@email.com");

        assert(user !is null);
        assert(user.email == "test@email.com");
        assert(user.updatedAt == 0);

        /+ - Fields - +/

        assert(metaObject.getFieldNames.isPermutation([
            "username", "password", "email", "createdAt", "updatedAt"
        ]));

        assert(metaObject.getField("username") !is null);
        auto username = metaObject.getField("username");

        /+ - Field Attributes - +/

        assert(username.getAttributes.empty        == false);
        assert(username.getAttributes!Entity.empty == true);
        assert(username.getAttributes!Column.empty == false);

        assert(username.getAttributes!Column[0].isType       == true);
        assert(username.getAttributes!Column[0].isExpression == false);

        assert(metaObject.getField("password") !is null);
        auto password = metaObject.getField("password");

        /+ - Field Attributes (Expression) - +/

        assert(password.getAttributes.empty        == false);
        assert(password.getAttributes!Entity.empty == true);
        assert(password.getAttributes!Column.empty == false);

        assert(password.getAttributes!Column[0].isType       == false);
        assert(password.getAttributes!Column[0].isExpression == true);

        assert(password.getAttributes!Column[0].get!Column.name == "pass_word");

        /+ - Methods - +/

        assert(metaObject.getLocalMethodNames == [ "updateEmail" ]);

        assert(metaObject.getMethods("updateEmail").empty == false);
        assert(metaObject.getMethod!(string)("updateEmail") !is null);
        auto updateEmail = metaObject.getMethod!(string)("updateEmail");

        updateEmail.invoke(user, "user@email.com");
        assert(user.email == "user@email.com");
        assert(user.updatedAt == 1);
    }
}

unittest
{
    auto metaObject = getMeta!User();
    assert(metaObject !is null);
    
    testSuite(metaObject);
}
