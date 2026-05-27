using JuMP
function build_model()
    model = Model()
    @variable(model, 0 <= x[1:2] <= 2)
    @variable(model, y[1:2])
    @variable(model, l[1:2] >= 0)
    @constraint(model, F1, 2 * y[1] - 2 * x[1] + 2 * (y[1] - 1) * l[1] == 0)
    @constraint(model, F2, 2 * y[2] - 2 * x[2] + 2 * (y[2] - 1) * l[2] == 0)
    @constraint(model, g1, 0.25 - (y[1] - 1) ^ 2 ⟂ l[1])
    @constraint(model, g2, 0.25 - (y[2] - 1) ^ 2 ⟂ l[2])
    @objective(model, Min, x[1] ^ 2 - 2 * x[1] + x[2] ^ 2 - 2 * x[2] + y[1] ^ 2 + y[2] ^ 2)
    return model
end
