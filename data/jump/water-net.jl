using JuMP
function build_model(; nodes, reservoirs, consumers, arcs, demand, height, x, y, supply, wcost, pcost, dist, dpow, dmin, dmax, hloss, dprc, cpow, r, maxq, davg, rr, hl)
    model = Model()
    @variable(model, 0 <= qp[arcs] <= maxq)
    @variable(model, 0 <= qn[arcs] <= maxq)
    @variable(model, dmin <= d[arcs] <= dmax)
    @variable(model, h[i in nodes] >= hl[i])
    @variable(model, 0 <= s[i in reservoirs] <= supply[i])
    @constraint(model, cont[i in nodes], sum(qp[j, i] - qn[j, i] for (j, i) in arcs) - sum(qp[i, j] - qn[i, j] for (i, j) in arcs) + (if i in reservoirs then s[i]) == demand[i])
    @constraint(model, loss[(i, j) in arcs], (h[i] - h[j]) == (hloss) * dist[i, j] * (qp[i, j] ^ 2 - qn[i, j] ^ 2) / (d[i, j] ^ dpow))
    @constraint(model, compl[(i, j) in arcs], qp[i, j] ⟂ qn[i, j])
    @objective(model, Min, (sum(s[i] * pcost[i] * (h[i] - height[i]) for i in reservoirs) + sum(s[i] * wcost[i] for i in reservoirs)) / r + dprc * sum(dist[i, j] * d[i, j] ^ cpow for (i, j) in arcs) + sum(qp[i, j] + qn[i, j] for (i, j) in arcs))
    return model
end

function build_model(path::String)
    schema = JuMPConverter.AMPL.DatSchema(
        Dict{Symbol,Int}(
            :demand => 1,
            :height => 1,
            :x => 1,
            :y => 1,
            :supply => 1,
            :wcost => 1,
            :pcost => 1,
            :dist => 1,
            :dpow => 0,
            :dmin => 0,
            :dmax => 0,
            :hloss => 0,
            :dprc => 0,
            :cpow => 0,
            :r => 0,
            :maxq => 0,
            :davg => 0,
            :rr => 0,
            :hl => 1,
        ),
        [:nodes, :reservoirs, :consumers, :arcs],
    )
    data = if isdir(path)
        JuMPConverter.AMPL.read_csv(path, schema)
    else
        JuMPConverter.AMPL.read_dat(path, schema)
    end
    return build_model(; data...)
end
