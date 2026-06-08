using JuMP
function build_model()
    model = Model()
    @variable(model, 0 <= x[1:2] <= 50)
    @variable(model, y[1:2])
    @variable(model, l[1:6] >= 0)
    @constraint(model, c1, x[1] + x[2] + y[1] - 2 * y[2] - 40 <= 0)
    @constraint(model, F1, 0 == 2 * y[1] - 2 * x[1] + 40 - (l[1] - l[2] - 2 * l[5]))
    @constraint(model, F2, 0 == 2 * y[2] - 2 * x[2] + 40 - (l[3] - l[4] - 2 * l[6]))
    @constraint(model, g1, y[1] + 10 ⟂ l[1])
    @constraint(model, g2, - y[1] + 20 ⟂ l[2])
    @constraint(model, g3, y[2] + 10 ⟂ l[3])
    @constraint(model, g4, - y[2] + 20 ⟂ l[4])
    @constraint(model, g5, x[1] - 2 * y[1] - 10 ⟂ l[5])
    @constraint(model, g6, x[2] - 2 * y[2] - 10 ⟂ l[6])
    @objective(model, Min, 2 * x[1] + 2 * x[2] - 3 * y[1] - 3 * y[2] - 60)
    return model
end
