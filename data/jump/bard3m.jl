using JuMP
function build_model()
    model = Model()
    @variable(model, x1 >= 0)
    @variable(model, x2 >= 0)
    @variable(model, y1 >= 0)
    @variable(model, y2 >= 0)
    @variable(model, m_cons1 >= 0)
    @variable(model, m_cons2 >= 0)
    @constraint(model, side, x1 ^ 2 + 2 * x2 <= 4)
    @constraint(model, cons1, x1 ^ 2 - 2 * x1 + x2 ^ 2 - 2 * y1 + y2 + 3 ⟂ m_cons1)
    @constraint(model, cons2, x2 + 3 * y1 - 4 * y2 - 4 ⟂ m_cons2)
    @constraint(model, d_y1, (2 * y1 + 2 * m_cons1) - 3 * m_cons2 ⟂ y1)
    @constraint(model, d_y2, (- 5 - m_cons1) + 4 * m_cons2 ⟂ y2)
    @objective(model, Min, - x1 ^ 2 - 3 * x2 + y2 ^ 2 - 4 * y1)
    return model
end
