using JuMP
function build_model()
    model = Model()
    @variable(model, x >= 0)
    @variable(model, y >= 0)
    @variable(model, sy >= 0)
    @variable(model, l[1:3] >= 0)
    @constraint(model, cons1, 3 * x - y - 3 ⟂ l[1])
    @constraint(model, cons2, - x + 0.5 * y + 4 ⟂ l[2])
    @constraint(model, cons3, - x - y + 7 ⟂ l[3])
    @constraint(model, d_y, sy == (((2 * (y - 1) - 1.5 * x) - l[1] * (- 1) * 1) - l[2] * 0.5) - l[3] * (- 1) * 1)
    @objective(model, Min, (x - 5) ^ 2 + (2 * y + 1) ^ 2)
    return model
end
