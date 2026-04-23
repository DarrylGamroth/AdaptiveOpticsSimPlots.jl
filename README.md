# AdaptiveOpticsSimPlots.jl

Optional plotting companion package for `AdaptiveOpticsSim.jl`.

This package keeps plotting out of the simulation core and provides a small,
maintained `Plots.jl` surface built on top of stable `AdaptiveOpticsSim`
accessors.

## API

The public entrypoints are:

- `aoplot`
- `plot_pupil`
- `plot_opd`
- `plot_psf`
- `plot_science_frame`
- `plot_detector_frame`
- `plot_wfs_frame`
- `plot_dm_commands`
- `plot_dm_opd`
- `plot_signal_trace`
- `plot_runtime_timeseries`

The package uses multiple dispatch on its own `aoplot` function rather than
extending `Plots.plot` directly. That avoids type piracy while still giving a
dispatch-driven surface for `AdaptiveOpticsSim` objects.
