using JuMP
const _INLINE_DATA = JuMPConverter.AMPL.parse_dat(
    "\nparam\t:\tsol,\tg :=\n\t1\t0\t1\n\t2\t3\t-1\t\n\t3\t0\t-1\n\t4\t4\t0;\n\nparam A\t:\t1\t2\t3\t4\t:=\n\t1\t-1\t-2\t.\t.\n\t2\t-4\t-1\t.\t.\n\t3\t-3\t-4\t.\t.\t\n\t4\t.\t.\t-2\t-1\n\t5\t.\t.\t-1\t-2\n\t6\t. \t.\t-1\t-1;\n\nparam\t:\tb :=\n\t1\t8\n\t2\t12\n\t3\t12\n\t4\t8\n\t5\t8\n\t6\t5;\n\nparam H\t:\t1\t2\t3\t4\t:=\n\t1\t.\t.\t-1\t1\n\t2\t.\t.\t1\t-1\n\t3\t-1\t1\t.\t.\n\t4\t1\t-1\t.\t. ;\n\nparam\t:\tzl,\tzu,\tu,\tv\t:=\n\t1\t0.01\t10\t0.2\t1.2\n\t2\t-10\t-0.01\t1.2\t0.2\n\t3\t0.1\t1\t2\t0.1\n\t4\t-1\t-0.1\t0.1\t2\n\t5\t-1\t1\t0.1\t10\n\t6\t0.001\t10\t-0.1\t-0.2 ;\n\n\n",
)

function build_model(; I = 1:4, J = 1:6, K = 1:6, sol = _INLINE_DATA["sol"], A = _INLINE_DATA["A"], b = _INLINE_DATA["b"], H = _INLINE_DATA["H"], g = _INLINE_DATA["g"], zl = _INLINE_DATA["zl"], zu = _INLINE_DATA["zu"], u = _INLINE_DATA["u"], v = _INLINE_DATA["v"])
    model = Model()
    @variable(model, x[I] >= 0)
    @variable(model, l[J] >= 0)
    @variable(model, m[I] >= 0)
    @variable(model, zl[k] <= z[k in K] <= zu[k])
    @constraint(model, KKT[i in I], sum(H[i, ii] * x[ii] for ii in I) + (g[i] + u[i] * z[i]) - sum(A[j, i] * l[i] for j in J) - m[i] == 0)
    @constraint(model, slackness_g[j in J], (b[j] - v[j] * z[j]) + sum(A[j, i] * x[i] for i in I) ⟂ l[j])
    @constraint(model, slackness_x[i in I], x[i] ⟂ m[i])
    @objective(model, Min, sum((sol[i] - x[i]) ^ 2 for i in I))
    return model
end

function build_model(path::String)
    schema = JuMPConverter.AMPL.DatSchema(
        Dict{Symbol,Int}(
            :sol => 1,
            :A => 2,
            :b => 1,
            :H => 2,
            :g => 1,
            :zl => 1,
            :zu => 1,
            :u => 1,
            :v => 1,
        ),
        [:I, :J, :K],
    )
    data = if isdir(path)
        JuMPConverter.AMPL.read_csv(path, schema)
    else
        JuMPConverter.AMPL.read_dat(path, schema)
    end
    return build_model(; data...)
end
