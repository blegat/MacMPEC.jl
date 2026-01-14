import HTTP
import Gumbo
using Cascadia
# Note: use https://github.com/xiaodaigh/TableScraper.jl/pull/7
import TableScraper
import CSV
using DataFrames

url = "http://wiki.mcs.anl.gov/leyffer/index.php/MacMPEC"
response = HTTP.get(url)
@assert response.status == 200
s = String(response.body)
html = Gumbo.parsehtml(s)
transform(cell) = String(strip(Cascadia.nodeText(cell)))
tables = TableScraper.scrape_tables(html, transform, lowercase ∘ transform)
heading_meaning = DataFrame(tables[1])
heading_meaning[!, :heading] = lowercase.(heading_meaning.heading)
CSV.write(joinpath(@__DIR__, "heading_meaning.csv"), heading_meaning)
collection = DataFrame(tables[2])
CSV.write(joinpath(@__DIR__, "collection.csv"), collection)
