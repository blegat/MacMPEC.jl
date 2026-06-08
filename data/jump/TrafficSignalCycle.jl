using JuMP
function build_model(; S, K, N, xmax, gmax, gmin, lambda, L0, b1, b2, b3, b4, b5, b6)
    model = Model()
    @variable(model, L[i in S, j in K])
    @variable(model, y[1:2])
    @constraint(model, c1[i in S, j in K], 0 <= L[i, j] <= xmax)
    @constraint(model, c21[i in S], L[i, 1] >= L0[i] + b1[i] * y[2] + b3[i])
    @constraint(model, c31[i in S], L[i, 1] >= b5[i])
    @constraint(model, c41[i in S], L[i, 1] >= L0[i] + b1[i] * y[2] + b3[i] ⟂ L[i, 1] >= b5[i])
    @constraint(model, c2[i in S, j in 1:N], L[i, 2*j] >= L[i, 2*j-1] + b1[i] * y[2] + b3[i])
    @constraint(model, c3[i in S, j in 1:N], L[i, 2*j] >= b5[i])
    @constraint(model, c4[i in S, j in 1:N], L[i, 2*j] >= L[i, 2*j-1] + b1[i] * y[2] + b3[i] ⟂ L[i, 2*j] >= b5[i])
    @constraint(model, c5[i in S, j in 1:N], L[i, 2*j+1] >= L[i, 2*j] + b2[i] * y[1] + b4[i])
    @constraint(model, c6[i in S, j in 1:N], L[i, 2*j+1] >= b6[i])
    @constraint(model, c7[i in S, j in 1:N], L[i, 2*j+1] >= L[i, 2*j] + b2[i] * y[1] + b4[i] ⟂ L[i, 2*j+1] >= b6[i])
    @constraint(model, c8[i in 1:2], gmin <= y[i] <= gmax)
    @objective(model, Min, sum(1 / lambda[i] * ((1 / (2 * (2 * N + 1)) * L0[i] + sum(1 / (2 * N + 1) * L[i, j] for j in 1:2 * N) + 1 / (2 * (2 * N + 1)) * L[i, 2*N+1])) for i in S))
    return model
end

function build_model(path::String)
    schema = JuMPConverter.AMPL.DatSchema(
        Dict{Symbol,Int}(
            :N => 0,
            :xmax => 0,
            :gmax => 0,
            :gmin => 0,
            :lambda => 1,
            :L0 => 1,
            :b1 => 1,
            :b2 => 1,
            :b3 => 1,
            :b4 => 1,
            :b5 => 1,
            :b6 => 1,
        ),
        [:S, :K],
    )
    data = if isdir(path)
        JuMPConverter.AMPL.read_csv(path, schema)
    else
        JuMPConverter.AMPL.read_dat(path, schema)
    end
    return build_model(; data...)
end
