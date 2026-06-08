using JuMP
function build_model(; c, K, b, L, g, gg)
    model = Model()
    @variable(model, 0 <= x <= L)
    @variable(model, y[1:4])
    @variable(model, l[1:8] >= 0)
    @variable(model, Q)
    @constraint(model, F1, 0 == (c[2] + K[2] ^ (- 1 / b[2]) * y[1]) - (gg * Q ^ (- 1 / g)) - y[1] * (- 1 / g * gg * Q ^ (- 1 - 1 / g)) - (l[1] - l[2]))
    @constraint(model, F2, 0 == (c[3] + K[3] ^ (- 1 / b[3]) * y[2]) - (gg * Q ^ (- 1 / g)) - y[2] * (- 1 / g * gg * Q ^ (- 1 - 1 / g)) - (l[3] - l[4]))
    @constraint(model, F3, 0 == (c[4] + K[4] ^ (- 1 / b[4]) * y[3]) - (gg * Q ^ (- 1 / g)) - y[3] * (- 1 / g * gg * Q ^ (- 1 - 1 / g)) - (l[5] - l[6]))
    @constraint(model, F4, 0 == (c[5] + K[5] ^ (- 1 / b[5]) * y[4]) - (gg * Q ^ (- 1 / g)) - y[4] * (- 1 / g * gg * Q ^ (- 1 - 1 / g)) - (l[7] - l[8]))
    @constraint(model, g1, y[1] ⟂ l[1])
    @constraint(model, g2, L - y[1] ⟂ l[2])
    @constraint(model, g3, y[2] ⟂ l[3])
    @constraint(model, g4, L - y[2] ⟂ l[4])
    @constraint(model, g5, y[3] ⟂ l[5])
    @constraint(model, g6, L - y[3] ⟂ l[6])
    @constraint(model, g7, y[4] ⟂ l[7])
    @constraint(model, g8, L - y[4] ⟂ l[8])
    @objective(model, Min, c[1] * x + b[1] / (b[1] + 1) * K[1] ^ (- 1 / b[1]) * x ^ ((1 + b[1]) / b[1]) - x * (gg * Q ^ (- 1 / g)))
    return model
end

function build_model(path::String)
    schema = JuMPConverter.AMPL.DatSchema(
        Dict{Symbol,Int}(
            :c => 1,
            :K => 1,
            :b => 1,
            :L => 0,
            :g => 0,
            :gg => 0,
        )
    )
    data = if isdir(path)
        JuMPConverter.AMPL.read_csv(path, schema)
    else
        JuMPConverter.AMPL.read_dat(path, schema)
    end
    return build_model(; data...)
end
