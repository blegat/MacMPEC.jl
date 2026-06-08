using JuMP
const _INLINE_DATA = JuMPConverter.AMPL.parse_dat(
    "\n\nlet x := 7.5;\nlet u := 1;\n\n\n",
)

function build_model()
    model = Model()
    @variable(model, 0 <= x <= 15)
    @variable(model, y >= 0)
    @variable(model, u >= 0)
    @constraint(model, Fy, 4 * (x + 2 * y - 30) + u ⟂ y)
    @constraint(model, Fu, 20 - x - y ⟂ u)
    @objective(model, Min, x ^ 2 + (y - 10) ^ 2)
    return model
end
