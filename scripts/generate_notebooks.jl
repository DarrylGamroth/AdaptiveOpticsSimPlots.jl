using Literate

function visual_example_sources(source_dir::AbstractString)
    return [
        joinpath(source_dir, "image_formation_visual.jl"),
        joinpath(source_dir, "detector_visual.jl"),
        joinpath(source_dir, "dm_visual.jl"),
        joinpath(source_dir, "wfs_visual.jl"),
        joinpath(source_dir, "closed_loop_runtime_visual.jl"),
        joinpath(source_dir, "tutorial_image_formation_visual.jl"),
        joinpath(source_dir, "tutorial_detector_visual.jl"),
        joinpath(source_dir, "tutorial_closed_loop_shack_hartmann_visual.jl"),
        joinpath(source_dir, "tutorial_closed_loop_pyramid_visual.jl"),
        joinpath(source_dir, "tutorial_closed_loop_bioedge_visual.jl"),
        joinpath(source_dir, "tutorial_asterism_visual.jl"),
        joinpath(source_dir, "tutorial_spatial_filter_visual.jl"),
    ]
end

function expected_notebook_paths(output_dir::AbstractString)
    return [
        joinpath(output_dir, "image_formation_visual.ipynb"),
        joinpath(output_dir, "detector_visual.ipynb"),
        joinpath(output_dir, "dm_visual.ipynb"),
        joinpath(output_dir, "wfs_visual.ipynb"),
        joinpath(output_dir, "closed_loop_runtime_visual.ipynb"),
        joinpath(output_dir, "tutorial_image_formation_visual.ipynb"),
        joinpath(output_dir, "tutorial_detector_visual.ipynb"),
        joinpath(output_dir, "tutorial_closed_loop_shack_hartmann_visual.ipynb"),
        joinpath(output_dir, "tutorial_closed_loop_pyramid_visual.ipynb"),
        joinpath(output_dir, "tutorial_closed_loop_bioedge_visual.ipynb"),
        joinpath(output_dir, "tutorial_asterism_visual.ipynb"),
        joinpath(output_dir, "tutorial_spatial_filter_visual.ipynb"),
    ]
end

function generate_notebooks(;
    source_dir::AbstractString=joinpath(@__DIR__, "..", "examples", "literate"),
    output_dir::AbstractString=joinpath(@__DIR__, "..", "notebooks"),
)
    mkpath(output_dir)
    for source in visual_example_sources(source_dir)
        Literate.notebook(source, output_dir; execute=false)
    end
    return expected_notebook_paths(output_dir)
end

if abspath(PROGRAM_FILE) == @__FILE__
    generated = generate_notebooks()
    foreach(path -> println(path), generated)
end
