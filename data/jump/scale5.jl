using JuMP
function build_model(; a = 100.0)
    model = Model()
    @variable(model, x1)
    @variable(model, x2)
    @constraint(model, compl, x1 ⟂ x2)
    @objective(model, Min, a * (x1 - 1) ^ 2 + a * (x2 - 1) ^ 2)
    return model
end

function build_model(path::String)
    schema = JuMPConverter.AMPL.DatSchema(
        Dict{Symbol,Int}(
            :a => 0,
        )
    )
    data = if isdir(path)
        JuMPConverter.AMPL.read_csv(path, schema)
    else
        JuMPConverter.AMPL.read_dat(path, schema)
    end
    return build_model(; data...)
end
