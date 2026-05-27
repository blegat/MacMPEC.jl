using JuMP
const _INLINE_DATA = JuMPConverter.AMPL.parse_dat(
    "\n\n# starting point \nlet x := 1;\nlet z := 1;\nlet w := 1;\n\n\nlet x :=   0.183193 ;\nlet z := 0.428106;\nlet w := 3.00379;\n\n\n\n        \n\n",
)

function build_model()
    model = Model()
    @variable(model, x)
    @variable(model, z)
    @variable(model, w >= 0)
    @constraint(model, con1, z - 3 + 2 * z * w == 0)
    @constraint(model, con2, 0 >= z ^ 2 - x ⟂ w)
    @objective(model, Min, (x - 3.5) ^ 2 + (z + 4) ^ 2)
    return model
end
