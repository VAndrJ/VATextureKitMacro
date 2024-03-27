# VATextureKitMacro


[![Support Ukraine](https://img.shields.io/badge/Support-Ukraine-FFD500?style=flat&labelColor=005BBB)](https://opensource.fb.com/support-ukraine)


[VATextureKit](https://github.com/VAndrJ/VATextureKit) Macro additions.


### @Layout


Triggers a layout update whenever the wrapped variable's value changes.


```
@Layout var someVariable = false

// expands to

var someVariable = false {
    didSet {
        setNeedsLayout()
    }
}
```


### @DistinctLayout


Triggers a layout update whenever the wrapped variable's value changes only if the new value is distinct from the old value.


```
@DistinctLayout var someVariable = false

// expands to

var someVariable = false {
    didSet {
        guard oldValue != someVariable else {
            return
        }

        setNeedsLayout()
    }
}
```


### @ScrollLayout


Triggers a layout update whenever the wrapped variable's value changes.


```
@ScrollLayout var someVariable = false

// expands to

var someVariable = false {
    didSet {
        scrollNode.setNeedsLayout()
    }
}
```


### @DistinctScrollLayout


Triggers a layout update whenever the wrapped variable's value changes only if the new value is distinct from the old value.


```
@DistinctScrollLayout var someVariable = false

// expands to

var someVariable = false {
    didSet {
        guard oldValue != someVariable else {
            return
        }

        scrollNode.setNeedsLayout()
    }
}
```
