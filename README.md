[![Packagist](https://img.shields.io/packagist/l/doctrine/orm.svg)]()

## Melon

![Melon](melon.png)

Melon enables you to template your markdown files in Swift. Right now, it's still heavily WIP and more of a proof of concept, but it's getting there.

## Installation


## Usage

Melon uses .melon files as markdown templates. 

### Swift

When using Melon you'll have to pass it the path to your template. After doing that, you can set a context. The context contains all variables in a Dictionary.

```swift
if let path = Bundle.main.path(forResource: "welcome", ofType: "melon") {
    let melon = Melon()
    melon.load(template: path)
    melon.context = data
    print(melon.parse())
}
```

### Echo

Melon supports echoeing values by placing them in brackets.

```volt
Hello {{ firstname }} {{lastname}}
```

This will then be converted to include the actual variable values.

```markdown
Hello Sjoerd Janssen
```

### For loops

Melon supports for loops with the following syntax.

```volt
{% for name in names %}
    * {{ name }}
{% endfor %}
```

This will then be converted to include the actual variable values.

```markdown
    * Sjoerd Janssen
    * Mike Duister
```

## License

Melon is licensed under the MIT License, please see the LICENSE file.
