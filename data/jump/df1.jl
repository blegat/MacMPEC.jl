using JuMP
function build_model()
    model = Model()
    @variable(model, - 1 <= x <= 2)
    @variable(model, y >= 0)
    @constraint(model, h, x ^ 2 <= 2)
    @constraint(model, g, (x - 1) ^ 2 + (y - 1) ^ 2 <= 3)
    @constraint(model, MCP, y - x ^ 2 + 1 ⟂ y)
    @objective(model, Min, (x - 1 - y) ^ 2)
    return model
end
