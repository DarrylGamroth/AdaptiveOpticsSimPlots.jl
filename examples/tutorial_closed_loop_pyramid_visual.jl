include(joinpath(@__DIR__, "common.jl"))

result = run_closed_loop_example(
    (tel, pupil_samples) -> PyramidWFS(tel; pupil_samples=pupil_samples, mode=Diffractive(), modulation=1.0,
        modulation_points=4, diffraction_padding=2);
    n_iter=8,
)

display(Plots.plot(
    aoplot(
        (residual_before=result.residual_before, residual_after=result.residual_after), RuntimeTimeseries();
        title="Residual RMS",
        ylabel="meters",
    ),
    aoplot(result.final_slopes, Signal(); title="Final Pyramid Signal", ylabel="signal"),
    aoplot(result.final_psf, PSF(); title="Final PSF"),
    layout=(1, 3),
    size=(1300, 360),
))
