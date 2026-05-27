using JuMP
function build_model(; I = 1:5)
    model = Model()
    @variable(model, x1 >= 0)
    @variable(model, x2 >= 0)
    @variable(model, y1 >= 0)
    @variable(model, y2 >= 0)
    @variable(model, y3 >= 0)
    @variable(model, s[I] >= 0)
    @variable(model, l[I] >= 0)
    @constraint(model, c0, x1 + x2 <= 2)
    @constraint(model, c1, - 2 * x1 + y1 - y2 + s[1] == - 2.5)
    @constraint(model, c2, x1 - 3 * x2 + y2 + s[2] == 2)
    @constraint(model, c3, - y1 + s[3] == 0)
    @constraint(model, c4, - y2 + s[4] == 0)
    @constraint(model, kt1, l[1] - l[3] == 4)
    @constraint(model, kt2, l[1] + l[2] - l[4] == - 1)
    @constraint(model, compl[i in I], l[i] ⟂ s[i])
    @objective(model, Min, - 2 * x1 + x2 + 0.5 * y1)
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
