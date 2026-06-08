using JuMP
function build_model(; I = 1:2, L, G, pL)
    model = Model()
    @variable(model, x[I] >= 0)
    @variable(model, l >= 0)
    @variable(model, p[I] >= 0)
    @variable(model, t[I] >= 0)
    @constraint(model, prices[i in I], pL >= p[i] ⟂ x[i])
    @constraint(model, consum[i in I], x[i] * (3 * p[i] * (1 + t[i])) >= 100 * pL ⟂ p[i])
    @constraint(model, equatn, L * pL == sum(x[i] * p[i] for i in I) + l * pL + G)
    @constraint(model, revenue, sum(p[i] * t[i] * x[i] for i in I) >= G)
    @objective(model, Max, (x[1] * x[2] * l) ^ (1 / 3))
    return model
end

function build_model(path::String)
    schema = JuMPConverter.AMPL.DatSchema(
        Dict{Symbol,Int}(
            :L => 0,
            :G => 0,
            :pL => 0,
        ),
        [:I],
    )
    data = if isdir(path)
        JuMPConverter.AMPL.read_csv(path, schema)
    else
        JuMPConverter.AMPL.read_dat(path, schema)
    end
    return build_model(; data...)
end
