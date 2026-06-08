using JuMP
const _INLINE_DATA = JuMPConverter.AMPL.parse_dat(
    "\n\nlet x[1] :=  0;\nlet x[2] :=  2;\n\n\n        \n\n",
)

function build_model()
    model = Model()
    @variable(model, x[1:2] >= 0)
    @variable(model, y[1:6])
    @variable(model, l[1:4])
    @constraint(model, c1, x[1] ^ 2 + 2 * x[2] <= 4)
    @constraint(model, F1, 0 == 2 * y[1] + 2 * y[3] - 3 * y[4] - y[5])
    @constraint(model, F2, 0 == - 5 - y[3] + 4 * y[4] - y[6])
    @constraint(model, F3, 0 == x[1] ^ 2 - 2 * x[1] + x[2] ^ 2 - 2 * y[1] + y[2] + 3 - (l[1]))
    @constraint(model, F4, 0 == x[2] + 3 * y[1] - 4 * y[2] - 4 - (l[2]))
    @constraint(model, F5, 0 == y[1] - (l[3]))
    @constraint(model, F6, 0 == y[2] - (l[4]))
    @constraint(model, g1, l[1] ⟂ y[3])
    @constraint(model, g2, l[2] ⟂ y[4])
    @constraint(model, g3, l[3] ⟂ y[5])
    @constraint(model, g4, l[4] ⟂ y[6])
    @objective(model, Min, - x[1] ^ 2 - 3 * x[2] - 4 * y[1] + y[2] ^ 2)
    return model
end
