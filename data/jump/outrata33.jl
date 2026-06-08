using JuMP
function build_model()
    model = Model()
    @variable(model, x[1:4] >= 0)
    @variable(model, 0 <= y <= 10)
    @constraint(model, nlcs1, (1 + 0.2 * y) * x[1] - (3 + 1.333 * y) - 0.333 * x[3] + 2 * x[1] * x[4] ⟂ x[1])
    @constraint(model, nlcs2, (1 + 0.1 * y) * x[2] - y + x[3] + 2 * x[2] * x[4] ⟂ x[2])
    @constraint(model, nlcs3, 0.333 * x[1] - x[2] + 1 - 0.1 * y ⟂ x[3])
    @constraint(model, nlcs4, 9 + 0.1 * y - x[1] ^ 2 - x[2] ^ 2 ⟂ x[4])
    @objective(model, Min, ((x[1] - 3) ^ 2 + (x[2] - 4) ^ 2 + 10 * x[4] ^ 2) / 2)
    return model
end
