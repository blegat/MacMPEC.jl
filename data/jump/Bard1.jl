using JuMP
function build_model()
    model = Model()
    @variable(model, x >= 0)
    @variable(model, y >= 0)
    @variable(model, l[1:3])
    @constraint(model, KKT, 2 * (y - 1) - 1.5 * x + l[1] - l[2] * 0.5 + l[3] == 0)
    @constraint(model, lin_1, 3 * x - y - 3 ⟂ l[1])
    @constraint(model, lin_2, - x + 0.5 * y + 4 ⟂ l[2])
    @constraint(model, lin_3, - x - y + 7 ⟂ l[3])
    @objective(model, Min, (x - 5) ^ 2 + (2 * y + 1) ^ 2)
    return model
end
