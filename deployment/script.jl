import Pkg

# Install QUBOInstances.jl
Pkg.activate(; temp=true)
Pkg.add(url="https://github.com/pedromxavier/QUBOInstances.jl", rev="main")

using QUBOInstances

let index = QUBOInstances.create_index(abspath(@__DIR__, ".."))
    @info "Root path: $(index.root_path)"
    @info "Dist path: $(index.dist_path)"

    @info "Curating benchmark data..."
    QUBOInstances.curate!(index)

    @info "Computing tree hash..."
    QUBOInstances.hash!(index)

    @info "Generating distribution..."
    QUBOInstances.deploy!(index)

    @info "Assigning next release tag..."
    QUBOInstances.tag!(index)

    @info "Updating environment variables..."
    ENV["GIT_TREE_HASH"]    = index.tree_hash[]::String
    ENV["NEXT_QUBOLIB_TAG"] = index.next_tag[]::String

    @info ENV["GIT_TREE_HASH"]
    @info ENV["NEXT_QUBOLIB_TAG"]
end
