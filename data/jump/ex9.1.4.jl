using JuMP
function build_model(; I = 1:4)
    model = Model()
    @variable(model, x >= 0)
    @variable(model, y >= 0)
    @variable(model, s[I] >= 0)
    @variable(model, l[I] >= 0)
    @constraint(model, c2, - 2 * x + y + s[1] == 0)
    @constraint(model, c3, 2 * x + 5 * y + s[2] == 108)
    @constraint(model, c4, 2 * x - 3 * y + s[3] == - 4)
    @constraint(model, c5, - y + s[4] == 0)
    @constraint(model, kt1, l[1] + 5 * l[2] - 3 * l[3] - l[4] == - 1)
    @constraint(model, compl[i in I], l[i] ⟂ s[i])
    @objective(model, Min, x - 4 * y)
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
