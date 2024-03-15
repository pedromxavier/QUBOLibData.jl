include("_util.jl")

function index_collection(path::AbstractString)

end

function index()

end

function main(; verbose=true)

    return nothing
end

if "--run" ∈ ARGS
    if "--verbose" ∈ ARGS
        main(; verbose=true)
    else
        main()
    end
end