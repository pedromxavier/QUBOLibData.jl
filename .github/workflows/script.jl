# Install QUBOInstances.jl
import Pkg
Pkg.activate(; temp=true)
Pkg.add(url="https://github.com/pedromxavier/QUBOInstances.jl", rev="main")

using QUBOInstances

function main(path; verbose::Bool = false)
    coll_path = joinpath(path, "collections")

    QUBOInstances._index!(coll_path; verbose)
    QUBOInstances._document!(coll_path; verbose)
    QUBOInstances._build!(path; verbose)
    QUBOInstances._tag!(path; verbose)

    return nothing
end

main(joinpath(@__DIR__, "..", ".."); verbose = true)
