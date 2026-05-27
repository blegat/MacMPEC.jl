using JuMP
const _INLINE_DATA = JuMPConverter.AMPL.parse_dat(
    "\n\n# start point close to (0,0)\nlet x[1] := 0.0001;\nlet x[2] := 0.0001;\n\n#solve;\n        \n#display _varname, _var.lb, _var.val , _var.ub, _var.dual;\n#display _conname, _con.lb, _con.body, _con.ub, _con;\n\n",
)

function build_model()
    model = Model()
    @variable(model, x[1:2] >= 0)
    @constraint(model, LCP, x[1] ⟂ x[2])
    @objective(model, Min, 0.5 * ((x[1] - 1) ^ 2 + (x[2] - 1) ^ 2))
    return model
end
