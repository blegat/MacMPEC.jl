using JuMP
const _INLINE_DATA = JuMPConverter.AMPL.parse_dat(
    "\nlet {i in N} x[i] := 1.0;\nlet {j in M} y[j] := 1.0;\n",
)

function build_model(; N = 1:n, M = 1:m, NM = (n + 1):m, n, m, rr, ss)
    model = Model()
    @variable(model, x[N])
    @variable(model, y[M] >= 0)
    @variable(model, s[N] >= 0)
    @constraint(model, lin1[i in N], y[i] - x[i] ⟂ y[i])
    @constraint(model, lin2[i in NM], y[i] ⟂ y[i])
    @objective(model, Min, sum((x[i] + rr[i]) ^ 2 for i in N) + sum((y[j] + ss[j]) ^ 2 for j in M))
    return model
end

function build_model(path::String)
    schema = JuMPConverter.AMPL.DatSchema(
        Dict{Symbol,Int}(
            :n => 0,
            :m => 0,
            :rr => 1,
            :ss => 1,
        ),
        [:N, :M, :NM],
    )
    data = if isdir(path)
        JuMPConverter.AMPL.read_csv(path, schema)
    else
        JuMPConverter.AMPL.read_dat(path, schema)
    end
    return build_model(; data...)
end
