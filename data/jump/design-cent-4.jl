using JuMP
const _INLINE_DATA = JuMPConverter.AMPL.parse_dat(
    "\nlet x0[1] :=  1;\nlet x0[2] :=  1;\nlet x0[3] := -1;\nlet x0[4] := -1;\n",
)

function build_model(; I = 1:4, J = 1:2, K = 1:3, L = 1:4, pi, x0 = JuMP.Containers.DenseAxisArray(fill(0.0, length(I)), I), y0 = JuMP.Containers.DenseAxisArray(fill(0.0, length(J), length(K)), J, K), ll0 = JuMP.Containers.DenseAxisArray(fill(1.0, length(L), length(K)), L, K))
    model = Model()
    @variable(model, x[i in I])
    @variable(model, y[j in J, k in K])
    @variable(model, ll[l in L, k in K] >= 0)
    @constraint(model, g1, - y[1, 1] - y[2, 1] ^ 2 <= 0)
    @constraint(model, g2, y[1, 2] / 4 + y[2, 2] - 3 / 4 <= 0)
    @constraint(model, g3, - y[2, 3] - 1 <= 0)
    @constraint(model, KKT_11, 1 + ll[1, 1] - ll[3, 1] == 0)
    @constraint(model, KKT_21, 2 * y[2, 1] + ll[2, 1] - ll[4, 1] == 0)
    @constraint(model, KKT_12, - 1 / 4 + ll[1, 2] - ll[3, 2] == 0)
    @constraint(model, KKT_22, - 1 + ll[2, 2] - ll[4, 2] == 0)
    @constraint(model, KKT_13, 0 + ll[1, 3] - ll[3, 3] == 0)
    @constraint(model, KKT_23, 1 + ll[2, 3] - ll[4, 3] == 0)
    @constraint(model, compl_1[k in K], y[1, k] - x[1] <= 0 ⟂ ll[1, k])
    @constraint(model, compl_2[k in K], y[2, k] - x[2] <= 0 ⟂ ll[2, k])
    @constraint(model, compl_3[k in K], - y[1, k] + x[3] <= 0 ⟂ ll[3, k])
    @constraint(model, compl_4[k in K], - y[2, k] + x[4] <= 0 ⟂ ll[4, k])
    @objective(model, Max, (x[1] - x[3]) * (x[2] - x[4]))
    return model
end

function build_model(path::String)
    schema = JuMPConverter.AMPL.DatSchema(
        Dict{Symbol,Int}(
            :pi => 0,
            :x0 => 1,
            :y0 => 2,
            :ll0 => 2,
        ),
        [:I, :J, :K, :L],
    )
    data = if isdir(path)
        JuMPConverter.AMPL.read_csv(path, schema)
    else
        JuMPConverter.AMPL.read_dat(path, schema)
    end
    return build_model(; data...)
end
