using JSON

include("_util.jl")

function main(; verbose=true)
    jsonpath = joinpath(ROOT_PATH, "latest.json")

    if isfile(jsonpath)
        run(`cat $jsonpath`)

        error("stop!")

        data = JSON.parsefile(jsonpath)

        verbose && @show data

        # latest_tag = data["..."]

        tagpath = joinpath(ROOT_PATH, "tag.txt")

        # new_tag = VersionNumber(
        #     latest_tag.major,
        #     latest_tag.minor,
        #     latest_tag.patch,
        #     latest_tag.prerelease,
        #     latest_tag.build,
        # )

        # write(tagpath, new_tag)
    else
        @warn "File 'latest.json' not found"
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
