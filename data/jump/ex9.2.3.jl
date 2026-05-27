using JuMP
function build_model(; I = 1:6)
    model = Model()
    @variable(model, y1 >= - 8)
    @variable(model, y2 >= - 8)
    @variable(model, 1 <= x1 <= 50)
    @variable(model, 1 <= x2 <= 50)
    @variable(model, s[I] >= 0)
    @variable(model, l[I] >= 0)
    @constraint(model, o1, x1 + x2 + y1 - 2 * y2 <= 40)
    @constraint(model, c1, - x1 + 2 * y1 + s[1] == - 10)
    @constraint(model, c2, - x2 + 2 * y2 + s[2] == - 10)
    @constraint(model, c3, - y1 + s[3] == 10)
    @constraint(model, c4, y1 + s[4] == 20)
    @constraint(model, c5, - y2 + s[5] == 10)
    @constraint(model, c6, y2 + s[6] == 20)
    @constraint(model, kt1, 2 * (y1 - x1 + 20) + 2 * l[1] - l[3] + l[4] == 0)
    @constraint(model, kt2, 2 * (y2 - x2 + 20) + 2 * l[2] - l[5] + l[6] == 0)
    @constraint(model, compl[i in I], l[i] ⟂ s[i])
    @objective(model, Min, 2 * x1 + 2 * x2 - 3 * y1 - 3 * y2 - 60)
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
