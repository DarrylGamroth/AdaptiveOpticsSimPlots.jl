include(joinpath(@__DIR__, "common.jl"))

tel = base_telescope(resolution=32, central_obstruction=0.14)
src = Source(band=:I, magnitude=0.0)
tel.state.opd .= reshape(range(-2.0e-7, 2.0e-7; length=32 * 32), 32, 32)

dm = DeformableMirror(tel; n_act=6, influence_width=0.3)
dm.state.coefs .= range(-0.05, 0.05; length=length(dm.state.coefs))
apply_opd!(dm, tel)

display(Plots.plot(
    aoplot(tel, Pupil(); title="Pupil"),
    aoplot(tel, OPD(); title="OPD"),
    aoplot(compute_psf!(tel, src; zero_padding=2), PSF(); title="PSF"),
    aoplot(dm, Commands(); title="DM Commands"),
    layout=(2, 2),
    size=(900, 720),
))
