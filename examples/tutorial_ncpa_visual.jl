include(joinpath(@__DIR__, "common.jl"))

tel = base_telescope(resolution=24, central_obstruction=0.0)
src = base_source()
dm = DeformableMirror(tel; n_act=4, influence_width=0.35)
atm = KolmogorovAtmosphere(tel; r0=0.18, L0=25.0)
ncpa = NCPA(tel, dm, atm; basis=ZernikeModalBasis(), coefficients=[0.0, 30e-9, -20e-9, 10e-9])
apply!(ncpa, tel, DMReplace())
psf = copy(compute_psf!(tel, src; zero_padding=2))

display(Plots.plot(
    aoplot(tel.state.opd, OPD(); title="NCPA OPD"),
    aoplot(psf, PSF(); title="NCPA PSF"),
    layout=(1, 2),
    size=(900, 380),
))
