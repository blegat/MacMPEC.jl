using JuMP
function build_model(; N = 1:9, DEST = {3, 4}, ARCS, d = JuMP.Containers.DenseAxisArray(fill(0.0, length(N), length(N)), N, N), T, b)
    model = Model()
    @variable(model, x[(i, j) in ARCS, k in DEST; i != k] >= 0)
    @variable(model, F[ARCS])
    @variable(model, toll[ARCS] >= 0)
    @variable(model, time[N, N] >= 0)
    @constraint(model, rational[(i, j) in ARCS, k in DEST; i != k], T[i, j] * (1 + 0.15 * (F[i, j] / b[i, j]) ^ 4) + time[j, k] + 100 * toll[i, j] - time[i, k] ⟂ x[i, j, k])
    @constraint(model, balance[i in N, k in DEST; i != k], sum(x[i, j, k] for j in N if (i, j) in ARCS and i != k) - sum(x[j, i, k] for j in N if (j, i) in ARCS and j != k) == d[i, k])
    @constraint(model, fdef[(i, j) in ARCS], F[i, j] == sum(x[i, j, l] for l in DEST if l != i))
    @objective(model, Min, sum(T[i, j] * (1 + 0.15 * (F[i, j] / b[i, j]) ^ 4) for (i, j) in ARCS))
    return model
end

function build_model(path::String)
    schema = JuMPConverter.AMPL.DatSchema(
        Dict{Symbol,Int}(
            :d => 2,
            :T => 1,
            :b => 1,
        ),
        [:N, :DEST, :ARCS],
    )
    data = if isdir(path)
        JuMPConverter.AMPL.read_csv(path, schema)
    else
        JuMPConverter.AMPL.read_dat(path, schema)
    end
    return build_model(; data...)
end
