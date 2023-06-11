using QUBOInstaces: _docs!

if "--run" ∈ ARGS
    if "--verbose" ∈ ARGS
        _docs!(; verbose=true)
    else
        _docs!()
    end
end
