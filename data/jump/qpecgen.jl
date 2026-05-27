using JuMP
function build_model(; N_x = 1:n_x, N_y = 1:n_y, M_1 = 1:m_1, n_x, n_y, m_1, Pxx, Pxy, Pyy, c, d, Ax, Ay = JuMP.Containers.DenseAxisArray(fill(0.0, length(M_1), length(N_y)), M_1, N_y), a, N, M, q)
    model = Model()
    @variable(model, x[N_x])
    @variable(model, y[N_y] >= 0)
    @constraint(model, Acon[i in M_1], sum(Ax[i, j] * x[j] for j in N_x) + sum(Ay[i, j] * y[j] for j in N_y) + a[i] <= 0)
    @constraint(model, Fcon[i in N_y], q[i] + sum(N[i, j] * x[j] for j in N_x) + sum(M[i, j] * y[j] for j in N_y) ⟂ y[i])
    @objective(model, Min, 0.5 * (sum(x[i] * sum(Pxx[i, j] * x[j] for j in N_x) for i in N_x)) + 0.5 * (sum(y[i] * sum(Pyy[i, j] * y[j] for j in N_y) for i in N_y)) + (sum(x[i] * sum(Pxy[i, j] * y[j] for j in N_y) for i in N_x)) + sum(x[i] * c[i] for i in N_x) + sum(y[i] * d[i] for i in N_y))
    return model
end

function build_model(path::String)
    schema = JuMPConverter.AMPL.DatSchema(
        Dict{Symbol,Int}(
            :n_x => 0,
            :n_y => 0,
            :m_1 => 0,
            :Pxx => 2,
            :Pxy => 2,
            :Pyy => 2,
            :c => 1,
            :d => 1,
            :Ax => 2,
            :Ay => 2,
            :a => 1,
            :N => 2,
            :M => 2,
            :q => 1,
        ),
        [:N_x, :N_y, :M_1],
    )
    data = if isdir(path)
        JuMPConverter.AMPL.read_csv(path, schema)
    else
        JuMPConverter.AMPL.read_dat(path, schema)
    end
    return build_model(; data...)
end
