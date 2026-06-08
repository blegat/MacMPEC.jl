using JuMP
function build_model()
    model = Model()
    @variable(model, x >= 0)
    @variable(model, y[1:2])
    @constraint(model, lin_cs, y[2] >= 0)
    @constraint(model, nln_cs, - exp(x) + y[1] - exp(y[2]) ⟂ x)
    @objective(model, Min, (x + 1) ^ 2 + y[1] ^ 2 + 10 * (y[2] + 1) ^ 2)
    return model
end
