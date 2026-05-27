using JuMP
function build_model()
    model = Model()
    @variable(model, 0 <= x[1:2] <= 50)
    @variable(model, y[1:2])
    @variable(model, l[1:4])
    @constraint(model, c1, x[1] + x[2] + y[1] - 2 * y[2] - 40 <= 0)
    @constraint(model, F1, 0 == 2 * y[1] - 2 * x[1] + 40 - (l[1] - 2 * l[3]))
    @constraint(model, F2, 0 == 2 * y[2] - 2 * x[2] + 40 - (l[2] - 2 * l[4]))
    @constraint(model, m1, - 10 <= y[1] <= 20 ⟂ l[1])
    @constraint(model, m2, - 10 <= y[2] <= 20 ⟂ l[2])
    @constraint(model, g5, x[1] - 2 * y[1] - 10 ⟂ l[3])
    @constraint(model, g6, x[2] - 2 * y[2] - 10 ⟂ l[4])
    @objective(model, Min, 2 * x[1] + 2 * x[2] - 3 * y[1] - 3 * y[2] - 60)
    return model
end
