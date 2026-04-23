include(joinpath(@__DIR__, "common.jl"))

result = run_closed_loop_example(
    (tel, n_subap) -> PyramidWFS(tel; n_subap=n_subap, mode=Diffractive(), modulation=1.0,
        modulation_points=4, diffraction_padding=2);
    n_iter=8,
)

display(Plots.plot(
    plot_runtime_timeseries(
        (residual_before=result.residual_before, residual_after=result.residual_after);
        title="Residual RMS",
        ylabel="meters",
    ),
    plot_signal_trace(result.final_slopes; title="Final Pyramid Signal", ylabel="signal"),
    plot_psf(result.final_psf; title="Final PSF"),
    layout=(1, 3),
    size=(1300, 360),
))
