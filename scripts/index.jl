using QUBOInstaces: _index!

if "--run" ∈ ARGS
    if "--verbose" ∈ ARGS
        _index!(; verbose=true)
    else
        _index!()
    end
end
