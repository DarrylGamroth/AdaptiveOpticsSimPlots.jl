abstract type AbstractAOPlot end

"""
    Pupil()

Select a pupil/support intensity view. Supported inputs include telescope
objects and pupil-like matrices.
"""
struct Pupil <: AbstractAOPlot end

"""
    OPD()

Select an optical-path-difference surface view. Supported inputs include
telescope objects, deformable mirrors, controllable optics, and OPD matrices.
"""
struct OPD <: AbstractAOPlot end

"""
    PSF()

Select a point-spread-function image view for PSF matrices.
"""
struct PSF <: AbstractAOPlot end

"""
    ScienceFrame()

Select a science detector/readout frame view.
"""
struct ScienceFrame <: AbstractAOPlot end

"""
    DetectorFrame()

Select a detector frame view for detector objects, detector-frame matrices, or
wavefront sensors that expose detector camera frames. Shack-Hartmann WFS
objects render as a tiled lenslet spot mosaic.
"""
struct DetectorFrame <: AbstractAOPlot end

"""
    WFSFrame()

Select a wavefront-sensor frame view. Shack-Hartmann WFS objects render as a
tiled detector-like subaperture mosaic.
"""
struct WFSFrame <: AbstractAOPlot end

"""
    Commands()

Select command/actuator values for deformable mirrors and compatible
controllable optics.
"""
struct Commands <: AbstractAOPlot end

"""
    Signal()

Select a one-dimensional signal trace, including WFS slopes and runtime
telemetry signals.
"""
struct Signal <: AbstractAOPlot end

"""
    RuntimeTimeseries()

Select a multi-series telemetry plot from a `NamedTuple` of vectors or a vector
of named-tuple log entries.
"""
struct RuntimeTimeseries <: AbstractAOPlot end
