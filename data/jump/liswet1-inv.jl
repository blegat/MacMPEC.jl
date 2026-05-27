using JuMP
function build_model(; N, K, B, C, T, x_star)
    model = Model()
    @variable(model, z[1:N] >= 0)
    @variable(model, x[i in 1:N+K])
    @variable(model, l[1:N] >= 0)
    @constraint(model, KKT[i in 1:N+K], - (sqrt(T[i]) + 0.1 * sin(i)) + x[i] - sum(C[j+K-i] * l[j] for j in max(i - K, 1):min(i, N)) == 0)
    @constraint(model, controls, sum(z[j] for j in 1:N) >= 0.2)
    @constraint(model, compl[j in 1:N], sum(C[i] * x[j+K-i] for i in 0:K) >= z[j] ⟂ l[j])
    @objective(model, Min, sum((x[i] - x_star[i]) ^ 2 for i in 1:N + K))
    return model
end

function build_model(path::String)
    schema = JuMPConverter.AMPL.DatSchema(
        Dict{Symbol,Int}(
            :N => 0,
            :K => 0,
            :B => 1,
            :C => 1,
            :T => 1,
            :x_star => 1,
        )
    )
    data = if isdir(path)
        JuMPConverter.AMPL.read_csv(path, schema)
    else
        JuMPConverter.AMPL.read_dat(path, schema)
    end
    return build_model(; data...)
end
