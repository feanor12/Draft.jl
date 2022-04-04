# Draft (WIP)


Package for faster prorotyping.

* Enables offline mode when the module is loaded for a faster package adding. This can only reused locally installed packages.
* Enables a temporary directory when the module is loaded and to project is
  loaded
* Provides macro to aĺoad and install a package `@reuse packagename`
* Output of `@reuse` can be suppressed by calling `silent()`. Undo with `silent(false)`
* Provides function to switch back to online mode `online()`
* Provides function to save the temporary Project.toml file to a target
  location `save_environment(target_dir)`
* Can make an entry to your startup.jl file to automatically load the Draft
  module (`make_persitant()`). 
* To undo the startup.jl setting currently only a placeholder function is exported `remove_persistance()`.

## Install

```
] add https://github.com/feanor12/Draft.jl.git
```

## First Steps

``` julia
# enable / load Draft
using Draft
# load Unitful (works only if locally available)
@reuse Unitful
```

