using JuMP
function build_model(; N = 1:24, DEST = 1:24, ARCS, TOLL, clo, cup, d, A, B, K)
    model = Model()
    @variable(model, x[(i, j) in ARCS, k in DEST; i != k] >= 0)
    @variable(model, F[ARCS])
    @variable(model, clo[i, j] <= trffcost[(i, j) in TOLL] <= cup[i, j])
    @variable(model, T[N, N] >= 0)
    @constraint(model, rational[(i, j) in ARCS, k in DEST; i != k], A[i, j] + B[i, j] * (F[i, j] / K[i, j]) ^ 4 + T[j, k] + (if(i, j) in TOLL then 100 * trffcost[i, j] else 0.0) - T[i, k] ⟂ x[i, j, k])
    @constraint(model, balance[i in N, k in DEST; i != k], sum(x[i, j, k] for j in N if (i, j) in ARCS and i != k) - sum(x[j, i, k] for j in N if (j, i) in ARCS and j != k) == d[i, k])
    @constraint(model, fdef[(i, j) in ARCS], F[i, j] == sum(x[i, j, l] for l in DEST if l != i))
    @objective(model, Max, sum(trffcost[i, j] * F[i, j] for (i, j) in TOLL, k in DEST if i != k))
    return model
end

function build_model(path::String)
    schema = JuMPConverter.AMPL.DatSchema(
        Dict{Symbol,Int}(
            :clo => 1,
            :cup => 1,
            :d => 2,
            :A => 1,
            :B => 1,
            :K => 1,
        ),
        [:N, :DEST, :ARCS, :TOLL],
    )
    data = if isdir(path)
        JuMPConverter.AMPL.read_csv(path, schema)
    else
        JuMPConverter.AMPL.read_dat(path, schema)
    end
    return build_model(; data...)
end
