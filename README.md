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
    Class c = User.metaof;
    // ... or new User().getMetaType;

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

### Fields, Methods, and Constructors

Witchcraft grants runtime access to all fields, methods, and constructors of any type it is mixed into. Fields and methods alike are easily accessible en-masse (returned as an array), or individually given by name. Methods and constructors are both also accessible based on their overloads.

```d
// Access to fields and methods.
Field[] fields = c.getFields;
Method[] method = c.getMethods;

// Access to a field by name.
Field field = c.getField("username");

// Access all overloads of a method by name.
Method[] overloads = c.getMethods("updateEmail");

// Access the updateEmail(string) method.
Method method = c.getMethod!(string)("updateEmail");
```

Once you have your fields and methods, you are free to read, write, and call them. They also provide some useful properties like their types, attributes, parameters types, declaring types, etc. This includes useful properties like `isStatic`, to check if a method is static or bound to and instance of a class.

```d
// Fetch a variant holding the value of user.email
Variant email = c.getField("email").get(user);

// Or... Use a template argument to convert the result.
// string email = as c.getField("email").get!(string)(user);

// And now call user.updateEmail(email)
c.getMethod!(string)("updateEmail").invoke(user, email);

// Or... Use a TypeInfo object instead of template argument.
// c.getMethod("updateEmail", typeid(string)).invoke(user, email);
```

### Attributes

Witchcraft can also do some neat magic with User-Defined Attributes. You can inspect and access UDAs on any field, method, constructor, or type that has reflective capabilities. (That is to say, any type that has `mixin Witchcraft;`, or, keep reading for 'Aggressive Mode'!) Consider,

```d
struct Column
{
    string name;
}

struct User
{
    mixin Witchcraft;

    @Column
    string username;

    @Column("pass_word")
    string password;
}
```

Witchcraft breaks up attributes into 2 types; Type attributes and Expression attributes. Expression attributes are any attributes that can produce a value at runtime, whereas Type attributes are attributes that cannot. Essentially,

```d
Struct s = User.metaof;

// @Column on username cannot produce a value; it's a Type attribute.
Attribute uAttr = s.getField("username").getAttributes!(Column)[0];
assert(uAttr.isType == true);

// @Column("pass_word") produces a value at runtime; it's an Expression attribute.
Attribute pAttr = s.getField("password").getAttributes!(Column)[0];
assert(pAttr.isExpression == true);
```

`getAttributes` may also be called without a parameter to get all attributes on an element, or it can be given either a D `TypeInfo` or Witchcraft `Type` object in place of a template argument.

## Aggressive Mode!

Witchcraft also comes with an option to enable 'Aggressive Mode'. Normally, only types that have `mixin Witchcraft;` can be reflected on, and any types that these may reference (ie. A method return type) must also have Witchcraft in to support reflection.

In Aggressive Mode, Witchcraft will generate meta information for _all_ types that are referenced reflectively (and any types that those types may reference, and so on...). However, for any types that don't mixin Witchcraft, only public members will be accessible. You can test if an element is accessible with the `isAccessible` property.

## Caveats

 - Every class that needs reflective capabilities must mixin `Witchcraft`. This includes children of classes that already do!
 - Witchcraft reflection completely ignores protection attributes. Private fields and functions are accessible from everywhere through reflection. (although this may be a benefit in some cases!)
 - Aggressive Mode is very aggressive! Compile times can take quite a while since meta information will be constructed for every reachable type through any type that is referenced reflectively. (Fields, return types, parameter types, attributes, etc.)

## License

MIT
