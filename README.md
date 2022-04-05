# Draft (WIP)

Package for faster prototyping without widespread implications for your Julia default installation. 

* Activates a temporary project when the module is loaded.
* Enables offline mode when the module is loaded for a faster package adding. Locally installed packages will be reused.
* Provides a macro to load and install a package `@reuse PackageA` or `@reuse PackageA PackageB`.
* Output of `@reuse` can be suppressed by calling `Draft.silent()`. Undo with `Draft.silent(false)`.
* Provides a function to switch back to online mode: `Draft.online()`.
* Provides a function to save the temporary Project.toml file to a target location: `save_environment(target_dir)`.

## Install

```julia
] add https://github.com/feanor12/Draft.jl
```
or
```julia
import Pkg
Pkg.add(url="https://github.com/feanor12/Draft.jl")
```

## First Steps

``` julia
# enable / load Draft
using Draft
# load StaticArrays and Unitful (works only if locally available)
@reuse StaticArrays Unitful
# save temporary environment 
save_environment("./my_project")
```

## Persistent usage

If you want  this package to be loaded by default, install it in your base environment and add 
```julia
using Draft
```
to the `.julia/config/startup.jl` file.
