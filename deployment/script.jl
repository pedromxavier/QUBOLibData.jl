import Pkg

# Install QUBOInstances.jl
Pkg.activate(; temp=true)
Pkg.add(url="https://github.com/pedromxavier/QUBOInstances.jl", rev="main")

using QUBOInstances

let index = QUBOInstances.create_index(abspath(@__DIR__, ".."))
    @info "Root path: $(index.root_path)"
    @info "Dist path: $(index.dist_path)"

    QUBOInstances.curate!(index)
    QUBOInstances.hash!(index)
    QUBOInstances.deploy!(index)

    ENV["GIT_TREE_HASH"]    = index.tree_hash[]::String
    ENV["NEXT_QUBOLIB_TAG"] = index.next_tag[]::String
end
