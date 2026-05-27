using JuMP
function build_model(; I = 1:4)
    model = Model()
    @variable(model, x >= 0)
    @variable(model, y >= 0)
    @variable(model, s[I] >= 0)
    @variable(model, l[I] >= 0)
    @constraint(model, c1, - 3 * x + y + s[1] == - 3)
    @constraint(model, c2, x - 0.5 * y + s[2] == 4)
    @constraint(model, c3, x + y + s[3] == 7)
    @constraint(model, c4, - y + s[4] == 0)
    @constraint(model, kt1, 2 * (y - 1) - 1.5 * x + l[1] - 0.5 * l[2] + l[3] - l[4] == 0)
    @constraint(model, compl[i in I], l[i] ⟂ s[i])
    @objective(model, Min, (x - 5) * (x - 5) + (2 * y + 1) * (2 * y + 1))
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
