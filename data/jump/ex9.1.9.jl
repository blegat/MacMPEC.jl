using JuMP
function build_model(; I = 1:5)
    model = Model()
    @variable(model, x >= 0)
    @variable(model, y >= 0)
    @variable(model, s[I] >= 0)
    @variable(model, l[I] >= 0)
    @constraint(model, c2, - x - 0.5 * y + s[1] == - 2)
    @constraint(model, c3, - 0.25 * x + y + s[2] == 2)
    @constraint(model, c4, x + 0.5 * y + s[3] == 8)
    @constraint(model, c5, x - 2 * y + s[4] == 2)
    @constraint(model, c6, - y + s[5] == 0)
    @constraint(model, kt1, - 0.5 * l[1] + l[2] + 0.5 * l[3] - 2 * l[4] - l[5] == 1)
    @constraint(model, compl[i in I], l[i] ⟂ s[i])
    @objective(model, Min, x + y)
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
