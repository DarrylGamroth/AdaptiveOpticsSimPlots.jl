# Shared setup helpers for visual examples.

using AdaptiveOpticsSim
using AdaptiveOpticsSimPlots
using Plots

function build_visual_optics(; resolution::Int=32)
    tel = Telescope(
        resolution=resolution,
        diameter=8.0,
        sampling_time=1e-3,
        central_obstruction=0.14,
    )
    src = Source(band=:I, magnitude=0.0)
    tel.state.opd .= reshape(range(-2.0e-7, 2.0e-7; length=resolution * resolution), resolution, resolution)
    dm = DeformableMirror(tel; n_act=6, influence_width=0.3)
    dm.state.coefs .= range(-0.05, 0.05; length=length(dm.state.coefs))
    apply_opd!(dm, tel)
    return (; tel, src, dm)
end

function build_visual_detector(; resolution::Int=32)
    (; tel, src, dm) = build_visual_optics(; resolution)
    det = Detector(integration_time=1.0, noise=NoiseNone(), qe=1.0, binning=1)
    frame = capture!(det, fill(1.0, 12, 12))
    return (; tel, src, dm, det, frame)
end

function build_visual_wfs(; resolution::Int=24)
    tel = Telescope(
        resolution=resolution,
        diameter=8.0,
        sampling_time=1e-3,
        central_obstruction=0.0,
    )
    src = Source(band=:I, magnitude=0.0)
    tel.state.opd .= reshape(range(-1.0e-7, 1.0e-7; length=resolution * resolution), resolution, resolution)
    pyr = PyramidWFS(tel; n_subap=4, mode=Diffractive(), modulation=1.0)
    measure!(pyr, tel, src)
    sh = ShackHartmann(tel; n_subap=4)
    measure!(sh, tel)
    return (; tel, src, pyr, sh)
end

function build_visual_runtime(; resolution::Int=24)
    tel = Telescope(
        resolution=resolution,
        diameter=8.0,
        sampling_time=1e-3,
        central_obstruction=0.0,
    )
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
    return (; tel, src, atm, dm, wfs, scenario)
end

function core_tutorials_dir()
    return joinpath(pkgdir(AdaptiveOpticsSim), "examples", "tutorials")
end

function load_core_tutorial(script_name::AbstractString)
    mod = Core.eval(Main, :(module $(gensym(:AdaptiveOpticsSimTutorial)) end))
    Base.include(mod, joinpath(core_tutorials_dir(), script_name))
    return mod
end

function run_core_tutorial(script_name::AbstractString; kwargs...)
    mod = load_core_tutorial(script_name)
    main_fn = Base.invokelatest(getfield, mod, :main)
    return Base.invokelatest(main_fn; kwargs...)
end
