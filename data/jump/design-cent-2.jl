using JuMP
function build_model(; I = 1:4, J = 1:2, K = 1:3, pi, x0 = JuMP.Containers.DenseAxisArray(fill(0.5, length(I)), I), y0 = JuMP.Containers.DenseAxisArray(fill(0.0, length(J), length(K)), J, K), l0 = JuMP.Containers.DenseAxisArray(fill(1.0, length(K)), K))
    model = Model()
    @variable(model, x[i in I])
    @variable(model, y[j in J, k in K])
    @variable(model, l[k in K] >= 0)
    @constraint(model, g1, - y[1, 1] - y[2, 1] ^ 2 <= 0)
    @constraint(model, g2, y[1, 2] / 4 + y[2, 2] - 3 / 4 <= 0)
    @constraint(model, g3, - y[2, 3] - 1 <= 0)
    @constraint(model, KKT_11n, y[1, 1] - x[1] <= 0)
    @constraint(model, KKT_12n, y[1, 2] - x[1] >= 0)
    @constraint(model, KKT_22n, y[2, 2] - x[2] >= 0)
    @constraint(model, KKT_23n, y[2, 3] - x[2] <= 0)
    @constraint(model, KKT_11, 1 + 2 * (y[1, 1] - x[1]) / (x[3] ^ 2) * l[1] == 0)
    @constraint(model, KKT_21, 2 * y[2, 1] + 2 * (y[2, 1] - x[2]) / (x[4] ^ 2) * l[1] == 0)
    @constraint(model, KKT_12, - 1 / 4 + 2 * (y[1, 2] - x[1]) / (x[3] ^ 2) * l[2] == 0)
    @constraint(model, KKT_22, - 1 + 2 * (y[2, 2] - x[2]) / (x[4] ^ 2) * l[2] == 0)
    @constraint(model, KKT_13, 0 + 2 * (y[1, 3] - x[1]) / (x[3] ^ 2) * l[3] == 0)
    @constraint(model, KKT_23, 1 + 2 * (y[2, 3] - x[2]) / (x[4] ^ 2) * l[3] == 0)
    @constraint(model, compl[k in K], ((y[1, k] - x[1]) ^ 2) / (x[3] ^ 2) + ((y[2, k] - x[2]) ^ 2) / (x[4] ^ 2) <= 1 ⟂ l[k])
    @objective(model, Max, pi * x[3] * x[4])
    return model
end

function build_model(path::String)
    schema = JuMPConverter.AMPL.DatSchema(
        Dict{Symbol,Int}(
            :pi => 0,
            :x0 => 1,
            :y0 => 2,
            :l0 => 1,
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
