import Pkg

# Install QUBOLib.jl
Pkg.activate(; temp=true)
Pkg.add(url="https://github.com/pedromxavier/QUBOLib.jl", rev="main")

using QUBOLib

let index = QUBOLib.create_index(abspath(@__DIR__, ".."))
    @info "Root path: $(index.root_path)"
    @info "Dist path: $(index.dist_path)"

    @info "Curating benchmark data..."
    QUBOLib.curate!(index)

    @info "Computing tree hash..."
    QUBOLib.hash!(index)

    @info "Generating distribution..."
    QUBOLib.deploy!(index)

    @info "Assigning next release tag..."
    QUBOLib.tag!(index)

    @info "Updating environment variables..."
    ENV["GIT_TREE_HASH"]    = index.tree_hash[]::String
    ENV["NEXT_QUBOLIB_TAG"] = index.next_tag[]::String

    let path = abspath(@__DIR__, "tree.hash")
        write(path, ENV["GIT_TREE_HASH"])

        @info "GIT_TREE_HASH = $(ENV["GIT_TREE_HASH"]) written to $(path)"
    end

    let path = abspath(@__DIR__, "next.tag")
        write(path, ENV["NEXT_QUBOLIB_TAG"])

        @info "NEXT_QUBOLIB_TAG = $(ENV["NEXT_QUBOLIB_TAG"]) written to $(path)"
    end
end
