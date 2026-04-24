include(joinpath(@__DIR__, "common.jl"))

result = run_closed_loop_example(
    (tel, n_subap) -> BioEdgeWFS(tel; n_subap=n_subap, mode=Diffractive(), diffraction_padding=2);
    n_iter=8,
)

display(Plots.plot(
    aoplot(
        (residual_before=result.residual_before, residual_after=result.residual_after), RuntimeTimeseries();
        title="Residual RMS",
        ylabel="meters",
    ),
    aoplot(result.final_slopes, Signal(); title="Final BioEdge Signal", ylabel="signal"),
    aoplot(result.final_psf, PSF(); title="Final PSF"),
    layout=(1, 3),
    size=(1300, 360),
))
