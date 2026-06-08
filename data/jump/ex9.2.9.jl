using JuMP
function build_model(; I = 1:3)
    model = Model()
    @variable(model, 2 <= x <= 4)
    @variable(model, y1 >= 0)
    @variable(model, y2 >= 0)
    @variable(model, s[I] >= 0)
    @variable(model, l[I] >= 0)
    @constraint(model, c1, x - y1 - y2 + s[1] == - 4)
    @constraint(model, c2, - y1 + s[2] == 0)
    @constraint(model, c3, - y2 + s[3] == 0)
    @constraint(model, kt1, - l[1] - l[2] == - 2)
    @constraint(model, kt2, - l[1] - l[3] == - x)
    @constraint(model, compl[i in I], l[i] ⟂ s[i])
    @objective(model, Min, x + y2)
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
