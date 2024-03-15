using JSON
using JSONSchema

const ROOT_PATH = dirname(@__DIR__)
const DIST_PATH = joinpath(ROOT_PATH, "dist")
const DATA_PATH = joinpath(ROOT_PATH, "collections")

const METADATA_SCHEMA = JSONSchema.Schema(JSON.parsefile(joinpath(@__DIR__, "metadata.schema.json")))

function listdirs(path::AbstractString)
    return abspath.(filter(isdir, readdir(path; join=true)))
end

const PROBLEM_TYPES = Dict{String,String}(
    "3R3X" => "3-Regular 3-XORSAT",
    "5R5X" => "3-Regular 3-XORSAT",
)

function texscape(s::AbstractString)
    return replace(
        s,
        raw"%" => raw"\%",
        raw"&" => raw"\&",
        raw"_" => raw"\_",     
    )
end

function get_metadata(path::AbstractString; validate::Bool = true)
    @assert isdir(path)

    collection = basename(path)
    
    metadata_path = joinpath(path, "metadata.json")
        
    @assert isfile(metadata_path)

    metadata = JSON.parsefile(metadata_path)

    if validate
        report = JSONSchema.validate(METADATA_SCHEMA, metadata)

        if !isnothing(report)
            error(
                """
                Invalid collection metadata for $(collection):
                $(report)
                """
            )
        end
    end

    return metadata
end
