# witchcraft
Extensions to runtime reflection in D.

Witchcraft provides enhanced runtime reflection facilities for D classes. It provides a means to interact with fields, functions, constructors, classes, and user-defined attributes at runtime (features D is sadly lacking). All of this happens through a simple and familiar API inspired by Java's `java.reflect` package.

## Mix in some Witchcraft

Start with a simple class, mix in some Witchcraft,

```d
import witchcraft;

class User
{
    mixin Witchcraft;
    
    string username;
    string password;
    string email;
}
```

And now you have some amazing new runtime reflection powers to play with.

```d
void main()
{
    Class c = User.getClass;
    
    // Create a new user object,
    User user = cast(User) c.create;
    
    // Iterate over fields . . .
    foreach(field; c.getFields)
    {
        // Get value on instance 'user'
        field.get(user).writeln;
    }
}
```

## Caveats

 - Every class that needs reflective capabilities must mixin `Witchcraft`. This includes children of classes that already do!
 - Witchcraft reflection completely ignores protection attributes. Private fields and functions are accessible from everywhere through reflection. (although this may be a benefit in some cases!)

## License

MIT
