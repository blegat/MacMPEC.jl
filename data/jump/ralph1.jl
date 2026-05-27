using JuMP
function build_model()
    model = Model()
    @variable(model, x >= 0)
    @variable(model, y >= 0)
    @constraint(model, compl, y - x ⟂ y)
    @objective(model, Min, x - y)
    return model
end
