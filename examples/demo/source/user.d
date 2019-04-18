module user;

import witchcraft;


interface IUser : ClassAccessor {
    string getName();
}

abstract class AbstractUser(T) : IUser {
    mixin Witchcraft;
    abstract string getName();
}

@Annotation @Table("nothing")
@("string")
class User : AbstractUser!(int) {
    mixin Witchcraft;

    string username;
    string password;
    int age;

    private string male;

    this() {
        username = "noname";
        password = "123456";
        age = 20;
    }

    this(string username, string password) {
        this.username = username;
        this.password = password;
    }


    void setUser(string name, int age) {
        this.username = name;
        this.age = age;
    }
    
    void setUser(string name, string password) {
        this.username = name;
        this.password = password;
    }


    void setUserName(string name) {
        this.username = name;
    }

    override string getName() {
        return username;
    }

    int getAge() {
        return age;
    }

    void setAge(int age) {
        this.age = age;
    }

    private void testPrivateMethod() {

    }

    static void testStaticMethod() {

    }
}

interface Annotation {
}

struct Table {
    string name;
}