using GLMakie, HOHQMesh
import .AirfoilTools as at

airfoil_data = at.read_airfoil("airfoil_folder/naca_2415.txt")
airfoil_data = vcat([1 0],airfoil_data) # add [1,0] no começo 
airfoil_data[end,:] = [1 0]
# adiciona nomeração a esquerda e z=0 na direita
airfoil_data = hcat(LinRange(0,1,size(airfoil_data)[1]), hcat(airfoil_data, zeros(size(airfoil_data)[1])))

#  start project
airfoil_mesh_project = newProject("airfoilMesh", "meshOut")

# add airfoil spline to project
airfoil_spline = newSplineCurve("airfoil", size(airfoil_data)[1], airfoil_data)
addCurveToInnerBoundary!(airfoil_mesh_project, airfoil_spline, "inner_spline")

# add background grid
bounds = [3.0, -3.0, -3.0, 4.0] #[top, left, bottom, right]
N = [100, 100, 0]
addBackgroundGrid!(airfoil_mesh_project, bounds, N)

# refine mesh around airfoil than trailing and leading edge
rAF = newRefinementLine("Airfoil refinement", "smooth", [0.0,0.0,0.0], [1.0,0.0,0.0], 0.015, 0.5) 
addRefinementRegion!(airfoil_mesh_project, rAF)
rTE = newRefinementCenter("TE refinement", "smooth", [1.0,0.0,0.0], 0.015, 0.25)
addRefinementRegion!(airfoil_mesh_project, rTE)
rLE = newRefinementCenter("LE refinement", "smooth", [0.0,0.0,0.0], 0.015, 0.25)
addRefinementRegion!(airfoil_mesh_project, rLE)

# add smoothing
addSpringSmoother!(airfoil_mesh_project, "ON", "LinearAndCrossbarSpring", 10) # nIterations

# generate mesh
generate_mesh(airfoil_mesh_project)

plotProject!(airfoil_mesh_project, MODEL+MESH)