using JuMP
function build_model(; nodes = 1:Nnd, bnd_nodes, int_nodes = nodes diff bnd_nodes, elements, Omega0, n, h, Nnd, r, n1, n2, d1, d2, i_ref, j_ref, y, u0)
    model = Model()
    @variable(model, 0.7 <= a[0:n] <= 1.2)
    @variable(model, 0.15 <= w1[n1:n2] <= 0.65)
    @variable(model, 0.15 <= w2[n1:n2] <= 0.65)
    @variable(model, x[i in nodes])
    @variable(model, detJe[(i, j, k) in elements])
    @variable(model, xi[i in nodes])
    @variable(model, u[nodes])
    @variable(model, s1[int_nodes] >= 0.0)
    @variable(model, l[i in int_nodes])
    @variable(model, Au[i in int_nodes])
    @constraint(model, slope_a[i in 1:n], - 3 * h <= a[i-1] - a[i] <= 3 * h)
    @constraint(model, slope_w1[i in n1+1:n2], - 2.5 * h <= w1[i-1] - w1[i] <= 2.5 * h)
    @constraint(model, slope_w2[i in n1+1:n2], - 2.5 * h <= w2[i-1] - w2[i] <= 2.5 * h)
    @constraint(model, lin[i in n1:n2], w1[i] + 0.05 <= w2[i])
    @constraint(model, bnd_cond[i in bnd_nodes], u[i] == u0[i])
    @constraint(model, PDE[i in int_nodes], s1[i] == Au[i] - l[i])
    @constraint(model, obst[i in int_nodes], u[i] - xi[i] ⟂ s1[i])
    @objective(model, Min, sum(s1[i] for i in int_nodes diff Omega0) + r * h ^ 2 * sum(u[i] - xi[i] for i in Omega0))
    return model
end

function build_model(path::String)
    schema = JuMPConverter.AMPL.DatSchema(
        Dict{Symbol,Int}(
            :n => 0,
            :h => 0,
            :Nnd => 0,
            :r => 0,
            :n1 => 0,
            :n2 => 0,
            :d1 => 0,
            :d2 => 0,
            :i_ref => 1,
            :j_ref => 1,
            :y => 1,
            :u0 => 1,
        ),
        [:nodes, :bnd_nodes, :int_nodes, :elements, :Omega0],
    )
    data = if isdir(path)
        JuMPConverter.AMPL.read_csv(path, schema)
    else
        JuMPConverter.AMPL.read_dat(path, schema)
    end
    return build_model(; data...)
end
