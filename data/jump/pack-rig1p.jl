using JuMP
function build_model(; nodes = 1:Nnd, bnd_nodes, int_nodes = nodes diff bnd_nodes, fix_nodes, elements, Omega0, n, h, r, Nnd, i_ref, j_ref, y, u0)
    model = Model()
    @variable(model, 0.6 <= a[0:n] <= 1.0)
    @variable(model, x[i in nodes])
    @variable(model, detJe[(i, j, k) in elements])
    @variable(model, xi[i in nodes])
    @variable(model, u[nodes])
    @variable(model, s1[int_nodes] >= 0.0)
    @variable(model, l[i in int_nodes])
    @variable(model, Au[i in int_nodes])
    @constraint(model, bnd_cond[i in bnd_nodes], u[i] == u0[i])
    @constraint(model, slope[i in 1:n], - 3 * h <= a[i-1] - a[i] <= 3 * h)
    @constraint(model, PDE[i in int_nodes], s1[i] == Au[i] - l[i])
    @constraint(model, obst[i in int_nodes], u[i] - xi[i] ⟂ s1[i])
    @objective(model, Min, h / 2 * sum(a[i] + a[i-1] for i in 1:n) + r * h * h * sum(u[i] - xi[i] for i in Omega0))
    return model
end

function build_model(path::String)
    schema = JuMPConverter.AMPL.DatSchema(
        Dict{Symbol,Int}(
            :n => 0,
            :h => 0,
            :r => 0,
            :Nnd => 0,
            :i_ref => 1,
            :j_ref => 1,
            :y => 1,
            :u0 => 1,
        ),
        [:nodes, :bnd_nodes, :int_nodes, :fix_nodes, :elements, :Omega0],
    )
    data = if isdir(path)
        JuMPConverter.AMPL.read_csv(path, schema)
    else
        JuMPConverter.AMPL.read_dat(path, schema)
    end
    return build_model(; data...)
end
