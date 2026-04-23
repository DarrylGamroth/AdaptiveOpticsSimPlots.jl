# AdaptiveOpticsSimPlots.jl

Optional plotting companion package for `AdaptiveOpticsSim.jl`.

This package keeps plotting out of the simulation core and provides a small,
maintained `Plots.jl` surface built on top of stable `AdaptiveOpticsSim`
accessors.

The plotting package is also the maintained home for full visual examples.
The core `AdaptiveOpticsSim.jl` examples stay plotting-free by design.

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

## Install

For sibling-checkout development:

```julia
using Pkg
Pkg.develop(path="../AdaptiveOpticsSim.jl")
Pkg.develop(path="../AdaptiveOpticsSimPlots.jl")
```

## Visual Examples

Focused maintained examples live under `examples/`:

- `examples/image_formation_visual.jl`
- `examples/detector_visual.jl`
- `examples/dm_visual.jl`
- `examples/wfs_visual.jl`
- `examples/closed_loop_runtime_visual.jl`
- `examples/tutorial_image_formation_visual.jl`
- `examples/tutorial_detector_visual.jl`
- `examples/tutorial_closed_loop_shack_hartmann_visual.jl`
- `examples/tutorial_closed_loop_pyramid_visual.jl`
- `examples/tutorial_closed_loop_bioedge_visual.jl`
- `examples/tutorial_asterism_visual.jl`
- `examples/tutorial_spatial_filter_visual.jl`

These are plain Julia scripts and are directly runnable. There is no second
source tree for notebooks or generated examples.
