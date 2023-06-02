using Tar
using UUIDs

include("_util.jl")

function main(; verbose::Bool = false)
    datapath = mkpath(joinpath(ROOT_PATH, "dist"))

    for path in listdirs(DATA_PATH)
        filepath = Tar.create(path) |> abspath

        run(`gzip -9 $filepath`)

        code = basename(path)

        gzippath = joinpath(datapath, "$code.tar.gz")

        cp("$filepath.gz", gzippath)

        rm("$filepath.gz"; force=true)

        @info "Compressed tarball @ $(gzippath)"
    end

    branch = uuid4()

    cd(ROOT_PATH) do
        run(`git checkout -B data`)

        run(`git checkout --orphan $branch`)
        run(`git rm -rf .`)
        run(`git add .gitignore LICENSE ./dist/*`)
        run(`git push --set-upstream origin $branch`)

        @info "Deployed './dist' folder @ '$branch'"

        run(`git push origin +$branch:data`)
    end

    return nothing
end

if "--run" ∈ ARGS
    if "--verbose" ∈ ARGS
        main(; verbose=true)
    else
        main()
    end
end
