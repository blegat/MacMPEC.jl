using JuMP
function build_model(; I = 1:6)
    model = Model()
    @variable(model, x1 >= 0)
    @variable(model, x2 >= 0)
    @variable(model, y1 >= 0)
    @variable(model, y2 >= 0)
    @variable(model, s[I] >= 0)
    @variable(model, l[I] >= 0)
    @constraint(model, c1, 0.5 - y1 + s[1] == 0)
    @constraint(model, c2, 0.5 - y2 + s[2] == 0)
    @constraint(model, c3, y1 - 1.5 + s[3] == 0)
    @constraint(model, c4, y2 - 1.5 + s[4] == 0)
    @constraint(model, kt1, 2 * (y1 - x1) - l[1] + l[3] == 0)
    @constraint(model, kt2, 2 * (y2 - x2) - l[2] + l[4] == 0)
    @constraint(model, compl[i in I], l[i] ⟂ s[i])
    @objective(model, Min, x1 * x1 - 2 * x1 + x2 * x2 - 2 * x2 + y1 * y1 + y2 * y2)
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
