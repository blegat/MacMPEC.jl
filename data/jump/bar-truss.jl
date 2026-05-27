using JuMP
function build_model(; d, m, y, E, sigma, L, F, C, N)
    model = Model()
    @variable(model, S[m])
    @variable(model, r[m, y])
    @variable(model, H[m, y, y])
    @variable(model, Q[m])
    @variable(model, - 4 <= u[d] <= 4)
    @variable(model, a[m] >= 0)
    @variable(model, z[m, y] >= 0)
    @variable(model, w[m, y] >= 0)
    @constraint(model, tech[i in m], a[i] == a[m1])
    @constraint(model, stiff[i in m], S[i] - E * a[i] / L[i] == 0)
    @constraint(model, limit[i in m, j in y], r[i, j] - sigma * a[i] == 0)
    @constraint(model, hard[i in m, j in y], H[i, j, j] - 0.125 * E * a[i] / L[i] == 0)
    @constraint(model, compat[i in m], - Q[i] + S[i] * sum(C[i, k] * u[k] for k in d) - S[i] * sum(N[i, j] * z[i, j] for j in y) == 0)
    @constraint(model, equil[k in d], sum(C[i, k] * Q[i] for i in m) - F[k] == 0)
    @constraint(model, yield[i in m, j in y], - N[i, j] * Q[i] + sum(H[i, j, jj] * z[i, jj] for jj in y) + r[i, j] == w[i, j])
    @constraint(model, compl[i in m, j in y], w[i, j] ⟂ z[i, j])
    @objective(model, Min, sum(L[i] * a[i] for i in m))
    return model
end

function build_model(path::String)
    schema = JuMPConverter.AMPL.DatSchema(
        Dict{Symbol,Int}(
            :E => 0,
            :sigma => 0,
            :L => 1,
            :F => 1,
            :C => 2,
            :N => 2,
        ),
        [:d, :m, :y],
    )
    data = if isdir(path)
        JuMPConverter.AMPL.read_csv(path, schema)
    else
        JuMPConverter.AMPL.read_dat(path, schema)
    end
    return build_model(; data...)
end
