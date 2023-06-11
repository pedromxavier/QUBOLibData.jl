using QUBOInstaces: _tag!

if "--run" ∈ ARGS
    if "--verbose" ∈ ARGS
        _tag!(; verbose=true)
    else
        _tag!()
    end
end
