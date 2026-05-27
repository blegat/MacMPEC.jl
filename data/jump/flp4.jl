using JuMP
function build_model(; MM = 1:m, NN = 1:n, PP = 1:p, m, n, p, A = JuMP.Containers.DenseAxisArray(fill(0.0, length(PP), length(NN)), PP, NN), b = JuMP.Containers.DenseAxisArray(fill(0.0, length(PP)), PP), N = JuMP.Containers.DenseAxisArray(fill(0.0, length(MM), length(NN)), MM, NN), M = JuMP.Containers.DenseAxisArray(fill(0.0, length(MM), length(MM)), MM, MM), q = JuMP.Containers.DenseAxisArray(fill(0.0, length(MM)), MM))
    model = Model()
    @variable(model, x[NN])
    @variable(model, y[MM])
    @constraint(model, lincs[k in PP], sum(A[k, j] * x[j] for j in NN) <= b[k])
    @constraint(model, compl[i in MM], 0 <= sum(N[i, j] * x[j] for j in NN) + sum(M[i, l] * y[l] for l in MM) + q[i] ⟂ y[i])
    @objective(model, Min, 0.5 * (sum(x[j] ^ 2 for j in NN)) + sum(y[i] for i in MM))
    return model
end

function build_model(path::String)
    schema = JuMPConverter.AMPL.DatSchema(
        Dict{Symbol,Int}(
            :m => 0,
            :n => 0,
            :p => 0,
            :A => 2,
            :b => 1,
            :N => 2,
            :M => 2,
            :q => 1,
        ),
        [:MM, :NN, :PP],
    )
    data = if isdir(path)
        JuMPConverter.AMPL.read_csv(path, schema)
    else
        JuMPConverter.AMPL.read_dat(path, schema)
    end
    return build_model(; data...)
end
