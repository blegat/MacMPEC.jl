using JuMP
const _INLINE_DATA = JuMPConverter.AMPL.parse_dat(
    "\nparam: \t\tubx,\t x := \n\t1 \t10\t 5\n\t2\t 5\t 5\n\t3\t15\t15\t\n\t4\t20\t15;\n\n",
)

function build_model(; I = 1:4, ubx = _INLINE_DATA["ubx"])
    model = Model()
    @variable(model, 0 <= x[i in I] <= ubx[i])
    @variable(model, y[I])
    @variable(model, l[1:8])
    @constraint(model, l1, x[1] + x[2] + x[3] + x[4] <= 40)
    @constraint(model, F1, 0 == y[1] - 4 - (- 0.4 * l[1] - 0.6 * l[2] + l[3]))
    @constraint(model, F2, 0 == y[2] - 13 - (- 0.7 * l[1] - 0.3 * l[2] + l[4]))
    @constraint(model, F3, 0 == y[3] - 35 - (- 0.4 * l[5] - 0.6 * l[6] + l[7]))
    @constraint(model, F4, 0 == y[4] - 2 - (- 0.7 * l[5] - 0.3 * l[6] + l[8]))
    @constraint(model, g1, x[1] - 0.4 * y[1] - 0.7 * y[2] ⟂ l[1])
    @constraint(model, g2, x[2] - 0.6 * y[1] - 0.3 * y[2] ⟂ l[2])
    @constraint(model, m1, y[1] <= 20 ⟂ l[3])
    @constraint(model, m2, y[2] <= 20 ⟂ l[4])
    @constraint(model, g7, x[3] - 0.4 * y[3] - 0.7 * y[4] ⟂ l[5])
    @constraint(model, g8, x[4] - 0.6 * y[3] - 0.3 * y[4] ⟂ l[6])
    @constraint(model, m3, y[3] <= 40 ⟂ l[7])
    @constraint(model, m4, y[4] <= 40 ⟂ l[8])
    @objective(model, Min, - (200 - y[1] - y[3]) * (y[1] + y[3]) - (160 - y[2] - y[4]) * (y[2] + y[4]))
    return model
end

function build_model(path::String)
    schema = JuMPConverter.AMPL.DatSchema(
        Dict{Symbol,Int}(
            :ubx => 1,
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
