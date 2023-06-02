using JuliaFormatter

include("_util.jl")

function generate_readme(path)
    metadata = get_metadata(path)
    filepath = joinpath(path, "README.md")
    template = """
    # $(metadata["code"])

    Source: "_$(haskey(metadata, "source") ? metadata["source"] : "?")_"
    Authors: $(join(metadata["authors"], ", "))

    |  Problem  | $(metadata["problem"]) |
    | :-------: | :--------------------: |
    | Instances |  $(metadata["size"])   |
    """

    write(filepath, template)

    while !JuliaFormatter.format_file(filepath; format_markdown=true)
    end

    return nothing
end

function main(; verbose::Bool=false)
    for path in listdirs(DATA_PATH)
        generate_readme(path)

        verbose && @info "Generated README @ $(path)"
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
