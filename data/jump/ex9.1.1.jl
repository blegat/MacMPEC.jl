using JuMP
function build_model(; I = 1:5)
    model = Model()
    @variable(model, y1)
    @variable(model, y2)
    @variable(model, x >= 0)
    @variable(model, s[I] >= 0)
    @variable(model, l[I] >= 0)
    @constraint(model, c1, - 2 * x + y1 + 4 * y2 + s[1] == 16)
    @constraint(model, c2, 8 * x + 3 * y1 - 2 * y2 + s[2] == 48)
    @constraint(model, c3, - 2 * x + y1 - 3 * y2 + s[3] == - 12)
    @constraint(model, c4, - y1 + s[4] == 0)
    @constraint(model, c5, y1 + s[5] == 4)
    @constraint(model, kt1, - 1 + l[1] + 3 * l[2] + l[3] - l[4] + l[5] == 0)
    @constraint(model, kt2, 4 * l[2] - 2 * l[2] - 3 * l[3] == 0)
    @constraint(model, compl[i in I], l[i] ⟂ s[i])
    @objective(model, Min, - x - 3 * y1 + 2 * y2)
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
