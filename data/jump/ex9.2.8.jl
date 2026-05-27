using JuMP
function build_model(; I = 1:2)
    model = Model()
    @variable(model, 0 <= x <= 1)
    @variable(model, y >= 0)
    @variable(model, s[I] >= 0)
    @variable(model, l[I] >= 0)
    @constraint(model, c1, - y + s[1] == 0)
    @constraint(model, c2, y + s[2] == 1)
    @constraint(model, kt1, - (1 - 4 * x) - l[1] + l[2] == 0)
    @constraint(model, compl[i in I], l[i] ⟂ s[i])
    @objective(model, Min, - 4 * x * y + 3 * y + 2 * x + 1)
    return model
end

function build_model(path::String)
    schema = JuMPConverter.AMPL.DatSchema(
        Dict{Symbol,Int}(
        ),
        [:I],
    )
    data = if isdir(path)
        JuMPConverter.AMPL.read_csv(path, schema)
    else
        JuMPConverter.AMPL.read_dat(path, schema)
    end
    return build_model(; data...)
end
