module AirfoilTools

export read_airfoil

# read file contents, one line at a time 
function read_airfoil(airfoil_file::String)

    # read entire file into a string
    airfoil_file = open(airfoil_file, "r")
    airfoil_lines = readlines(airfoil_file)       
    close(airfoil_file)

    popfirst!(airfoil_lines) # remove first line
    airfoil_lines = map(x -> split(x), airfoil_lines)
    airfoil_points_x = map(x -> parse(Float64, x[1]), airfoil_lines)
    airfoil_points_y = map(x -> parse(Float64, x[2]), airfoil_lines)

    airfoil_points = hcat(airfoil_points_x, airfoil_points_y)

    return airfoil_points
end

end