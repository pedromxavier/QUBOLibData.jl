# Install QUBOInstances.jl
import Pkg
Pkg.activate(; temp=true)
Pkg.add(url="https://github.com/pedromxavier/QUBOInstances.jl", rev="main")

using QUBOInstances
const ROOT_PATH = abspath(joinpath(@__DIR__, "..", ".."))

QUBOInstances._deploy!(ROOT_PATH; verbose = true)
