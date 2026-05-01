ENV["GKSwstype"] = get(ENV, "GKSwstype", "100")

using Test
using AdaptiveOpticsSim
using AdaptiveOpticsSimPlots
using Plots

function include_script_in_fresh_module(path::AbstractString)
    mod = Core.eval(Main, :(module $(gensym(:AdaptiveOpticsSimPlotsExample)) end))
    Base.include(mod, path)
    return mod
end

@testset "AdaptiveOpticsSimPlots" begin
    @test :plot_pupil ∉ names(AdaptiveOpticsSimPlots)
    @test :plot_wfs_frame ∉ names(AdaptiveOpticsSimPlots)
    @test :plot_signal_trace ∉ names(AdaptiveOpticsSimPlots)

    tel = Telescope(resolution=16, diameter=8.0, sampling_time=1e-3, central_obstruction=0.0)
    tel.state.opd .= reshape(range(-1.0, 1.0; length=16 * 16), 16, 16)
    src = Source(band=:I, magnitude=0.0)
    dm = DeformableMirror(tel; n_act=4, influence_width=0.3)
    dm.state.coefs .= range(-0.2, 0.2; length=length(dm.state.coefs))
    apply_opd!(dm, tel)

    det = Detector(integration_time=1.0, noise=NoiseNone(), qe=1.0, binning=1)
    det_frame = capture!(det, fill(1.0, 8, 8))
    @test size(det_frame) == (8, 8)

    pyr = PyramidWFS(tel; pupil_samples=4, mode=Diffractive(), modulation=1.0)
    measure!(pyr, tel, src)
    bio = BioEdgeWFS(tel; pupil_samples=4, mode=Diffractive(), modulation=1.0)
    measure!(bio, tel, src)
    zwfs = ZernikeWFS(tel; pupil_samples=4)
    measure!(zwfs, tel, src)
    curv = CurvatureWFS(tel; pupil_samples=4)
    measure!(curv, tel, src)
    sh = ShackHartmannWFS(tel; n_lenslets=4, mode=Diffractive(), pixel_scale=0.1, n_pix_subap=6)
    prepare_runtime_wfs!(sh, tel, src)
    measure!(sh, tel, src)

    plt_pupil = aoplot(tel, Pupil())
    plt_opd = aoplot(tel, OPD())
    plt_psf = aoplot(fill(1.0, 8, 8), PSF())
    plt_science = aoplot(fill(1.0, 8, 8), ScienceFrame())
    plt_detector = aoplot(det, DetectorFrame())
    plt_wfs = aoplot(pyr, WFSFrame())
    plt_pyr_detector = aoplot(pyr, DetectorFrame())
    plt_bio_detector = aoplot(bio, DetectorFrame())
    plt_zwfs_detector = aoplot(zwfs, DetectorFrame())
    plt_curv_detector = aoplot(curv, DetectorFrame())
    plt_sh_detector = aoplot(sh, DetectorFrame())
    plt_dm = aoplot(dm, Commands())
    plt_dm_opd = aoplot(dm, OPD())
    plt_signal = aoplot(collect(1.0:8.0), Signal())
    plt_runtime_named = aoplot((residual=collect(1.0:5.0), strehl=collect(5.0:-1.0:1.0)), RuntimeTimeseries())
    plt_runtime_log = aoplot([(residual=i, strehl=6 - i) for i in 1:5], RuntimeTimeseries())

    @test plt_pupil isa Plots.Plot
    @test plt_opd isa Plots.Plot
    @test plt_psf isa Plots.Plot
    @test plt_science isa Plots.Plot
    @test plt_detector isa Plots.Plot
    @test plt_wfs isa Plots.Plot
    @test plt_pyr_detector isa Plots.Plot
    @test plt_bio_detector isa Plots.Plot
    @test plt_zwfs_detector isa Plots.Plot
    @test plt_curv_detector isa Plots.Plot
    @test plt_sh_detector isa Plots.Plot
    @test plt_dm isa Plots.Plot
    @test plt_dm_opd isa Plots.Plot
    @test plt_signal isa Plots.Plot
    @test plt_runtime_named isa Plots.Plot
    @test plt_runtime_log isa Plots.Plot

    @test aoplot(tel, Pupil()) isa Plots.Plot
    @test aoplot(tel, OPD()) isa Plots.Plot
    @test aoplot(det, DetectorFrame()) isa Plots.Plot
    @test aoplot(pyr, WFSFrame()) isa Plots.Plot
    @test aoplot(pyr, DetectorFrame()) isa Plots.Plot
    @test aoplot(bio, DetectorFrame()) isa Plots.Plot
    @test aoplot(zwfs, DetectorFrame()) isa Plots.Plot
    @test aoplot(curv, DetectorFrame()) isa Plots.Plot
    @test aoplot(pyr, Signal()) isa Plots.Plot
    @test aoplot(sh, DetectorFrame()) isa Plots.Plot
    @test aoplot(sh, DetectorFrame()) isa Plots.Plot
    @test aoplot(sh, Signal()) isa Plots.Plot
    @test aoplot(dm, Commands()) isa Plots.Plot
    @test aoplot(dm, OPD()) isa Plots.Plot
    @test aoplot(collect(1.0:4.0), Signal()) isa Plots.Plot

    sampled_topology = SampledActuatorTopology(AdaptiveOpticsSim.actuator_coordinates(dm)[:, 1:4];
        metadata=(manufacturer=:alpao,))
    measured_modes = Array(dm.state.modes[:, 1:4])
    sampled_dm = DeformableMirror(tel; topology=sampled_topology,
        influence_model=MeasuredInfluenceFunctions(measured_modes))
    sampled_dm.state.coefs .= [0.1, -0.2, 0.3, -0.4]
    @test aoplot(sampled_dm, Commands()) isa Plots.Plot

    atm = KolmogorovAtmosphere(tel; r0=0.2, L0=25.0)
    runtime_sim = AOSimulation(tel, src, atm, dm, pyr)
    runtime_branch = ControlLoopBranch(
        :main,
        runtime_sim,
        NullReconstructor();
        wfs_detector=Detector(integration_time=1.0, noise=NoiseNone(), qe=1.0, binning=1),
        science_detector=Detector(integration_time=1.0, noise=NoiseNone(), qe=1.0, binning=1),
    )
    runtime_cfg = SingleControlLoopConfig(outputs=RuntimeOutputRequirements(
        slopes=true,
        wfs_pixels=true,
        science_pixels=true,
    ))
    runtime_scenario = build_control_loop_scenario(runtime_cfg, runtime_branch)
    prepare!(runtime_scenario)
    @test aoplot(runtime_scenario, WFSFrame()) isa Plots.Plot
    @test aoplot(runtime_scenario, ScienceFrame()) isa Plots.Plot
    @test aoplot(runtime_scenario, Signal()) isa Plots.Plot

    sh_image = shack_hartmann_detector_image(sh; gap=2)
    @test size(sh_image) == (4 * 6 + 3 * 2, 4 * 6 + 3 * 2)
    @test size(shack_hartmann_detector_image(sh)) == (4 * 6, 4 * 6)
    @test_throws MethodError aoplot(tel)
    @test_throws MethodError aoplot(dm)
    @test_throws MethodError aoplot(runtime_scenario)
    @test_throws MethodError aoplot(tel; surface=:opd)
    @test_throws MethodError aoplot(sh; kind=:signal)
end

@testset "Visual example scripts" begin
    example_dir = joinpath(@__DIR__, "..", "examples")
    scripts = filter(readdir(example_dir)) do file
        endswith(file, ".jl") && file != "common.jl"
    end
    for script in sort(scripts)
        source = read(joinpath(example_dir, script), String)
        @test length(collect(eachmatch(r"display\(", source))) <= 1
        @test !occursin(r"\bplot_[A-Za-z0-9_]+", source)
        @test !occursin(r"aoplot\([^\n;]+; (kind|surface)", source)
        includes = collect(eachmatch(r"include\(joinpath\(@__DIR__, \"([^\"]+)\"\)\)", source))
        @test all(match.captures[1] == "common.jl" for match in includes)
        include_script_in_fresh_module(joinpath(example_dir, script))
    end
    @test true
end
