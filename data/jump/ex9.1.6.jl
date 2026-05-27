using JuMP
function build_model(; I = 1:6)
    model = Model()
    @variable(model, x >= 0)
    @variable(model, y >= 0)
    @variable(model, s[I] >= 0)
    @variable(model, l[I] >= 0)
    @constraint(model, c1, - x - 2 * y + s[1] == - 10)
    @constraint(model, c2, x - 2 * y + s[2] == 6)
    @constraint(model, c3, 2 * x - y + s[3] == 21)
    @constraint(model, c4, x + 2 * y + s[4] == 38)
    @constraint(model, c5, - x + 2 * y + s[5] == 18)
    @constraint(model, c6, - y + s[6] == 0)
    @constraint(model, kt1, 3 - 2 * l[1] - 2 * l[2] - l[3] + 2 * l[4] + 2 * l[5] - l[6] == 0)
    @constraint(model, compl[i in I], l[i] ⟂ s[i])
    @objective(model, Min, - x - 3 * y)
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
