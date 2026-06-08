using JuMP
const _INLINE_DATA = JuMPConverter.AMPL.parse_dat(
    "\n\nparam: \t\tzl,\tzu :=\n\t1\t10\t1E10\n\t2\t0.01\t10\n\t3\t0\t1;\n\n\n\n\n        \n\n",
)

function build_model(; I = 1:3, zl = _INLINE_DATA["zl"], zu = _INLINE_DATA["zu"])
    model = Model()
    @variable(model, x[1:2])
    @variable(model, zl[i] <= z[i in I] <= zu[i])
    @variable(model, l[I] >= 0)
    @constraint(model, KKT1, 0.02 * x[1] - 10 * l[1] - l[2] == 0)
    @constraint(model, KKT2, 2 * x[2] - l[1] - l[3] == 0)
    @constraint(model, lin_1, 10 * x[1] + x[2] - (10 + z[1]) ⟂ l[1])
    @constraint(model, lin_2, x[1] - (2 + z[2]) ⟂ l[2])
    @constraint(model, lin_3, x[2] - 50 * z[3] ⟂ l[3])
    @objective(model, Min, (x[1] - 2) ^ 2 + x[2] ^ 2)
    return model
end

function build_model(path::String)
    schema = JuMPConverter.AMPL.DatSchema(
        Dict{Symbol,Int}(
            :zl => 1,
            :zu => 1,
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
