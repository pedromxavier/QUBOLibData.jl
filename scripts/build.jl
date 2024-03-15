using Tar
using UUIDs

include("_util.jl")

function main(; verbose::Bool=false)
    # build tarball
    filepath = abspath(Tar.create(DATA_PATH))

    # compress
    run(`gzip -9 $filepath`)
    
    # copy from temporary file and delete it
    distpath = mkpath(joinpath(DIST_PATH, "collections.tar.gz"))

    cp("$filepath.gz", distpath; force=true)

    rm(filepath; force = true)

    return nothing
end

if "--run" ∈ ARGS
    if "--verbose" ∈ ARGS
        main(; verbose=true)
    else
        main()
    end
end
