include(joinpath(@__DIR__, "common.jl"))

tel = base_telescope(resolution=24, central_obstruction=0.0)
src = Source(band=:I, magnitude=0.0)
tel.state.opd .= reshape(range(-1.0e-7, 1.0e-7; length=24 * 24), 24, 24)

pyr = PyramidWFS(tel; pupil_samples=4, mode=Diffractive(), modulation=1.0)
measure!(pyr, tel, src)

sh = ShackHartmannWFS(tel; n_lenslets=4)
measure!(sh, tel)

display(Plots.plot(
    aoplot(pyr, WFSFrame(); title="Pyramid Frame"),
    aoplot(pyr, Signal(); title="Pyramid Signal"),
    aoplot(sh, Signal(); title="Shack-Hartmann Signal"),
    layout=(1, 3),
    size=(1200, 360),
))
