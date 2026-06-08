The `collection.csv` and `heading_meaning.csv` are created by `scraper.jl`.

The `ampl` folder cannot be simply untar'ed from: http://www.mcs.anl.gov/~leyffer/macmpec/MacMPEC.tar.gz
because this tar is slightly outdated.
Instead, it is obtained by running `download.jl`.

To convert the AMPL files in the `ampl` folder to JuMP files in the `JuMP` folder, use `convert.jl`.
Don't modify the files in the `JuMP` folder, they are automatically generated.
