using JuMP
function build_model(; NS, NR, F, R, sol)
    model = Model()
    @variable(model, s[1:NS] >= 0.0)
    @variable(model, m[1:NS] >= 0.0)
    @variable(model, l)
    @variable(model, r[i in 1:NR] >= 0)
    @constraint(model, KKT[k in 1:NS], 0 == sum(2 * (sum(s[j] * F[j, i] for j in 1:NS) - (R[i] + r[i])) * F[k, i] for i in 1:NR) - l - m[k])
    @constraint(model, cons1, sum(s[i] for i in 1:NS) == 1)
    @constraint(model, compl_s[i in 1:NS], s[i] ⟂ m[i])
    @objective(model, Min, sum((s[i] - sol[i]) ^ 2 for i in 1:NS) + sum((r[i]) ^ 2 for i in 1:NR))
    return model
end

function build_model(path::String)
    schema = JuMPConverter.AMPL.DatSchema(
        Dict{Symbol,Int}(
            :NS => 0,
            :NR => 0,
            :F => 2,
            :R => 1,
            :sol => 1,
        )
    )
    data = if isdir(path)
        JuMPConverter.AMPL.read_csv(path, schema)
    else
        JuMPConverter.AMPL.read_dat(path, schema)
    end
    return build_model(; data...)
end
