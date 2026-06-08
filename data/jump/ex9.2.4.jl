using JuMP
function build_model(; I = 1:2)
    model = Model()
    @variable(model, l1)
    @variable(model, x >= 0)
    @variable(model, y1 >= 0)
    @variable(model, y2 >= 0)
    @variable(model, s[I] >= 0)
    @variable(model, l[I] >= 0)
    @constraint(model, c1, y1 + y2 == x)
    @constraint(model, c2, - y1 + s[1] == 0)
    @constraint(model, c3, - y2 + s[2] == 0)
    @constraint(model, kt1, y1 + l1 - l[1] == 0)
    @constraint(model, kt2, 1 + l1 - l[2] == 0)
    @constraint(model, compl[i in I], l[i] ⟂ s[i])
    @objective(model, Min, 0.5 * (y1 - 2) * (y1 - 2) + 0.5 * (y2 - 2) * (y2 - 2))
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
