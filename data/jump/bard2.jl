using JuMP
const _INLINE_DATA = JuMPConverter.AMPL.parse_dat(
    "\n\nparam u_x:\t 1\t 2\t :=\n\t1\t10\t 5\n\t2\t15\t20;\n\nparam u_y:\t 1\t 2\t :=\n\t1\t20\t20\n\t2\t40\t40;\n",
)

function build_model(; N = 1:2, u_x = _INLINE_DATA["u_x"], u_y = _INLINE_DATA["u_y"])
    model = Model()
    @variable(model, x[i in N, j in N] >= 0 <= u_x[i, j])
    @variable(model, y[i in N, j in N] >= 0 <= u_y[i, j])
    @variable(model, l[N, N])
    @constraint(model, lincs, x[1, 1] + x[1, 2] + x[2, 1] + x[2, 2] <= 40)
    @constraint(model, KKT1_1, 2 * (y[1, 1] - 4) + l[1, 1] * 0.4 + l[1, 2] * 0.6 == 0)
    @constraint(model, KKT1_2, 2 * (y[1, 2] - 13) + l[1, 1] * 0.7 + l[1, 2] * 0.3 == 0)
    @constraint(model, lin_11, x[1, 1] - 0.4 * y[1, 1] - 0.7 * y[1, 2] ⟂ l[1, 1])
    @constraint(model, lin_12, x[1, 2] - 0.6 * y[1, 1] - 0.3 * y[1, 2] ⟂ l[1, 2])
    @constraint(model, KKT2_1, 2 * (y[2, 1] - 35) + l[2, 1] * 0.4 + l[2, 2] * 0.6 == 0)
    @constraint(model, KKT2_2, 2 * (y[2, 2] - 2) + l[2, 1] * 0.7 + l[2, 2] * 0.3 == 0)
    @constraint(model, lin_21, x[2, 1] - 0.4 * y[2, 1] - 0.7 * y[2, 2] ⟂ l[2, 1])
    @constraint(model, lin_22, x[2, 2] - 0.6 * y[2, 1] - 0.3 * y[2, 2] ⟂ l[2, 2])
    @objective(model, Max, (200 - y[1, 1] - y[2, 1]) * (y[1, 1] + y[2, 1]) + (160 - y[1, 2] - y[2, 2]) * (y[1, 2] + y[2, 2]))
    return model
end

function build_model(path::String)
    schema = JuMPConverter.AMPL.DatSchema(
        Dict{Symbol,Int}(
            :u_x => 2,
            :u_y => 2,
        ),
        [:N],
    )
    data = if isdir(path)
        JuMPConverter.AMPL.read_csv(path, schema)
    else
        JuMPConverter.AMPL.read_dat(path, schema)
    end
    return build_model(; data...)
end
