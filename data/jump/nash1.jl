using JuMP
function build_model(; InitPoints, iptx1, iptx2)
    model = Model()
    @variable(model, 0 <= x[1:2] <= 10)
    @variable(model, y[1:2])
    @variable(model, l[1:2] >= 0)
    @constraint(model, F1, 0 == - 34 + 2 * y[1] + (8 / 3) * y[2] - (- l[1]))
    @constraint(model, F2, 0 == - 24.25 + 1.25 * y[1] + 2 * y[2] - (- l[2]))
    @constraint(model, g1, - x[2] - y[1] + 15 ⟂ l[1])
    @constraint(model, g2, - x[1] - y[2] + 15 ⟂ l[2])
    @objective(model, Min, ((x[1] - y[1]) ^ 2 + (x[2] - y[2]) ^ 2) / 2)
    return model
end

function build_model(path::String)
    schema = JuMPConverter.AMPL.DatSchema(
        Dict{Symbol,Int}(
            :iptx1 => 1,
            :iptx2 => 1,
        ),
        [:InitPoints],
    )
    data = if isdir(path)
        JuMPConverter.AMPL.read_csv(path, schema)
    else
        JuMPConverter.AMPL.read_dat(path, schema)
    end
    return build_model(; data...)
end
