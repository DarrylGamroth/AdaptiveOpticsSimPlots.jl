function plot_pupil(mask::AbstractMatrix; title::AbstractString="Pupil", kwargs...)
    return _heatmap2d(_plot_matrix_data(mask); title=title, kwargs...)
end

plot_pupil(tel::AdaptiveOpticsSim.AbstractTelescope; kwargs...) =
    plot_pupil(AdaptiveOpticsSim.pupil_mask(tel); kwargs...)

function plot_opd(opd::AbstractMatrix; title::AbstractString="OPD", kwargs...)
    return _heatmap2d(_plot_matrix_data(opd); title=title, kwargs...)
end

plot_opd(tel::AdaptiveOpticsSim.AbstractTelescope; kwargs...) =
    plot_opd(AdaptiveOpticsSim.opd_map(tel); kwargs...)

function plot_psf(psf::AbstractMatrix; stretch::Symbol=:log10, title::AbstractString="PSF", kwargs...)
    data = _apply_image_stretch(_plot_matrix_data(psf), stretch)
    return _heatmap2d(data; title=title, kwargs...)
end

plot_science_frame(frame::AbstractMatrix; stretch::Symbol=:log10, title::AbstractString="Science Frame", kwargs...) =
    plot_psf(frame; stretch=stretch, title=title, kwargs...)

function plot_science_frame(x; stretch::Symbol=:log10, kwargs...)
    frame = AdaptiveOpticsSim.science_frame(x)
    isnothing(frame) && throw(ArgumentError("object of type $(typeof(x)) does not expose a science frame"))
    return plot_science_frame(frame; stretch=stretch, kwargs...)
end

plot_detector_frame(frame::AbstractMatrix; title::AbstractString="Detector Frame", kwargs...) =
    _heatmap2d(_plot_matrix_data(frame); title=title, kwargs...)

plot_detector_frame(det::AdaptiveOpticsSim.AbstractDetector; title::AbstractString="Detector Frame", kwargs...) =
    plot_detector_frame(AdaptiveOpticsSim.output_frame(det); title=title, kwargs...)

plot_wfs_frame(frame::AbstractMatrix; title::AbstractString="WFS Frame", kwargs...) =
    _heatmap2d(_plot_matrix_data(frame); title=title, kwargs...)

function plot_wfs_frame(wfs::AdaptiveOpticsSim.AbstractWFS; title::AbstractString="WFS Frame", kwargs...)
    frame = AdaptiveOpticsSim.camera_frame(wfs)
    isnothing(frame) && throw(ArgumentError("WFS of type $(typeof(wfs)) does not expose a camera frame"))
    return plot_wfs_frame(frame; title=title, kwargs...)
end

function plot_wfs_frame(x; title::AbstractString="WFS Frame", kwargs...)
    frame = AdaptiveOpticsSim.wfs_frame(x)
    isnothing(frame) && throw(ArgumentError("object of type $(typeof(x)) does not expose a WFS frame"))
    return plot_wfs_frame(frame; title=title, kwargs...)
end
