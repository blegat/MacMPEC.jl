using JuMP
function build_model(; I = 1:6, J = 1:2, K = 1:3, pi, x0 = JuMP.Containers.DenseAxisArray(fill(0.5, length(I)), I), y0 = JuMP.Containers.DenseAxisArray(fill(0.0, length(J), length(K)), J, K), l0 = JuMP.Containers.DenseAxisArray(fill(1.0, length(K)), K))
    model = Model()
    @variable(model, x[i in I])
    @variable(model, y[j in J, k in K])
    @variable(model, l[k in K] >= 0)
    @variable(model, det)
    @variable(model, r11)
    @variable(model, r12)
    @variable(model, r22)
    @constraint(model, g1, - y[1, 1] - y[2, 1] ^ 2 <= 0)
    @constraint(model, g2, y[1, 2] / 4 + y[2, 2] - 3 / 4 <= 0)
    @constraint(model, g3, - y[2, 3] - 1 <= 0)
    @constraint(model, KKT_11, 1 + l[1] * (2 * r11 * (y[1, 1] - x[1]) + 2 * r12 * (y[2, 1] - x[2])) == 0)
    @constraint(model, KKT_21, 2 * y[2, 1] + l[1] * (2 * r22 * (y[2, 1] - x[2]) + 2 * r12 * (y[1, 1] - x[1])) == 0)
    @constraint(model, KKT_12, - 1 / 4 + l[2] * (2 * r11 * (y[1, 2] - x[1]) + 2 * r12 * (y[2, 2] - x[2])) == 0)
    @constraint(model, KKT_22, - 1 + l[2] * (2 * r22 * (y[2, 2] - x[2]) + 2 * r12 * (y[1, 2] - x[1])) == 0)
    @constraint(model, KKT_13, 0 + l[3] * (2 * r11 * (y[1, 3] - x[1]) + 2 * r12 * (y[2, 3] - x[2])) == 0)
    @constraint(model, KKT_23, 1 + l[3] * (2 * r22 * (y[2, 3] - x[2]) + 2 * r12 * (y[1, 3] - x[1])) == 0)
    @constraint(model, compl[k in K], 1 >= r11 * (y[1, k] - x[1]) ^ 2 + 2 * r12 * (y[1, k] - x[1]) * (y[2, k] - x[2]) + r22 * (y[2, k] - x[2]) ^ 2 ⟂ l[k])
    @objective(model, Max, pi * abs(x[3] * x[6] - x[4] * x[5]))
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
