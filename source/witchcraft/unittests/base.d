
module witchcraft.unittests.base;

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
        mixin Witchcraft;

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
}

unittest
{
    assert(User.classof !is null);
    auto class_ = User.classof;

    /+ - Classes - +/

    assert(class_.getName     == "User");
    assert(class_.getFullName == "witchcraft.unittests.base.User");
    assert(class_.isAbstract  == false);
    assert(class_.isFinal     == false);

    /+ - Class Attributes - +/

    assert(class_.getAttributes.empty        == false);
    assert(class_.getAttributes!Entity.empty == false);
    assert(class_.getAttributes!Column.empty == true);

    assert(class_.getAttributes!Entity[0].isType       == true);
    assert(class_.getAttributes!Entity[0].isExpression == false);

    /+ - Constructors - +/

    assert(class_.getConstructors.length == 2);

    assert(class_.getConstructor !is null);
    assert(class_.getConstructor!string !is null);

    User user = class_.getConstructor!string.create!User("test@email.com");

    assert(user !is null);
    assert(user.email == "test@email.com");
    assert(user.updatedAt == 0);

    /+ - Fields - +/

    assert(class_.getFieldNames.isPermutation([
        "username", "password", "email", "createdAt", "updatedAt"
    ]));

    assert(class_.getField("username") !is null);
    auto username = class_.getField("username");

    /+ - Field Attributes - +/

    assert(username.getAttributes.empty        == false);
    assert(username.getAttributes!Entity.empty == true);
    assert(username.getAttributes!Column.empty == false);

    assert(username.getAttributes!Column[0].isType       == true);
    assert(username.getAttributes!Column[0].isExpression == false);

    assert(class_.getField("password") !is null);
    auto password = class_.getField("password");

    /+ - Field Attributes (Expression) - +/

    assert(password.getAttributes.empty        == false);
    assert(password.getAttributes!Entity.empty == true);
    assert(password.getAttributes!Column.empty == false);

    assert(password.getAttributes!Column[0].isType       == false);
    assert(password.getAttributes!Column[0].isExpression == true);

    assert(password.getAttributes!Column[0].get!Column.name == "pass_word");

    /+ - Methods - +/

    assert(class_.getMethodNames.isPermutation([ "getClass", "updateEmail" ]));

    assert(class_.getMethods("updateEmail").empty == false);
    assert(class_.getMethod!(string)("updateEmail") !is null);
    auto updateEmail = class_.getMethod!(string)("updateEmail");

    updateEmail.invoke(user, "user@email.com");
    assert(user.email == "user@email.com");
    assert(user.updatedAt == 1);
}
