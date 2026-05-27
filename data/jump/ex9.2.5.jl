using JuMP
function build_model(; I = 1:3)
    model = Model()
    @variable(model, y)
    @variable(model, 0 <= x <= 8)
    @variable(model, s[I] >= 0)
    @variable(model, l[I] >= 0)
    @constraint(model, c1, - 2 * x + y + s[1] == 1)
    @constraint(model, c2, x - 2 * y + s[2] == 2)
    @constraint(model, c3, x + 2 * y + s[3] == 14)
    @constraint(model, kt1, 2 * (y - 5) + l[1] - 2 * l[2] + 2 * l[3] == 0)
    @constraint(model, compl[i in I], l[i] ⟂ s[i])
    @objective(model, Min, (x - 3) * (x - 3) + (y - 2) * (y - 2))
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
