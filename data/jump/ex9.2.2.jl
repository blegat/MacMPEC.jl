using JuMP
function build_model(; I = 1:4)
    model = Model()
    @variable(model, x >= 0)
    @variable(model, y >= 0)
    @variable(model, s[I] >= 0)
    @variable(model, l[I] >= 0)
    @constraint(model, o1, x <= 15)
    @constraint(model, o2, - x + y <= 0)
    @constraint(model, o3, - x <= 0)
    @constraint(model, c1, x + y + s[1] == 20)
    @constraint(model, c2, - y + s[2] == 0)
    @constraint(model, c3, y + s[3] == 20)
    @constraint(model, kt1, 2 * (x + 2 * y - 30) + l[1] - l[2] + l[3] == 0)
    @constraint(model, compl[i in I], l[i] ⟂ s[i])
    @objective(model, Min, x * x + (y - 10) * (y - 10))
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
