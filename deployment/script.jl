import Pkg

# Install QUBOInstances.jl
Pkg.activate(; temp=true)
Pkg.add(url="https://github.com/pedromxavier/QUBOInstances.jl", rev="main")

using QUBOInstances
const INDEX = QUBOInstances.InstanceIndex(abspath(@__DIR__, "..", ".."))

QUBOInstances.curate(INDEX)
QUBOInstances.hash!(INDEX)
QUBOInstances.deploy(INDEX)

ENV["GIT_TREE_HASH"] = INDEX.tree_hash[]::String
ENV["NEXT_RELEASE_TAG"] = INDEX.next_tag[]::String
