using JuMP
function build_model(; vars = 1:104, design = 1:4, state = 5:104, side = 1:8, P = JuMP.Containers.DenseAxisArray(fill(0.0, length(vars), length(vars)), vars, vars), M = JuMP.Containers.DenseAxisArray(fill(0.0, length(state), length(vars)), state, vars), q = JuMP.Containers.DenseAxisArray(fill(0.0, length(state)), state), c = JuMP.Containers.DenseAxisArray(fill(0.0, length(vars)), vars))
    model = Model()
    @variable(model, 0 <= x[design] <= 1000)
    @variable(model, y[state] >= 0)
    @variable(model, s[state] >= 0)
    @constraint(model, F[i in state], sum(M[i, k] * x[k] for k in design) + sum(M[i, j] * y[j] for j in state) + q[i] ⟂ y[i])
    @objective(model, Min, 0.5 * (sum(x[i] * sum(P[i, j] * x[j] for j in design) for i in design) + 2.0 * sum(x[i] * sum(P[i, j] * y[i] for j in state) for i in design) + sum(y[i] * sum(P[i, j] * y[j] for j in state) for i in state)) + sum(c[i] * x[i] for i in design) + sum(c[i] * y[i] for i in state))
    return model
end

function build_model(path::String)
    schema = JuMPConverter.AMPL.DatSchema(
        Dict{Symbol,Int}(
            :P => 2,
            :M => 2,
            :q => 1,
            :c => 1,
        ),
        [:vars, :design, :state, :side],
    )
    data = if isdir(path)
        JuMPConverter.AMPL.read_csv(path, schema)
    else
        JuMPConverter.AMPL.read_dat(path, schema)
    end
    return build_model(; data...)
end
