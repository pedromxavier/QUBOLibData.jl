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

    cd(ROOT_PATH) do
        # Generate name for temporary branch
        branch = string(uuid4())

        # Create 'dist' branch if not exists, reset it otherwise
        run(`git checkout -B dist`)

        # Move to temporary branch
        run(`git checkout --orphan $branch`)

        # Delete everything from git history
        run(`git rm -rf .`)

        # Assert that 'dist' folder is still there
        @assert isdir(datapath)

        # Bring .gitignore and LICENSE back
        run(`git checkout HEAD -- .gitignore LICENSE`)

        # Add 'dist' folder and the aforementioned files back
        run(`git add .`)

        # Commit
        run(`git commit -m "Distribute data"`)

        # Upload branch (is this necessary?)
        run(`git push --set-upstream origin $branch`)

        # Overwrite 'dist' branch with contents from temporary branch
        run(`git push origin +$branch:dist`)

        # Move to the 'dist' branch
        run(`git checkout dist`)

        # Delete temporary branch locally ...
        run(`git branch -d $branch`)

        # ... and remotely
        run(`git push origin --delete $branch`)
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
