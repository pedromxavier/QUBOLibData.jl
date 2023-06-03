using JuliaFormatter

include("_util.jl")

function generate_collection_readme(path)
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

function generate_summary_readme()
    filepath = joinpath(DATA_PATH, "README.md")
    pathlist = listdirs(DATA_PATH)
    namelist = basename.(pathlist)
    hreflist = relpath.(pathlist, DATA_PATH)
    itemlist = join(
        ["- [$name]($href)" for (name, href) in zip(namelist, hreflist)],
        "\n"
    )

    template = """
    # QUBO Instance Collections
    
    $(itemlist)
    """

    write(filepath, template)

    return nothing
end

function main(; verbose::Bool=false)
    pathlist = listdirs(DATA_PATH)

    for path in pathlist
        generate_collection_readme(path)

        verbose && @info "Generated README @ $(path)"
    end

    generate_summary_readme()

    return nothing
end

if "--run" ∈ ARGS
    if "--verbose" ∈ ARGS
        main(; verbose=true)
    else
        main()
    end
end