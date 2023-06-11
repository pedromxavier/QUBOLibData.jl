using QUBOInstaces: _build!

if "--run" ∈ ARGS
    if "--verbose" ∈ ARGS
        _build!(; verbose=true)
    else
        _build!()
    end
end
