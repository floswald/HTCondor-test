
using DataFrames
using Plots

p = plot(title = "empty plot")
savefig(p,"plot.png")
@info "saved plot"
x = 1
y = 2
println("running computation inside script")
z = x+y
