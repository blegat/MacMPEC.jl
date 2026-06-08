using JuMP
function build_model()
    model = Model()
    @variable(model, 0 <= x[1:2] <= 10)
    @variable(model, y[1:2] >= 0)
    @constraint(model, compl1, 0 <= 8 / 3 * x[1] + 2 * x[2] + 2 * y[1] + 8 / 3 * y[2] - 36 ⟂ y[1])
    @constraint(model, compl2, 0 <= 2 * x[1] + 5 / 4 * x[2] + 5 / 4 * y[1] + 2 * y[2] - 25 ⟂ y[2])
    @objective(model, Min, 0.5 * ((x[1] + x[2] + y[1] - 15) ^ 2 + (x[1] + x[2] + y[2] - 15) ^ 2))
    return model
end
