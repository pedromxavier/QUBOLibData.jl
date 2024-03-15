using JuliaFormatter

include("_util.jl")

function generate_references(metadata)
    if !haskey(metadata, "source") || isempty(metadata["source"])
        return ""
    end

    items = []

    for data in copy.(metadata["source"])
        data["author"] = join(data["author"], " and ")

        doctype = pop!(data, "type", "misc")
        citekey = pop!(data, "citekey", "citekey")
        keysize = maximum(length.(keys(data)))
        entries = join([
                "  $(rpad(k, keysize)) = {$(texscape(string(v)))}"
                for (k, v) in data
            ],
            "\n"
        )

        bibitem = """
        ```tex
        @$doctype{$citekey,
        $entries
        }
        ```
        """

        push!(items, bibitem)
    end

    references = join(items, "\n\n")

    return """
    ## References

    $references
    """
end

function generate_summary_table(metadata::Dict{String,Any})
    col_size    = metadata["size"]
    sizes       = metadata["problem"]["sizes"]
    type        = metadata["problem"]["type"]
    name        = PROBLEM_TYPES[type]
    file_format = metadata["format"]

    if isempty(sizes)
        size_range = "?"
    else
        a, b = extrema(sizes)
        size_range = "$a - $b"
    end

    return """
    ## Summary

    |  Problem    | $(name)          |
    | :---------: | :--------------: |
    | Instances   |  $(col_size)     |
    | Size range  |  $(size_range)   |
    | File format | $(file_format)   |
    """
end

function generate_collection_readme(path)
    metadata = get_metadata(path)
    filepath = joinpath(path, "README.md")

    code = metadata["code"]
    summ = generate_summary_table(metadata)
    refs = generate_references(metadata)

    readme = """
    # $code 

    $summ

    ---

    $refs
    """

    write(filepath, readme)

    while !JuliaFormatter.format_file(filepath; format_markdown=true)
    end

    return nothing
end

function generate_index_readme()
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

    generate_index_readme()

    return nothing
end

if "--run" ∈ ARGS
    if "--verbose" ∈ ARGS
        main(; verbose=true)
    else
        main()
    end
end
