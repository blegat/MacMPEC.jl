using JuMP
function build_model(; I = 1:6)
    model = Model()
    @variable(model, x1 >= 0)
    @variable(model, x2 >= 0)
    @variable(model, y1 >= 0)
    @variable(model, y2 >= 0)
    @variable(model, y3 >= 0)
    @variable(model, s[I] >= 0)
    @variable(model, l[I] >= 0)
    @constraint(model, c2, - y1 + y2 + y3 + s[1] == 1)
    @constraint(model, c3, 2 * x1 - y1 + 2 * y2 - 0.5 * y3 + s[2] == 1)
    @constraint(model, c4, 2 * x2 + 2 * y1 - y2 - 0.5 * y3 + s[3] == 1)
    @constraint(model, c5, - y1 + s[4] == 0)
    @constraint(model, c6, - y2 + s[5] == 0)
    @constraint(model, c7, - y3 + s[6] == 0)
    @constraint(model, kt1, - l[1] - l[2] + 2 * l[3] - l[4] == - 1)
    @constraint(model, kt2, l[1] + 2 * l[2] - l[3] - l[5] == - 1)
    @constraint(model, kt3, l[1] - 0.5 * l[2] - 0.5 * l[3] - l[6] == - 2)
    @constraint(model, compl[i in I], l[i] ⟂ s[i])
    @objective(model, Min, - 8 * x1 - 4 * x2 + 4 * y1 - 40 * y2 + 4 * y3)
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
