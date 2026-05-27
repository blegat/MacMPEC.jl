using JuMP
function build_model()
    model = Model()
    @variable(model, 0 <= x <= 200)
    @variable(model, y >= 0)
    @variable(model, l >= 0)
    @constraint(model, F, 2 * y + 0.5 * x - 100 - l == 0)
    @constraint(model, g, y ⟂ l)
    @objective(model, Min, 0.5 * x ^ 2 + 0.5 * x * y - 95 * x)
    return model
end
