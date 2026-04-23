include(joinpath(@__DIR__, "common.jl"))

tel = base_telescope(resolution=24, central_obstruction=0.0)
src = Source(band=:I, magnitude=0.0)
atm = KolmogorovAtmosphere(tel; r0=0.2, L0=25.0)
dm = DeformableMirror(tel; n_act=4, influence_width=0.3)
wfs = PyramidWFS(tel; n_subap=4, mode=Diffractive(), modulation=1.0)
sim = AOSimulation(tel, src, atm, dm, wfs)

branch = RuntimeBranch(
    :main,
    sim,
    NullReconstructor();
    wfs_detector=Detector(integration_time=1.0, noise=NoiseNone(), qe=1.0, binning=1),
    science_detector=Detector(integration_time=1.0, noise=NoiseNone(), qe=1.0, binning=1),
)
cfg = SingleRuntimeConfig(products=RuntimeProductRequirements(
    slopes=true,
    wfs_pixels=true,
    science_pixels=true,
))
scenario = build_runtime_scenario(cfg, branch)
prepare!(scenario)

display(Plots.plot(
    aoplot(scenario; surface=:wfs),
    aoplot(scenario; surface=:science),
    aoplot(scenario; surface=:signal),
    layout=(1, 3),
    size=(1200, 360),
))
