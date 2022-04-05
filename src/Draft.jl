module Draft

import Pkg
import Suppressor

export @reuse
export save_environment

const SILENT = Ref(true)

#
# This function is executed upon loading the module, and will activate a new offline temporary environment. 
#
function __init__()
    if isnothing(Base.ACTIVE_PROJECT[])
        Pkg.offline()
        Pkg.activate(temp = true)
    end
end

"""
```
save_environment(target::String; overwrite = false, switch = true)
```

Save the current `Project.toml` and `Manifest.toml` to a target directory, and switch (by default) the environment to the new created environment.

`target` must be a directory path where the `Project.toml` file will be saved.  

## Example

```julia-repl
julia> save_environment("/tmp/my_draft")
  Activating project at `/tmp/my_draft`

(my_draft) [offline] pkg>
```

"""
function save_environment(target; overwrite = false, switch = true)
    current_project_dir = dirname(Base.active_project())
    project = joinpath(target, "Project.toml")
    manifest = joinpath(target, "Manifest.toml")
    if !isfile(project) || overwrite
        if !isdir(target)
            mkpath(target)
        end
        cp(joinpath(current_project_dir, "Project.toml"), project)
        cp(joinpath(current_project_dir, "Manifest.toml"), manifest)
        switch && Pkg.activate(target)
    else
        println("$project exists. To overwrite it, use `overwrite=true`")
    end
end

"""
```
Draft.online()
```

Disable offline mode. Equal to Pkg.offline(false)

"""
function online()
    Pkg.offline(false)
end

"""
Set the silent mode of Draft
This suppresses the output of `Pkg.add` when using `@reuse`
Pass false as the first argument to undo this
"""
function silent(b::Bool = true)
    Draft.SILENT[] = b
end

"""

```
@reuse PackageA
```

```
@reuse PackageA PackageB
```

The `@reuse` macro can be used to replace `using`.

When the project is in offline mode the package will be automatically added to the current environment if
it is available in the local package depot. 

If the project is not in offline mode it is equal to using.

## Example

```julia-repl
julia> using Draft
  Activating new project at `/tmp/jl_gk9X9X`

julia> @reuse StaticArrays

julia> rand(SVector{2,Float64})
2-element SVector{2, Float64} with indices SOneTo(2):
 0.24945757907137645
 0.8924266071867566
```

"""
macro reuse(pkgs...)
    if eltype(pkgs) != Symbol
        throw(ArgumentError("Usage: @reuse PackageA PackageB"))
    end
    expressions = map(pkgs) do pkg
        quote
            if Pkg.OFFLINE_MODE[]
                if Draft.SILENT[]
                    Draft.Suppressor.@suppress Pkg.add($(string(pkg)))
                else
                    Pkg.add($(string(pkg)))
                end
            end
            using $pkg
        end
    end
    quote
        $(expressions...)
    end
end

end
