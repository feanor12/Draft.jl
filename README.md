# Draft (WIP)


Package for faster prototyping.

* Enables offline mode when the module is loaded for a faster package adding. This can only reused locally installed packages.
* Activates a temporary project when the module is loaded.
* Provides a macro to ĺoad and install a package `@reuse packagename`.
* Output of `@reuse` can be suppressed by calling `silent()`. Undo with `silent(false)`.
* Provides a function to switch back to online mode: `online()`.
* Provides a function to save the temporary Project.toml file to a target
  location: `save_environment(target_dir)`.
* Can make an entry to your startup.jl file to automatically load the Draft
  module: `make_persitant()`. 
* To undo the startup.jl setting currently only a placeholder function is exported `remove_persistance()`.

## Install

```
] add https://github.com/feanor12/Draft.jl.git
```
or
```julia
import Pkg
Pkg.add(Pkg.PackageSpec(url="https://github.com/feanor12/Draft.jl.git"))
```

## First Steps

``` julia
# enable / load Draft
using Draft
# load Unitful (works only if locally available)
@reuse Unitful
```

