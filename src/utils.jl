@inline _host_array(x::Array) = x
@inline _host_array(x::AbstractArray) = Array(x)

@inline _plot_matrix_data(x::AbstractMatrix{Bool}) = Float64.(_host_array(x))
@inline _plot_matrix_data(x::AbstractMatrix) = _host_array(x)

@inline _plot_vector_data(x::Vector) = x
@inline _plot_vector_data(x::AbstractVector) = collect(x)

function _apply_image_stretch(data::AbstractMatrix, stretch::Symbol)
    if stretch === :linear
        return data
    elseif stretch === :log10
        floor = eps(real(eltype(data)))
        return log10.(max.(data, floor))
    else
        throw(ArgumentError("unsupported image stretch $(repr(stretch)); expected :linear or :log10"))
    end
end

function _heatmap2d(data::AbstractMatrix; title::AbstractString="", xlabel::AbstractString="x",
    ylabel::AbstractString="y", colorbar::Bool=true, aspect_ratio=:equal, kwargs...)
    return Plots.heatmap(data;
        title=title,
        xlabel=xlabel,
        ylabel=ylabel,
        colorbar=colorbar,
        aspect_ratio=aspect_ratio,
        kwargs...)
end
