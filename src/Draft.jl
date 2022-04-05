module Draft

import Pkg
import Suppressor

export @reuse
export online 
export silent
export save_environment 
export remove_persitance, make_persitent

const SILENT = Ref(true)

# this function is executed upon loading the module
function __init__()
    if isonothing(Base.ACTIVE_PROJECT[])
        Pkg.offline()
        Pkg.activate(temp = true)
    end
end

"""
Save the current Project.toml into a target directory
"""
function save_environment(target; overwrite=false)
    filepath = joinpath(target, "Project.toml")
    if !isfile(filepath) || overwrite
        if !isdir(target)
            mkpath(target)
        end
        cp(Base.active_project(), filepath)
    else
        println("$filepath exists. To overwrite it, use `overwrite=true`")
    end
end

"""
Disable offline mode
Equal to Pkg.offline(false)
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
Can be used instead of `using`

When the project is in offline mode the package will be automatically added to the current environment
If the project is not in offline mode it is equal to using
"""
macro reuse(pkgs...)
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

"""
Adds a startup.jl in .julia/config and loads the Draft module
This enables draft mode by default.
To disable this setting please remove the added draft config section.
This might get automated with `Draft.remove_persitance()`
"""
function make_persitent()
    startup_file = joinpath(Base.DEPOT_PATH[1], "config", "startup.jl")
    if !isfile(startup_file)
        mkpath(dirname(startup_file))
        touch(startup_file)
    end
    _add_startup_config(startup_file)
end

"""
Should remove the automatic loading of the Draft module from the startup.jl file
Current only prints a message and the location of the file.
"""
function remove_persitance()
    println("WIP")
    println("Please, manually remove the draft config section from your startup.jl file.")
    startup_file = joinpath(Base.DEPOT_PATH[1], "config", "startup.jl")
    println("\t", startup_file)
end

function _add_startup_config(file)
    open(file, "a") do io
        write(
            io,
            """
            #### draft config
            # Config was added by `Draft.make_persitent()`
            # To deactivate draft mode delete this section-
            using Draft
            #### end draft config
            """,
        )
    end
    nothing
end

end
